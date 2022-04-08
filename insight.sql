BEGIN;
DROP TABLE IF EXISTS client_restaurant;
DROP TABLE IF EXISTS dish;
DROP TABLE IF EXISTS restaurant;
DROP TABLE IF EXISTS client;

CREATE TABLE restaurant (
  "id" SERIAL PRIMARY KEY,
  "restaurant_name" VARCHAR(30) NOT NULL,
  "category" VARCHAR(30) NOT NULL,
  "city" VARCHAR(30)  NOT NULL,
  "address" VARCHAR(30)  NOT NULL
);

CREATE TABLE client (
  "id" SERIAL PRIMARY KEY,
  "client_name" VARCHAR(50)  NOT NULL,
  "age" INTEGER  NOT NULL,
  "gender" VARCHAR(6) NOT NULL,
  "occupation" VARCHAR(20) NOT NULL,
  "nationality" VARCHAR(30) NOT NULL
);

CREATE TABLE dish (
  "id" SERIAL PRIMARY KEY,
  "dish_name" VARCHAR(30) NOT NULL,
  "price" INTEGER NOT NULL,
  "restaurant_id" INTEGER NOT NULL REFERENCES restaurant(id) 
);

CREATE TABLE client_restaurant (
  "id" SERIAL PRIMARY KEY,
  "visit_date" DATE NOT NULL,
  "client_id"  INTEGER NOT NULL REFERENCES client(id),
  "dish_id"  INTEGER NOT NULL REFERENCES dish(id),
  "restaurant_id"  INTEGER NOT NULL REFERENCES restaurant(id)
);

COMMIT;