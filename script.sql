-- Esta sentencia crea la base de datos:
-- CREATE DATABASE alke_wallet;

-- Esta sentencia selecciona la db que queremos usar:
-- USE alke_wallet;

-- Creación de la tabla Currency
CREATE TABLE IF NOT EXISTS currencies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    symbol VARCHAR(10) NOT NULL
);

-- Creación de la tabla User
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    balance DECIMAL(10, 2) DEFAULT 0.00 NOT NULL,
    currency_id INT NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (currency_id) REFERENCES currencies(id)
);

-- Creación de la tabla Roles
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Creación de la tabla User_Roles para asignar roles a los usuarios
CREATE TABLE IF NOT EXISTS user_roles (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Tabla de tipo de transacciones
CREATE TABLE IF NOT EXISTS transaction_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Creación de la tabla Transaction
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    total DECIMAL(10, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    sender_user_id INT NOT NULL,
    receiver_user_id INT,
    transaction_type_id INT NOT NULL,
    FOREIGN KEY (sender_user_id) REFERENCES users(id),
    FOREIGN KEY (receiver_user_id) REFERENCES users(id),
    FOREIGN KEY (transaction_type_id) REFERENCES transaction_types(id)
);

-- INSERT DATA
INSERT INTO
  currencies (name, symbol)
VALUES
  ('Dólar estadounidense', 'US$'),
  ('Euro', '€'),
  ('Pesos Chilenos', '$');

INSERT INTO
    transaction_types (name)
VALUES
    ('Transferencia'), ('Depósito'), ('Retiro');

INSERT INTO
  users (name, email, password, balance, currency_id)
VALUES
  ('Felipe', 'felipe@example.com', '$2a$12$g.Bfz6u2Cg/KPPXP8ZFiLONclnUWmoEuq/ttNzFOBrsw3NdOEYctO', 100.00, 1),
  ('María', 'maria@example.com', '$2a$12$g.Bfz6u2Cg/KPPXP8ZFiLONclnUWmoEuq/ttNzFOBrsw3NdOEYctO', 150.00, 2),
  ('Pedro', 'pedro@example.com', '$2a$12$g.Bfz6u2Cg/KPPXP8ZFiLONclnUWmoEuq/ttNzFOBrsw3NdOEYctO', 200.00, 3),
  ('Ana', 'ana@example.com', '$2a$12$g.Bfz6u2Cg/KPPXP8ZFiLONclnUWmoEuq/ttNzFOBrsw3NdOEYctO', 50.00, 1),
  ('Elena', 'elena@example.com', '$2a$12$g.Bfz6u2Cg/KPPXP8ZFiLONclnUWmoEuq/ttNzFOBrsw3NdOEYctO', 75.00, 2);

INSERT INTO
    roles (name)
VALUES
    ('Admin'), ('User');

INSERT INTO
    user_roles (user_id, role_id)
VALUES
    (1, 1), (2, 2), (3, 2), (4, 2), (5, 2);

INSERT INTO
  transactions (sender_user_id, receiver_user_id, transaction_type_id, total, transaction_date)
VALUES
  (1, 2, 1, 50.00, '2024-03-17 08:30:00'),
  (2, 3, 1, 30.00, '2024-03-16 10:45:00'),
  (3, 1, 1, 20.00, '2024-03-15 14:20:00'),
  (1, 3, 1, 15.00, '2024-03-14 16:55:00'),
  (2, 1, 1, 25.00, '2024-03-13 09:10:00'),
  (3, 2, 1, 40.00, '2024-03-12 11:25:00'),
  (4, 1, 1, 10.00, '2024-03-11 13:30:00'),
  (1, 4, 1, 12.00, '2024-03-10 15:45:00'),
  (4, 2, 1, 18.00, '2024-03-09 17:00:00'),
  (2, 4, 1, 22.00, '2024-03-08 19:15:00');

-- 1. Consulta para obtener el nombre de la moneda elegida por los usuarios en cada transacción:
SELECT
    t.id AS transaction_id,
    t.total,
    c.name AS currency_name,
    sender.name AS sender,
    reciever.name AS reciever,
    t.transaction_date AS date
FROM transactions AS t
JOIN users AS sender ON t.sender_user_id = sender.id
JOIN users AS reciever ON t.receiver_user_id = reciever.id
JOIN currencies AS c ON sender.currency_id = c.id
ORDER BY transaction_id;

-- 2. Consulta para obtener todas las transacciones registradas:
SELECT *
FROM transactions;

-- 3. Consulta para obtener todas las transacciones realizadas por un usuario específico:
SELECT
    t.id AS transaction_id,
    t.total,
    t.transaction_date AS  date,
    tt.name AS transaction_type,
    CONCAT(sender.name, ' (', sender_currency.symbol, ')') AS sender_info,
    CONCAT(receiver.name, ' (', receiver_currency.symbol, ')') AS receiver_info
FROM transactions AS t
JOIN users AS sender ON t.sender_user_id = sender.id
JOIN currencies AS sender_currency ON sender.currency_id = sender_currency.id
LEFT JOIN users AS receiver ON t.receiver_user_id = receiver.id
LEFT JOIN currencies AS receiver_currency ON receiver.currency_id = receiver_currency.id
JOIN transaction_types AS tt ON t.transaction_type_id = tt.id
WHERE sender.id = 1; -- ID del usuario a consultar.

-- 4. Sentencia para modificar el campo correo electrónico de un usuario específico:
UPDATE users
SET email = ''
WHERE id = 1; -- Esta es la ID del usuario que se desea modificar su correo.

-- 5. Sentencia para eliminar los datos de una transacción (eliminado de la fila completa):
DELETE FROM transactions
WHERE id = 1; -- Esta es la ID de la transacción que se desea borrar.

-- 6. Consulta para ver los usuarios y sus roles
SELECT u.name AS user_name, u.email AS user_email, r.name AS role FROM users AS u
JOIN user_roles AS ur ON u.id = ur.user_id
JOIN roles AS r ON ur.role_id = r.id;