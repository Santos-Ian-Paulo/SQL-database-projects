CREATE TABLE taxonomic_classes(
	class_id INT PRIMARY KEY,
    class_name VARCHAR(100) UNIQUE,
    phylum VARCHAR(100) NOT NULL,
    description_text TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE species(
	species_id INT PRIMARY KEY,
	class_id INT,
	scientific_name VARCHAR(200) UNIQUE NOT NULL,
	common_name_english VARCHAR(200),
	common_name_filipino VARCHAR(200),
	family VARCHAR(100) NOT NULL,
	order_name VARCHAR(100) NOT NULL,
	genus VARCHAR(100) NOT NULL,
	is_endemic BOOLEAN NOT NULL DEFAULT FALSE,
	is_indigenous BOOLEAN NOT NULL DEFAULT FALSE,
	description_text TEXT,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(class_id) REFERENCES  taxonomic_classes(class_id)
);

CREATE TABLE conservation_status(
	status_id INT PRIMARY KEY,
    status_code VARCHAR(10) UNIQUE NOT NULL,
    description_text TEXT,
    severity_level INT NOT NULL
);

CREATE TABLE species_conservation(
	species_conservation_id INT PRIMARY KEY,
    species_id INT NOT NULL,
    status_id INT NOT NULL,
    assesment_date DATE NOT NULL,
    population_trend ENUM('Increasing', 'Stable', 'Decreasing', 'Unknown'),
    source_text VARCHAR(200) NOT NULL,
    notes TEXT,
    FOREIGN KEY(species_id) REFERENCES species(species_id),
    FOREIGN KEY(status_id) REFERENCES conservation_status(status_id)
);

CREATE TABLE regions(
	region_id INT PRIMARY KEY,
    region_name VARCHAR(100) UNIQUE NOT NULL,
    region_code VARCHAR(20) NOT NULL,
    island_group ENUM('Luzon', 'Visayas', 'Mindanao') NOT NULL
);

CREATE TABLE provinces(
	province_id INT PRIMARY KEY,
    region_id INT NOT NULL,
    province_name VARCHAR(100) NOT NULL,
    province_code VARCHAR(20) NOT NULL,
    FOREIGN KEY(region_id)REFERENCES regions(region_id)
);

CREATE TABLE species_distribution(
	distribution_id INT PRIMARY KEY,
    species_id INT NOT NULL,
    province_id INT NOT NULL,
    habitat_type ENUM('Lowland Forest',
    'Montane Forest',
    'Mossy Forest',
    'Mangrove',
    'Grassland',
    'Agricultural',
    'Urban',
    'Freshwater',
    'Marine',
    'Coastal'),
    abundance ENUM('Abundant', 'Common', 'Uncommon', 'Rare', 'Very Rare', 'Extinct'),
    last_observed DATE,
    coordinates POINT,
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY(species_id) REFERENCES species(species_id),
    FOREIGN KEY(province_id)REFERENCES provinces(province_id)
);

CREATE TABLE threats(
	threat_id INT PRIMARY KEY,
    threat_name VARCHAR(100) UNIQUE NOT NULL,
    threat_category ENUM('Habitat Loss',
    'Habitat Degradation',
    'Hunting/Poaching',
    'Invasive Species',
    'Pollution',
    'Climate Change',
    'Disease',
    'Human Disturbance',
    'Natural Disasters') NOT NULL,
    description_text TEXT
);

CREATE TABLE species_threats(
	species_threat_id INT PRIMARY KEY,
    species_id INT NOT NULL,
    threat_id INT NOT NULL,
    severity ENUM('Low', 'Medium', 'High', 'Critical') NOT NULL,
    notes TEXT,
    FOREIGN KEY(species_id)REFERENCES species(species_id),
    FOREIGN KEY(threat_id) REFERENCES threats(threat_id)
);

CREATE TABLE protected_areas(
	area_id INT PRIMARY KEY,
    area_name VARCHAR(200) UNIQUE NOT NULL,
    area_type ENUM('National Park',
    'Wildlife Sanctuary',
    'Protected Landscape',
    'Natural Park',
    'Resource Reserve',
    'Natural Monument',
    'Marine Protected Area') NOT NULL,
    province_id INT NOT NULL,
    size_hectares DECIMAL(12, 2),
    established_date DATE,
    managing_agency VARCHAR(200) NOT NULL,
    FOREIGN KEY(province_id)REFERENCES provinces(province_id)
);

CREATE TABLE species_protected_areas(
	species_area_id INT PRIMARY KEY,
    species_id INT NOT NULL,
    area_id INT NOT NULL,
    population_estimate INT,
    last_survey_date DATE,
    FOREIGN KEY(species_id)REFERENCES species(species_id),
    FOREIGN KEY(area_id)REFERENCES protected_areas(area_id)
);