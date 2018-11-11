--create extension pgcrypto;

create table states
(
  id uuid primary key default gen_random_uuid(),
  name varchar(128) not null,
  abbr varchar(2) not null
);

create table cities
(
  id uuid default gen_random_uuid(),
  state_id uuid not null references states (id),
  name varchar(256) not null,

  primary key (id, state_id)
);

create table clients
(
  id uuid primary key default gen_random_uuid(),
  created_at timestamp not null default current_timestamp
);

create table addresses
(
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references profiles (id),
  city_id uuid not null,
  state_id uuid not null,
  street varchar(1024) not null,
  district varchar(1024) not null,
  zipcode varchar(128) not null,

  foreign key (city_id, state_id) references cities (id, state_id),
  unique (profile_id)
);

create table contact_types
(
  id uuid primary key default gen_random_uuid(),
  name varchar(128) not null,
  description varchar(1024)
);

create table user_characteristics
(
  id uuid primary key default gen_random_uuid(),
  name varchar(256) not null,
  description varchar(1024)
);

create table profile_schemas
(
  id uuid primary key default gen_random_uuid(),
  name varchar(256) not null,
  description varchar(1024)
);

create table schema_characteristics
(
  id uuid primary key default gen_random_uuid(),
  profile_schema_id uuid not null references profile_schemas (id),
  characteristic_id uuid not null references user_characteristics (id),
  is_nullable boolean,

  unique (profile_schema_id, characteristic_id)
);

create table profiles
(
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references clients (id),
  profile_schema_id uuid not null references profile_schemas (id),
  address_id uuid not null references addresses (id),
  created_at timestamp not null default current_timestamp,

  unique (client_id, profile_schema_id)
);

create table contacts
(
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles (id),
  contact_type_id uuid not null references contact_types (id),
  contact_info varchar(256)
);

create table profile_characteristics
(
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles (id),
  schema_characteristic_id uuid not null references schema_characteristics (id),
  characteristic_info varchar(1024) not null,

  unique (profile_id, schema_characteristic_id)
);

create table payment_methods
(
  id uuid primary key default gen_random_uuid(),
  name varchar(128) not null
);

create table sales
(
  id uuid primary key default gen_random_uuid(),
  receiver_profile_id uuid references profiles (id),
  executor_profile_id uuid not null references profiles (id),
  client_profile_id uuid not null references profiles (id),
  payment_method_id uuid not null references payment_methods (id),
  date timestamp not null default current_timestamp,
  discount numeric
);

create table payments
(
  id uuid primary key default gen_random_uuid(),
  sale_id uuid not null references sales (id),
  expected_date date not null,
  actual_date date,
  expected_value numeric not null,
  actual_value numeric
);

create table invoices
(
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles (id),
  version numeric not null,
  xml text not null
);

create table statuses
(
  id uuid primary key default gen_random_uuid(),
  name varchar(128) not null,
  description varchar(1024)
);

create table item_categories
(
  id uuid primary key default gen_random_uuid(),
  name varchar(128) not null
);

create table prescriptions
(
  id uuid primary key default gen_random_uuid(),
  profile_owner_id uuid references profiles (id),
  profile_medic_id uuid references profiles (id),
  date date not null
);

create table services
(
  id uuid primary key default gen_random_uuid(),
  sale_id uuid not null references sales (id),
  profile_employee_id uuid not null references profiles (id),
  prescription_id uuid references prescriptions (id),
  invoice_id uuid references invoices (id),
  price numeric not null
);

create table items_stock
(
  id uuid primary key default gen_random_uuid(),
  invoice_id uuid not null references invoices (id),
  category_id uuid not null references item_categories (id),
  service_id uuid references services (id),
  sale_id uuid references sales (id),
  description varchar(1024),
  cost_price numeric not null,
  sale_price_spot numeric not null,
  sale_price_forward numeric not null
);

create table service_statuses
(
  id uuid primary key default gen_random_uuid(),
  status_id uuid not null references statuses (id),
  service_id uuid not null references services (id),
  profile_id uuid not null references profiles (id),
  visualized boolean not null,
  changed_at timestamp not null default current_timestamp
);

create table tokens
(
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references clients (id),
  token varchar(256) not null,
  type varchar(80) not null,
  is_revoked boolean default false,
  created_at timestamp,
  updated_at timestamp
);

create table prescription_characteristics
(
  id uuid primary key default gen_random_uuid(),
  name varchar(256) not null,
  abbr varchar(32) not null
);

create table prescription_infos
(
  id uuid primary key default gen_random_uuid(),
  prescription_characteristic_id uuid not null references prescription_characteristics (id),
  prescription_id uuid not null references prescriptions (id),
  info numeric not null
);
