from sqlalchemy import MetaData
from sqlalchemy.ext.automap import automap_base

from .engine import engine

base = automap_base()
base.prepare(engine, reflect=True)

State = base.classes.states
City = base.classes.cities
Client = base.classes.clients
Address = base.classes.addresses
ContactType = base.classes.contact_types
Characteristic = base.classes.characteristics
ProfileSchema = base.classes.profile_schemas
SchemaCharacteristic = base.classes.schema_characteristics
Profile = base.classes.profiles
Contact = base.classes.contacts
ProfileCharacteristic = base.classes.profile_characteristics
PaymentMethod = base.classes.payment_methods
Sale = base.classes.sales
Payment = base.classes.payments
Invoice = base.classes.invoices
Status = base.classes.statuses
ItemCategory = base.classes.item_categories
Service = base.classes.services
Item = base.classes.items_stock
ServiceStatus = base.classes.service_statuses
Token = base.classes.tokens
