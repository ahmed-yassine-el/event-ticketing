USE eventapp;

DELETE FROM payments;
DELETE FROM tickets;
DELETE FROM events;
DELETE FROM users;

INSERT INTO users (id, name, email, password_hash, role, created_at, active) VALUES
(1, 'Admin One', 'admin1@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'ADMIN', '2026-01-01 09:00:00', TRUE),
(2, 'Admin Two', 'admin2@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'ADMIN', '2026-01-02 09:30:00', TRUE),
(3, 'Organizer A', 'organizer1@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'ORGANIZER', '2026-01-03 10:00:00', TRUE),
(4, 'Organizer B', 'organizer2@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'ORGANIZER', '2026-01-04 10:30:00', TRUE),
(5, 'Organizer C', 'organizer3@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'ORGANIZER', '2026-01-05 11:00:00', TRUE),
(6, 'Participant A', 'participant1@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'PARTICIPANT', '2026-01-06 11:30:00', TRUE),
(7, 'Participant B', 'participant2@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'PARTICIPANT', '2026-01-07 12:00:00', TRUE),
(8, 'Participant C', 'participant3@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'PARTICIPANT', '2026-01-08 12:30:00', TRUE),
(9, 'Participant D', 'participant4@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'PARTICIPANT', '2026-01-09 13:00:00', TRUE),
(10, 'Participant E', 'participant5@eventapp.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoOHiB5M1s6vTmya4A1NV1McZV8K4D4ewG', 'PARTICIPANT', '2026-01-10 13:30:00', TRUE);

INSERT INTO events (id, title, description, category, location, event_date, total_tickets, available_tickets, price, status, organizer_id, created_at) VALUES
(1, 'Jakarta EE Summit', 'Enterprise Java conference for developers and architects.', 'Technology', 'Casablanca Convention Center', '2026-05-10 10:00:00', 300, 280, 120.00, 'APPROVED', 3, '2026-02-01 09:00:00'),
(2, 'Music Nights Live', 'Live performances from top local artists.', 'Music', 'Rabat Arena', '2026-05-15 20:00:00', 500, 470, 75.00, 'APPROVED', 4, '2026-02-02 10:00:00'),
(3, 'Startup Pitch Day', 'Founders pitch ideas to investors.', 'Business', 'Tech Hub Casablanca', '2026-06-01 14:00:00', 200, 185, 50.00, 'APPROVED', 5, '2026-02-03 11:00:00'),
(4, 'AI Workshop', 'Hands-on artificial intelligence bootcamp.', 'Technology', 'Marrakech Innovation Lab', '2026-06-08 09:00:00', 150, 120, 90.00, 'APPROVED', 3, '2026-02-04 12:00:00'),
(5, 'Food Festival', 'Street food and culinary showcases.', 'Lifestyle', 'Agadir Corniche', '2026-06-20 12:00:00', 400, 400, 30.00, 'PENDING', 4, '2026-02-05 13:00:00'),
(6, 'Marathon 10K', 'City marathon challenge for all levels.', 'Sports', 'Tangier Marina', '2026-07-03 07:00:00', 600, 560, 25.00, 'APPROVED', 5, '2026-02-06 14:00:00'),
(7, 'Photography Expo', 'Exhibition of contemporary photographers.', 'Art', 'Rabat Art Gallery', '2026-07-18 16:00:00', 250, 250, 40.00, 'PENDING', 3, '2026-02-07 15:00:00'),
(8, 'Gaming Championship', 'Regional esports tournament finals.', 'Gaming', 'Casablanca E-Sports Hall', '2026-08-05 11:00:00', 350, 320, 65.00, 'APPROVED', 4, '2026-02-08 16:00:00'),
(9, 'Health & Wellness Fair', 'Sessions on fitness, nutrition, and wellness.', 'Health', 'Fes Expo Center', '2026-08-22 09:00:00', 220, 210, 20.00, 'APPROVED', 5, '2026-02-09 17:00:00'),
(10, 'Charity Gala', 'Fundraising evening for local charities.', 'Community', 'Meknes Grand Hotel', '2026-09-12 19:00:00', 180, 180, 150.00, 'PENDING', 3, '2026-02-10 18:00:00');

INSERT INTO tickets (id, participant_id, event_id, purchase_date, status, qr_code, payment_id) VALUES
(1, 6, 1, '2026-03-01 10:15:00', 'ACTIVE', 'SAMPLE_QR_1', 'TXN-0000000000000001'),
(2, 7, 1, '2026-03-01 11:20:00', 'ACTIVE', 'SAMPLE_QR_2', 'TXN-0000000000000002'),
(3, 8, 2, '2026-03-02 09:10:00', 'ACTIVE', 'SAMPLE_QR_3', 'TXN-0000000000000003'),
(4, 9, 2, '2026-03-02 12:45:00', 'ACTIVE', 'SAMPLE_QR_4', 'TXN-0000000000000004'),
(5, 10, 3, '2026-03-03 13:00:00', 'ACTIVE', 'SAMPLE_QR_5', 'TXN-0000000000000005'),
(6, 6, 3, '2026-03-03 15:30:00', 'TRANSFERRED', 'SAMPLE_QR_6', 'TXN-0000000000000006'),
(7, 7, 4, '2026-03-04 10:00:00', 'ACTIVE', 'SAMPLE_QR_7', 'TXN-0000000000000007'),
(8, 8, 4, '2026-03-04 10:40:00', 'ACTIVE', 'SAMPLE_QR_8', 'TXN-0000000000000008'),
(9, 9, 6, '2026-03-05 08:10:00', 'ACTIVE', 'SAMPLE_QR_9', 'TXN-0000000000000009'),
(10, 10, 6, '2026-03-05 09:30:00', 'CANCELLED', 'SAMPLE_QR_10', 'TXN-0000000000000010'),
(11, 6, 8, '2026-03-06 14:20:00', 'ACTIVE', 'SAMPLE_QR_11', 'TXN-0000000000000011'),
(12, 7, 8, '2026-03-06 15:00:00', 'ACTIVE', 'SAMPLE_QR_12', 'TXN-0000000000000012'),
(13, 8, 9, '2026-03-07 10:50:00', 'ACTIVE', 'SAMPLE_QR_13', 'TXN-0000000000000013'),
(14, 9, 9, '2026-03-07 11:35:00', 'ACTIVE', 'SAMPLE_QR_14', 'TXN-0000000000000014'),
(15, 10, 1, '2026-03-08 16:10:00', 'ACTIVE', 'SAMPLE_QR_15', 'TXN-0000000000000015');

INSERT INTO payments (id, ticket_id, amount, payment_date, method, status, transaction_ref) VALUES
(1, 1, 120.00, '2026-03-01 10:16:00', 'CARD', 'COMPLETED', 'TXN-0000000000000001'),
(2, 2, 120.00, '2026-03-01 11:21:00', 'CARD', 'COMPLETED', 'TXN-0000000000000002'),
(3, 3, 75.00, '2026-03-02 09:11:00', 'WALLET', 'COMPLETED', 'TXN-0000000000000003'),
(4, 4, 75.00, '2026-03-02 12:46:00', 'CARD', 'COMPLETED', 'TXN-0000000000000004'),
(5, 5, 50.00, '2026-03-03 13:02:00', 'BANK_TRANSFER', 'COMPLETED', 'TXN-0000000000000005'),
(6, 6, 50.00, '2026-03-03 15:31:00', 'CARD', 'COMPLETED', 'TXN-0000000000000006'),
(7, 7, 90.00, '2026-03-04 10:02:00', 'CARD', 'COMPLETED', 'TXN-0000000000000007'),
(8, 8, 90.00, '2026-03-04 10:42:00', 'WALLET', 'COMPLETED', 'TXN-0000000000000008'),
(9, 9, 25.00, '2026-03-05 08:12:00', 'CARD', 'COMPLETED', 'TXN-0000000000000009'),
(10, 10, 25.00, '2026-03-05 09:31:00', 'CARD', 'REFUNDED', 'TXN-0000000000000010'),
(11, 11, 65.00, '2026-03-06 14:21:00', 'CARD', 'COMPLETED', 'TXN-0000000000000011'),
(12, 12, 65.00, '2026-03-06 15:01:00', 'WALLET', 'COMPLETED', 'TXN-0000000000000012'),
(13, 13, 20.00, '2026-03-07 10:51:00', 'CARD', 'COMPLETED', 'TXN-0000000000000013'),
(14, 14, 20.00, '2026-03-07 11:36:00', 'BANK_TRANSFER', 'PENDING', 'TXN-0000000000000014'),
(15, 15, 120.00, '2026-03-08 16:11:00', 'CARD', 'COMPLETED', 'TXN-0000000000000015');
