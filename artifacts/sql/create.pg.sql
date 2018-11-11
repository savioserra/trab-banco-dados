--CREATE EXTENSION PGCRYPTO;

CREATE TABLE STATES
(
  ID   UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  NAME VARCHAR(128) NOT NULL,
  ABBR VARCHAR(2)   NOT NULL
);

CREATE TABLE CITIES
(
  ID       UUID DEFAULT GEN_RANDOM_UUID(),
  STATE_ID UUID         NOT NULL REFERENCES STATES (ID),
  NAME     VARCHAR(256) NOT NULL,

  PRIMARY KEY (ID, STATE_ID)
);

CREATE TABLE CLIENTS
(
  ID         UUID PRIMARY KEY   DEFAULT GEN_RANDOM_UUID(),
  CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ADDRESSES
(
  ID       UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  CITY_ID  UUID          NOT NULL,
  STATE_ID UUID          NOT NULL,
  STREET   VARCHAR(1024) NOT NULL,
  DISTRICT VARCHAR(1024) NOT NULL,
  ZIPCODE  VARCHAR(128)  NOT NULL,

  FOREIGN KEY (CITY_ID, STATE_ID) REFERENCES CITIES (ID, STATE_ID)
);

CREATE TABLE CONTACT_TYPES
(
  ID          UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  NAME        VARCHAR(128) NOT NULL,
  DESCRIPTION VARCHAR(1024)
);

CREATE TABLE CHARACTERISTICS
(
  ID          UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  NAME        VARCHAR(256) NOT NULL,
  DESCRIPTION VARCHAR(1024)
);

CREATE TABLE PROFILE_SCHEMAS
(
  ID          UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  NAME        VARCHAR(256) NOT NULL,
  DESCRIPTION VARCHAR(1024)
);

CREATE TABLE SCHEMA_CHARACTERISTICS
(
  ID                UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  PROFILE_SCHEMA_ID UUID NOT NULL REFERENCES PROFILE_SCHEMAS (ID),
  CHARACTERISTIC_ID UUID NOT NULL REFERENCES CHARACTERISTICS (ID),
  IS_NULLABLE       BOOLEAN,

  UNIQUE (PROFILE_SCHEMA_ID, CHARACTERISTIC_ID)
);

CREATE TABLE PROFILES
(
  ID                UUID PRIMARY KEY   DEFAULT GEN_RANDOM_UUID(),
  CLIENT_ID         UUID      NOT NULL REFERENCES CLIENTS (ID),
  PROFILE_SCHEMA_ID UUID      NOT NULL REFERENCES PROFILE_SCHEMAS (ID),
  ADDRESS_ID        UUID      NOT NULL REFERENCES ADDRESSES (ID),
  CREATED_AT        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE (CLIENT_ID, PROFILE_SCHEMA_ID)
);

CREATE TABLE CONTACTS
(
  ID              UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  PROFILE_ID      UUID NOT NULL REFERENCES PROFILES (ID),
  CONTACT_TYPE_ID UUID NOT NULL REFERENCES CONTACT_TYPES (ID),
  CONTACT_INFO    VARCHAR(256)
);

CREATE TABLE PROFILE_CHARACTERISTICS
(
  ID                       UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  PROFILE_ID               UUID          NOT NULL REFERENCES PROFILES (ID),
  SCHEMA_CHARACTERISTIC_ID UUID          NOT NULL REFERENCES SCHEMA_CHARACTERISTICS (ID),
  CHARACTERISTIC_INFO      VARCHAR(1024) NOT NULL,

  UNIQUE (PROFILE_ID, SCHEMA_CHARACTERISTIC_ID)
);

CREATE TABLE PAYMENT_METHODS
(
  ID   UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  NAME VARCHAR(128) NOT NULL
);

CREATE TABLE SALES
(
  ID                  UUID PRIMARY KEY   DEFAULT GEN_RANDOM_UUID(),
  RECEIVER_PROFILE_ID UUID REFERENCES PROFILES (ID),
  EXECUTOR_PROFILE_ID UUID      NOT NULL REFERENCES PROFILES (ID),
  CLIENT_PROFILE_ID   UUID      NOT NULL REFERENCES PROFILES (ID),
  PAYMENT_METHOD_ID   UUID      NOT NULL REFERENCES PAYMENT_METHODS (ID),
  DATE                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  DISCOUNT            NUMERIC
);

CREATE TABLE PAYMENTS
(
  ID             UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  SALE_ID        UUID    NOT NULL REFERENCES SALES (ID),
  EXPECTED_DATE  DATE    NOT NULL,
  ACTUAL_DATE    DATE,
  EXPECTED_VALUE NUMERIC NOT NULL,
  ACTUAL_VALUE   NUMERIC
);

CREATE TABLE INVOICES
(
  ID         UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  PROFILE_ID UUID    NOT NULL REFERENCES PROFILES (ID),
  VERSION    NUMERIC NOT NULL,
  XML        TEXT    NOT NULL
);

CREATE TABLE STATUSES
(
  ID          UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  NAME        VARCHAR(128) NOT NULL,
  DESCRIPTION VARCHAR(1024)
);

CREATE TABLE ITEM_CATEGORIES
(
  ID   UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  NAME VARCHAR(128) NOT NULL
);

CREATE TABLE SERVICES
(
  ID         UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  SALE_ID    UUID    NOT NULL REFERENCES SALES (ID),
  PROFILE_ID UUID    NOT NULL REFERENCES PROFILES (ID),
  INVOICE_ID UUID REFERENCES INVOICES (ID),
  PRICE      NUMERIC NOT NULL
);

CREATE TABLE ITEMS
(
  ID                 UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  INVOICE_ID         UUID    NOT NULL REFERENCES INVOICES (ID),
  CATEGORY_ID        UUID    NOT NULL REFERENCES ITEM_CATEGORIES (ID),
  SERVICE_ID         UUID REFERENCES SERVICES (ID),
  SALE_ID            UUID REFERENCES SALES (ID),
  DESCRIPTION        VARCHAR(1024),
  COST_PRICE         NUMERIC NOT NULL,
  SALE_PRICE_SPOT    NUMERIC NOT NULL,
  SALE_PRICE_FORWARD NUMERIC NOT NULL
);

CREATE TABLE SERVICE_STATUSES
(
  ID         UUID PRIMARY KEY   DEFAULT GEN_RANDOM_UUID(),
  STATUS_ID  UUID      NOT NULL REFERENCES STATUSES (ID),
  SERVICE_ID UUID      NOT NULL REFERENCES SERVICES (ID),
  PROFILE_ID UUID      NOT NULL REFERENCES PROFILES (ID),
  VISUALIZED BOOLEAN   NOT NULL,
  CHANGED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE TOKENS
(
  ID         UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  CLIENT_ID  UUID         NOT NULL REFERENCES CLIENTS (ID),
  TOKEN      VARCHAR(256) NOT NULL,
  TYPE       VARCHAR(80)  NOT NULL,
  IS_REVOKED BOOLEAN          DEFAULT FALSE,
  CREATED_AT TIMESTAMP,
  UPDATED_AT TIMESTAMP
);
