from sqlalchemy.orm import Session, joinedload
from sqlalchemy.sql.expression import func, select
from src.engine import engine
from src import models
from faker import Faker
from faker.providers import address, misc, phone_number
import random

if __name__ == "__main__":
    faker = Faker()
    faker.add_provider(address)
    faker.add_provider(misc)

    sess = Session(bind=engine)

    sess.add_all([models.Characteristic(name=k) for k in ['Nome', 'Senha', 'Email']])
    sess.add_all([models.ProfileSchema(name=k) for k in ['Cliente', 'Funcionário', 'Empresa']])
    sess.add_all([models.Status(name=k) for k in ['Enviado', 'Disponível', 'Entrege']])
    sess.add_all([models.PaymentMethod(name=k) for k in ['Cartão', 'Dinheiro']])
    sess.add_all([models.ItemCategory(name=k) for k in ['Armação']])
    sess.add_all([models.ContactType(name=k) for k in ['Telefone']])
    sess.add_all([models.State(name=faker.state(), abrev=faker.state_abbr()) for k in range(10)])

    sess.commit()

    states = sess.query(models.State).all()
    sess.add_all([models.City(name=faker.city(), states=random.choice(states)) for k in range(50)])
    sess.commit()

    schemas = sess.query(models.ProfileSchema).all()
    characteristics = sess.query(models.Characteristic).all()
    cities = sess.query(models.City).options(joinedload('*')).all()
    contact_type = sess.query(models.ContactType).first()

    for schema in schemas:
        sess.add_all([
            models.SchemaCharacteristic(profile_schemas=schema, characteristics=k, is_nullable=False)
            for k in characteristics
        ])

    sess.commit()

    for k in range(int(5e2)):
        client = models.Client()

        address = models.Address(
            cities=random.choice(cities),
            street=faker.street_address(),
            district=faker.city_prefix(),
            zipcode=faker.zipcode())

        profile = models.Profile(addresses=address, profile_schemas=random.choice(schemas), clients=client)

        profile_characteristics = [
            models.ProfileCharacteristic(
                profiles=profile,
                schema_characteristics=k,
                characteristic_info=faker.password() if k.characteristics.name == 'Senha' else
                faker.name() if k.characteristics.name == 'Nome' else faker.email())
            for k in sess.query(models.SchemaCharacteristic).options(joinedload('characteristics')).filter(
                models.SchemaCharacteristic.profile_schema_id == profile.profile_schemas.id)
        ]

        contact = models.Contact(
            profiles=profile, contact_types=contact_type, contact_info=faker.phone_number())

        sess.add_all([client, address, profile, *profile_characteristics, contact])

    sess.commit()

    service_statuses = sess.query(models.ServiceStatus).all()
    payment_methods = sess.query(models.PaymentMethod).all()
    category = sess.query(models.ItemCategory).first()

    for k in range(int(1.5e6)):
        profiles = sess.query(models.Profile).order_by(func.random()).limit(4)

        sale = models.Sale(
            receiver_profile_id=profiles[0].id,
            executor_profile_id=profiles[1].id,
            client_profile_id=profiles[2].id,
            payment_method_id=(random.choice(payment_methods)).id)

        invoice = models.Invoice(profiles=profiles[3], version=3, xml='<xml>mimimi</xml>')

        items = [
            models.Item(
                category_id=category.id,
                invoices=invoice,
                sales=sale,
                cost_price=0,
                sale_price=random.randrange(1000)) for k in range(random.randrange(1, 10))
        ]

        sess.add_all([sale, invoice, *items])
        sess.commit()
