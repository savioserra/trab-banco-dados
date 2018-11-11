create table states (
  id    serial primary key,
  name  varchar(128) not null,
  abrev varchar(2)   not null
);

create table cities (
  id       serial,
  state_id integer      not null references states (id),
  name     varchar(256) not null,

  primary key (id, state_id)
);

create table clients (
  id         serial primary key,
  created_at timestamp not null default current_timestamp
);

create table addresses (
  id       serial primary key,
  city_id  int           not null,
  state_id int           not null,
  street   varchar(1024) not null,
  district varchar(1024) not null,
  zipcode  varchar(128)  not null,

  foreign key (city_id, state_id) references cities (id, state_id)
);

create table contact_types (
  id          serial primary key,
  name        varchar(128) not null,
  description varchar(1024)
);

create table characteristics (
  id          serial primary key,
  name        varchar(256) not null,
  description varchar(1024)
);

create table profile_schemas (
  id          serial primary key,
  name        varchar(256) not null,
  description varchar(1024)
);

create table schema_characteristics (
  id                serial primary key,
  profile_schema_id int not null references profile_schemas (id),
  characteristic_id int not null references characteristics (id),
  is_nullable       boolean,

  unique (profile_schema_id, characteristic_id)
);

create table profiles (
  id                serial primary key,
  client_id         int       not null references clients (id),
  profile_schema_id int       not null references profile_schemas (id),
  address_id        int       not null references addresses (id),
  created_at        timestamp not null default current_timestamp,

  unique (client_id, profile_schema_id)
);

create table contacts (
  id              serial primary key,
  profile_id      int not null references profiles (id),
  contact_type_id int not null references contact_types (id),
  contact_info    varchar(256)
);

create table profile_characteristics (
  id                       serial primary key,
  profile_id               int           not null references profiles (id),
  schema_characteristic_id int           not null references schema_characteristics (id),
  characteristic_info      varchar(1024) not null,

  unique (profile_id, schema_characteristic_id)
);

create table payment_methods (
  id   serial primary key,
  name varchar(128) not null
);

create table sales (
  id                  serial primary key,
  receiver_profile_id int references profiles (id),
  executor_profile_id int       not null references profiles (id),
  client_profile_id   int       not null references profiles (id),
  payment_method_id   int       not null references payment_methods (id),
  date                timestamp not null default current_timestamp,
  discount            numeric
);

create table payments (
  id             serial primary key,
  sale_id        int     not null references sales (id),
  expected_date  date    not null,
  actual_date    date,
  expected_value numeric not null,
  actual_value   numeric
);

create table invoices (
  id         serial primary key,
  profile_id int     not null references profiles (id),
  version    numeric not null,
  xml        text    not null
);

create table statuses (
  id          serial primary key,
  name        varchar(128) not null,
  description varchar(1024)
);

create table item_categories (
  id   serial primary key,
  name varchar(128) not null
);

create table services (
  id         serial primary key,
  sale_id    int not null references sales (id),
  invoice_id int references invoices (id)
);

create table items (
  id          serial primary key,
  invoice_id  int     not null references invoices (id),
  service_id  int references services (id),
  sale_id     int references sales (id),
  category_id int     not null references item_categories (id),
  description varchar(1024),
  cost_price  numeric not null,
  sale_price  numeric not null
);

create table service_statuses (
  id         serial primary key,
  status_id  int       not null references statuses (id),
  service_id int       not null references services (id),
  profile_id int       not null references profiles (id),
  visualized boolean   not null,
  changed_at timestamp not null default current_timestamp
);

create table tokens (
  id         serial       not null primary key,
  client_id  int          not null references clients (id),
  token      varchar(256) not null,
  type       varchar(80)  not null,
  is_revoked boolean default false,
  created_at timestamp,
  updated_at timestamp
);
