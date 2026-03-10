CREATE DATABASE IF NOT EXISTS event_ticketing CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE event_ticketing;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(180) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('PARTICIPANT','ORGANIZER','ADMIN') NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description VARCHAR(2000) NOT NULL,
    category VARCHAR(100) NOT NULL,
    location VARCHAR(200) NOT NULL,
    event_date DATETIME NOT NULL,
    total_tickets INT NOT NULL,
    available_tickets INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    status ENUM('PENDING','APPROVED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    organizer_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_events_organizer FOREIGN KEY (organizer_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tickets (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    participant_id BIGINT NOT NULL,
    event_id BIGINT NOT NULL,
    purchase_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVE','CANCELLED','TRANSFERRED') NOT NULL DEFAULT 'ACTIVE',
    qr_code LONGTEXT,
    payment_id VARCHAR(120),
    CONSTRAINT fk_tickets_participant FOREIGN KEY (participant_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tickets_event FOREIGN KEY (event_id) REFERENCES events(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ticket_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    method VARCHAR(50) NOT NULL,
    status ENUM('PENDING','COMPLETED','REFUNDED') NOT NULL DEFAULT 'PENDING',
    transaction_ref VARCHAR(120) NOT NULL UNIQUE,
    CONSTRAINT fk_payments_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_events_status_date ON events(status, event_date);
CREATE INDEX idx_tickets_participant ON tickets(participant_id);
CREATE INDEX idx_tickets_event ON tickets(event_id);
CREATE INDEX idx_payments_ticket ON payments(ticket_id);
