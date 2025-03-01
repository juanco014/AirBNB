-- Creación de tablas
CREATE TABLE Users (
    id VARCHAR2(50) PRIMARY KEY,
    updated_at TIMESTAMP,
    created_at TIMESTAMP,
    email VARCHAR2(255) NOT NULL,
    password VARCHAR2(255) NOT NULL,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100)
);

CREATE TABLE State (
    id VARCHAR2(50) PRIMARY KEY,
    updated_at TIMESTAMP,
    created_at TIMESTAMP,
    name VARCHAR2(255) NOT NULL
);

CREATE TABLE City (
    id VARCHAR2(50) PRIMARY KEY,
    updated_at TIMESTAMP,
    created_at TIMESTAMP,
    state_id VARCHAR2(50) NOT NULL,
    name VARCHAR2(255) NOT NULL
);

CREATE TABLE Place (
    id VARCHAR2(50) PRIMARY KEY,
    updated_at TIMESTAMP,
    created_at TIMESTAMP,
    user_id VARCHAR2(50) NOT NULL,
    city_id VARCHAR2(50) NOT NULL,
    name VARCHAR2(255) NOT NULL,
    description VARCHAR2(1000),
    number_rooms INTEGER DEFAULT 0,
    number_bathrooms INTEGER DEFAULT 0,
    max_guest INTEGER DEFAULT 0,
    price_by_night INTEGER DEFAULT 0,
    latitude FLOAT,
    longitude FLOAT
);

CREATE TABLE Review (
    id VARCHAR2(50) PRIMARY KEY,
    updated_at TIMESTAMP,
    created_at TIMESTAMP,
    user_id VARCHAR2(50) NOT NULL,
    place_id VARCHAR2(50) NOT NULL,
    text VARCHAR2(1000) NOT NULL
);

CREATE TABLE Amenity (
    id VARCHAR2(50) PRIMARY KEY,
    updated_at TIMESTAMP,
    created_at TIMESTAMP,
    name VARCHAR2(255) NOT NULL
);

CREATE TABLE PlaceAmenity (
    amenity_id VARCHAR2(50) NOT NULL,
    place_id VARCHAR2(50) NOT NULL
);

-- Definición de claves foráneas
ALTER TABLE City ADD CONSTRAINT fk_city_state FOREIGN KEY (state_id) REFERENCES State(id);
ALTER TABLE Place ADD CONSTRAINT fk_place_user FOREIGN KEY (user_id) REFERENCES Users(id);
ALTER TABLE Place ADD CONSTRAINT fk_place_city FOREIGN KEY (city_id) REFERENCES City(id);
ALTER TABLE Review ADD CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES Users(id);
ALTER TABLE Review ADD CONSTRAINT fk_review_place FOREIGN KEY (place_id) REFERENCES Place(id);
ALTER TABLE PlaceAmenity ADD CONSTRAINT fk_placeamenity_place FOREIGN KEY (place_id) REFERENCES Place(id);
ALTER TABLE PlaceAmenity ADD CONSTRAINT fk_placeamenity_amenity FOREIGN KEY (amenity_id) REFERENCES Amenity(id);
