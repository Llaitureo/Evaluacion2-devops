-- CONFIGURACIÓN PARA MÓDULO VENTAS
CREATE DATABASE IF NOT EXISTS innovatech_ventas_db;
CREATE USER IF NOT EXISTS 'user_ventas'@'%' IDENTIFIED BY 'innov4t3cH009';
GRANT ALL PRIVILEGES ON innovatech_ventas_db.* TO 'user_ventas'@'%';

-- CONFIGURACIÓN PARA MÓDULO DESPACHO
CREATE DATABASE IF NOT EXISTS innovatech_despachos_db;
CREATE USER IF NOT EXISTS 'user_despachos'@'%' IDENTIFIED BY 'innov4t3cH009D';
GRANT ALL PRIVILEGES ON innovatech_despachos_db.* TO 'user_despachos'@'%';

FLUSH PRIVILEGES;