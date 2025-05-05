-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS elbaul;
USE elbaul;

-- 1. Tabla USUARIO
CREATE TABLE usuario (
    usuario_id VARCHAR(36) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contrasena_hash VARCHAR(255) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    rol ENUM('cliente', 'admin') DEFAULT 'cliente',
    estado BOOLEAN DEFAULT TRUE
);

-- 2. Tabla CATEGORIA
CREATE TABLE categoria (
    categoria_id VARCHAR(36) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    imagen_url VARCHAR(255)
);

-- 3. Tabla PRODUCTO
CREATE TABLE producto (
    producto_id VARCHAR(36) PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    estado ENUM('excelente', 'bueno', 'regular') NOT NULL,
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    stock INT NOT NULL,
    ubicacion_almacen VARCHAR(100),
    marca VARCHAR(50),
    modelo VARCHAR(50),
    año_fabricacion INT,
    categoria_id VARCHAR(36),
    FOREIGN KEY (categoria_id) REFERENCES categoria(categoria_id)
);

-- 4. Tabla IMAGEN_PRODUCTO
CREATE TABLE imagen_producto (
    imagen_id VARCHAR(36) PRIMARY KEY,
    producto_id VARCHAR(36) NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    orden INT NOT NULL,
    es_principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
);

-- 5. Tabla CARRITO
CREATE TABLE carrito (
    carrito_id VARCHAR(36) PRIMARY KEY,
    usuario_id VARCHAR(36) NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
);

-- 6. Tabla ITEM_CARRITO
CREATE TABLE item_carrito (
    item_carrito_id VARCHAR(36) PRIMARY KEY,
    carrito_id VARCHAR(36) NOT NULL,
    producto_id VARCHAR(36) NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (carrito_id) REFERENCES carrito(carrito_id),
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
);

-- 7. Tabla ORDEN
CREATE TABLE orden (
    orden_id VARCHAR(36) PRIMARY KEY,
    usuario_id VARCHAR(36) NOT NULL,
    fecha_orden DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('pendiente', 'pagada', 'enviada', 'entregada', 'cancelada') DEFAULT 'pendiente',
    metodo_pago VARCHAR(50),
    direccion_envio TEXT,
    comprobante_pago VARCHAR(255),
    FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
);

-- 8. Tabla ITEM_ORDEN
CREATE TABLE item_orden (
    item_orden_id VARCHAR(36) PRIMARY KEY,
    orden_id VARCHAR(36) NOT NULL,
    producto_id VARCHAR(36) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (orden_id) REFERENCES orden(orden_id),
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
);

-- 9. Tabla PAGO
CREATE TABLE pago (
    pago_id VARCHAR(36) PRIMARY KEY,
    orden_id VARCHAR(36) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo VARCHAR(50) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('aprobado', 'pendiente', 'rechazado') DEFAULT 'pendiente',
    codigo_transaccion VARCHAR(100),
    FOREIGN KEY (orden_id) REFERENCES orden(orden_id)
);

-- 10. Tabla ENVIO
CREATE TABLE envio (
    envio_id VARCHAR(36) PRIMARY KEY,
    orden_id VARCHAR(36) NOT NULL,
    transportista VARCHAR(50) NOT NULL,
    numero_seguimiento VARCHAR(100),
    fecha_envio DATETIME,
    fecha_estimada DATETIME,
    estado ENUM('preparando', 'en transito', 'entregado') DEFAULT 'preparando',
    costo_envio DECIMAL(10,2),
    FOREIGN KEY (orden_id) REFERENCES orden(orden_id)
);

-- 11. Tabla INVENTARIO
CREATE TABLE inventario (
    inventario_id VARCHAR(36) PRIMARY KEY,
    producto_id VARCHAR(36) NOT NULL,
    cantidad_disponible INT NOT NULL,
    cantidad_reservada INT DEFAULT 0,
    ubicacion VARCHAR(100) NOT NULL,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
);

-- 12. Tabla RESEÑA
CREATE TABLE resena (
    resena_id VARCHAR(36) PRIMARY KEY,
    producto_id VARCHAR(36) NOT NULL,
    usuario_id VARCHAR(36) NOT NULL,
    puntuacion TINYINT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    aprobada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
);

-- 13. Tabla FAVORITO
CREATE TABLE favorito (
    favorito_id VARCHAR(36) PRIMARY KEY,
    usuario_id VARCHAR(36) NOT NULL,
    producto_id VARCHAR(36) NOT NULL,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id),
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id),
    UNIQUE KEY (usuario_id, producto_id)
);

-- 14. Tabla CUPON_DESCUENTO
CREATE TABLE cupon_descuento (
    cupon_id VARCHAR(36) PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    descuento_porcentaje DECIMAL(5,2),
    descuento_monto_fijo DECIMAL(10,2),
    fecha_inicio DATE NOT NULL,
    fecha_expiracion DATE NOT NULL,
    usos_maximos INT,
    usos_actuales INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE
);

-- 15. Tabla DEVOLUCION
CREATE TABLE devolucion (
    devolucion_id VARCHAR(36) PRIMARY KEY,
    orden_id VARCHAR(36) NOT NULL,
    producto_id VARCHAR(36) NOT NULL,
    usuario_id VARCHAR(36) NOT NULL,
    motivo TEXT NOT NULL,
    estado ENUM('solicitada', 'aprobada', 'rechazada', 'completada') DEFAULT 'solicitada',
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    monto_reembolso DECIMAL(10,2),
    FOREIGN KEY (orden_id) REFERENCES orden(orden_id),
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
);

-- =============================================
-- TABLA USUARIO (17 registros)
-- =============================================
INSERT INTO usuario (usuario_id, nombre, apellido, email, contrasena_hash, direccion, telefono, fecha_registro, rol, estado) VALUES
('US100001', 'Aldo', 'Quispe', 'aldo.quispe@gmail.com', 'aldo1234', 'Av. Arequipa 2345, Lince, Lima', '987654321', '2023-01-15 09:30:00', 'cliente', TRUE),
('US100002', 'Brisa', 'Flores', 'brisa_flores@hotmail.com', 'brisaF2023', 'Jr. Carabaya 456, Cercado de Lima', '976543218', '2023-02-16 10:15:00', 'cliente', TRUE),
('US100003', 'César', 'Mendoza', 'cmendoza@gmail.com', 'CesarM#2023', 'Av. Javier Prado Este 1456, San Isidro, Lima', '965432187', '2023-03-17 11:20:00', 'cliente', TRUE),
('US100004', 'Danna', 'Vásquez', 'danna.vasquez@yahoo.com', 'dannaV789', 'Calle Schell 789, Miraflores, Lima', '954321876', '2023-04-18 14:45:00', 'cliente', TRUE),
('US100005', 'Efraín', 'Zapata', 'efrain.zapata@gmail.com', 'ZapataEf99', 'Av. Brasil 2345, Pueblo Libre, Lima', '943218765', '2023-05-19 16:30:00', 'cliente', TRUE),
('US100006', 'Fiorella', 'Rojas', 'fiorojas@outlook.com', 'RojasFi2023', 'Av. La Marina 3456, San Miguel, Lima', '932187654', '2023-06-20 08:15:00', 'cliente', TRUE),
('US100007', 'Gianmarco', 'Salazar', 'gian.salazar@gmail.com', 'GianS#456', 'Jr. De la Unión 678, Lima Centro', '921876543', '2023-07-21 10:30:00', 'cliente', TRUE),
('US100008', 'Hortensia', 'Tello', 'hortensia.t@hotmail.com', 'Htello789', 'Av. Tacna 1234, Lima Cercado', '918765432', '2023-08-22 12:45:00', 'cliente', TRUE),
('US100009', 'Iván', 'Paredes', 'ivan_paredes@gmail.com', 'IvanP2023!', 'Calle Los Pinos 234, Surco, Lima', '907654321', '2023-09-23 14:00:00', 'cliente', TRUE),
('US100010', 'Julissa', 'Cabrera', 'julicabrera@yahoo.com', 'JuliC789', 'Av. Petit Thouars 4567, Lince, Lima', '996543218', '2023-10-24 16:15:00', 'cliente', TRUE),
('US100011', 'Kevin', 'Ore', 'kevin.ore@gmail.com', 'KevinO123', 'Jr. Washington 789, Lima Cercado', '985432187', '2023-11-25 09:30:00', 'cliente', TRUE),
('US100012', 'Lourdes', 'Navarro', 'lulu_navarro@hotmail.com', 'LourdesN#', 'Av. Benavides 3456, Miraflores, Lima', '974321876', '2023-12-26 11:45:00', 'cliente', TRUE),
('US100013', 'Mateo', 'Guzmán', 'mateo.guzman@gmail.com', 'MateoG789', 'Calle Montevideo 123, La Victoria, Lima', '963218765', '2024-01-27 13:00:00', 'cliente', TRUE),
('US100014', 'Nilda', 'Espinoza', 'nilda.espinoza@yahoo.com', 'NildaE2023', 'Av. Arenales 2345, Lince, Lima', '952187654', '2024-02-28 15:15:00', 'cliente', TRUE),
('US100015', 'Óscar', 'Ruiz', 'oruiz@gmail.com', 'OscarR#456', 'Jr. Ica 456, Lima Cercado', '941876543', '2024-03-29 17:30:00', 'cliente', TRUE),
('US100016', 'Patricia', 'Muñoz', 'patty.munoz@hotmail.com', 'PattyM789', 'Av. Salaverry 3456, Jesús María, Lima', '930765432', '2024-04-30 10:45:00', 'cliente', TRUE),
('US100017', 'Renzo', 'Barrios', 'renzo.barrios@gmail.com', 'RenzoB2023', 'Av. Universitaria 2345, San Miguel, Lima', '919654321', '2024-05-31 12:00:00', 'admin', TRUE);

-- =============================================
-- TABLA CATEGORIA (17 registros)
-- =============================================
INSERT INTO categoria (categoria_id, nombre, descripcion, imagen_url) VALUES
('CA200001', 'Electrodomésticos', 'Electrodomésticos modernos y vintage en buen estado', '/img/categorias/electro.jpg'),
('CA200002', 'Ropa y Accesorios', 'Prendas modernas y vintage de segunda mano', '/img/categorias/ropa.jpg'),
('CA200003', 'Libros y Música', 'Libros actuales y coleccionables, CDs y vinilos', '/img/categorias/libros-musica.jpg'),
('CA200004', 'Muebles y Decoración', 'Muebles modernos y vintage para el hogar', '/img/categorias/muebles.jpg'),
('CA200005', 'Tecnología', 'Dispositivos electrónicos recientes y retro', '/img/categorias/tecnologia.jpg'),
('CA200006', 'Juguetes y Juegos', 'Juguetes actuales y clásicos de colección', '/img/categorias/juguetes.jpg'),
('CA200007', 'Relojes y Joyería', 'Relojes y joyas modernas y vintage', '/img/categorias/relojes-joyeria.jpg'),
('CA200008', 'Fotografía', 'Cámaras modernas y analógicas', '/img/categorias/fotografia.jpg'),
('CA200009', 'Hogar y Cocina', 'Artículos para el hogar y utensilios de cocina', '/img/categorias/hogar.jpg'),
('CA200010', 'Instrumentos Musicales', 'Instrumentos modernos y vintage', '/img/categorias/instrumentos.jpg'),
('CA200011', 'Deportes y Fitness', 'Equipo deportivo y artículos de fitness', '/img/categorias/deportes.jpg'),
('CA200012', 'Coleccionables', 'Objetos de colección y curiosidades', '/img/categorias/coleccionables.jpg'),
('CA200013', 'Consolas y Videojuegos', 'Consolas modernas y retro con juegos', '/img/categorias/videojuegos.jpg'),
('CA200014', 'Arte y Antigüedades', 'Obras de arte y antigüedades certificadas', '/img/categorias/arte.jpg'),
('CA200015', 'Bebés y Niños', 'Artículos infantiles en buen estado', '/img/categorias/bebes.jpg'),
('CA200016', 'Herramientas', 'Herramientas profesionales y para el hogar', '/img/categorias/herramientas.jpg'),
('CA200017', 'Computación', 'Laptops, PCs y accesorios tecnológicos', '/img/categorias/computacion.jpg');

-- =============================================
-- TABLA PRODUCTO (17 registros)
-- =============================================
INSERT INTO producto (producto_id, titulo, descripcion, precio, estado, fecha_publicacion, stock, ubicacion_almacen, marca, modelo, año_fabricacion, categoria_id) VALUES
('PR300001', 'Refrigeradora Samsung 2023', 'Refrigeradora side by side, usada 6 meses, impecable estado', 1500.00, 'excelente', '2024-06-01 10:00:00', 1, 'Almacén A1', 'Samsung', 'RT38K5932S9', 2023, 'CA200001'),
('PR300002', 'Jeans Levi\'s 501 2024', 'Jeans clásicos talla 32, poco uso', 90.00, 'bueno', '2024-06-02 11:15:00', 1, 'Almacén B2', 'Levi\'s', '501', 2024, 'CA200002'),
('PR300003', 'iPhone 14 Pro', 'iPhone 14 Pro 256GB, con caja y accesorios', 850.00, 'excelente', '2024-06-03 09:30:00', 1, 'Almacén C3', 'Apple', 'iPhone 14 Pro', 2022, 'CA200005'),
('PR300004', 'Sofá IKEA Kivik 2023', 'Sofá de 3 plazas color gris, excelente estado', 400.00, 'excelente', '2024-06-04 14:20:00', 1, 'Almacén D4', 'IKEA', 'Kivik', 2023, 'CA200004'),
('PR300005', 'PlayStation 5', 'Consola con 3 juegos incluidos', 380.00, 'bueno', '2024-06-05 16:45:00', 1, 'Almacén E5', 'Sony', 'PS5', 2023, 'CA200013'),
('PR300006', 'Zapatillas Adidas Ultraboost', 'Talla 42, usadas 2 meses', 70.00, 'bueno', '2024-06-06 10:30:00', 1, 'Almacén F6', 'Adidas', 'Ultraboost 22', 2024, 'CA200002'),
('PR300007', 'MacBook Pro M2', '2023, 512GB SSD, 16GB RAM', 1200.00, 'excelente', '2024-06-07 12:00:00', 1, 'Almacén G7', 'Apple', 'MacBook Pro', 2023, 'CA200017'),
('PR300008', 'Cámara Canon EOS R7', 'Con lente 18-150mm, buen estado', 950.00, 'excelente', '2024-06-08 15:30:00', 1, 'Almacén H8', 'Canon', 'EOS R7', 2022, 'CA200008'),
('PR300009', 'Mesa de centro moderna 2024', 'Madera y vidrio, diseño contemporáneo', 150.00, 'bueno', '2024-06-09 11:45:00', 1, 'Almacén I9', 'West Elm', 'Modern', 2024, 'CA200004'),
('PR300010', 'Bicicleta Trek FX3 2024', 'Bicicleta híbrida, poco uso', 500.00, 'excelente', '2024-06-10 13:20:00', 1, 'Almacén J10', 'Trek', 'FX 3', 2024, 'CA200011'),
('PR300011', 'Colección El Señor de los Anillos', 'Trilogía en edición especial', 110.00, 'bueno', '2024-06-11 16:00:00', 1, 'Almacén K11', 'Minotauro', 'Edición Especial', 2023, 'CA200003'),
('PR300012', 'AirPods Max', 'Con estuche, excelente estado', 350.00, 'excelente', '2024-06-12 10:15:00', 1, 'Almacén L12', 'Apple', 'AirPods Max', 2023, 'CA200005'),
('PR300013', 'Máquina de café Breville', 'Modelo Barista Express, incluye accesorios', 280.00, 'bueno', '2024-06-13 14:30:00', 1, 'Almacén M13', 'Breville', 'BES870', 2023, 'CA200001'),
('PR300014', 'Reloj Seiko Presage', 'Reloj automático, como nuevo', 220.00, 'excelente', '2024-06-14 11:20:00', 1, 'Almacén N14', 'Seiko', 'SRPE41J1', 2023, 'CA200007'),
('PR300015', 'Juego de mesa Ticket to Ride', 'Edición 2023, completo', 55.00, 'bueno', '2024-06-15 16:45:00', 1, 'Almacén O15', 'Days of Wonder', 'Ticket to Ride', 2023, 'CA200006'),
('PR300016', 'Cochecito de bebé Uppababy', 'Modelo Vista V2, color negro', 300.00, 'bueno', '2024-06-16 09:30:00', 1, 'Almacén P16', 'Uppababy', 'Vista V2', 2022, 'CA200015'),
('PR300017', 'Taladro inalámbrico Milwaukee', '18V FUEL, poco uso', 150.00, 'excelente', '2024-06-17 13:15:00', 1, 'Almacén Q17', 'Milwaukee', 'M18 FPD', 2023, 'CA200016');

-- =============================================
-- TABLA IMAGEN_PRODUCTO (17 registros)
-- =============================================
INSERT INTO imagen_producto (imagen_id, producto_id, url_imagen, orden, es_principal) VALUES
('IM400001', 'PR300001', '/img/productos/refri-samsung.jpg', 1, TRUE),
('IM400002', 'PR300002', '/img/productos/jeans-levis.jpg', 1, TRUE),
('IM400003', 'PR300003', '/img/productos/iphone14pro.jpg', 1, TRUE),
('IM400004', 'PR300004', '/img/productos/sofa-ikea.jpg', 1, TRUE),
('IM400005', 'PR300005', '/img/productos/ps5.jpg', 1, TRUE),
('IM400006', 'PR300006', '/img/productos/adidas-ultraboost.jpg', 1, TRUE),
('IM400007', 'PR300007', '/img/productos/macbook-pro.jpg', 1, TRUE),
('IM400008', 'PR300008', '/img/productos/canon-eosr7.jpg', 1, TRUE),
('IM400009', 'PR300009', '/img/productos/mesa-centro.jpg', 1, TRUE),
('IM400010', 'PR300010', '/img/productos/bicicleta-trek.jpg', 1, TRUE),
('IM400011', 'PR300011', '/img/productos/senor-anillos.jpg', 1, TRUE),
('IM400012', 'PR300012', '/img/productos/airpods-max.jpg', 1, TRUE),
('IM400013', 'PR300013', '/img/productos/breville.jpg', 1, TRUE),
('IM400014', 'PR300014', '/img/productos/seiko-presage.jpg', 1, TRUE),
('IM400015', 'PR300015', '/img/productos/ticket-to-ride.jpg', 1, TRUE),
('IM400016', 'PR300016', '/img/productos/uppababy.jpg', 1, TRUE),
('IM400017', 'PR300017', '/img/productos/milwaukee.jpg', 1, TRUE);

-- =============================================
-- TABLA CARRITO (17 registros)
-- =============================================
INSERT INTO carrito (carrito_id, usuario_id, fecha_creacion, fecha_actualizacion) VALUES
('CR500001', 'US100001', '2024-06-18 10:15:00', '2024-06-18 10:15:00'),
('CR500002', 'US100002', '2024-06-19 11:30:00', '2024-06-19 11:30:00'),
('CR500003', 'US100003', '2024-06-20 09:45:00', '2024-06-20 14:20:00'),
('CR500004', 'US100004', '2024-06-21 14:00:00', '2024-06-21 14:00:00'),
('CR500005', 'US100005', '2024-06-22 16:30:00', '2024-06-22 16:30:00'),
('CR500006', 'US100006', '2024-06-23 10:00:00', '2024-06-23 12:15:00'),
('CR500007', 'US100007', '2024-06-24 13:45:00', '2024-06-24 13:45:00'),
('CR500008', 'US100008', '2024-06-25 15:20:00', '2024-06-25 15:20:00'),
('CR500009', 'US100009', '2024-06-26 09:10:00', '2024-06-26 11:25:00'),
('CR500010', 'US100010', '2024-06-27 12:50:00', '2024-06-27 12:50:00'),
('CR500011', 'US100011', '2024-06-28 14:35:00', '2024-06-28 16:40:00'),
('CR500012', 'US100012', '2024-06-29 10:05:00', '2024-06-29 10:05:00'),
('CR500013', 'US100013', '2024-06-30 11:20:00', '2024-06-30 13:30:00'),
('CR500014', 'US100014', '2024-07-01 15:45:00', '2024-07-01 15:45:00'),
('CR500015', 'US100015', '2024-07-02 09:30:00', '2024-07-02 09:30:00'),
('CR500016', 'US100016', '2024-07-03 14:15:00', '2024-07-03 14:15:00'),
('CR500017', 'US100017', '2024-07-04 16:50:00', '2024-07-04 16:50:00');

-- =============================================
-- TABLA ITEM_CARRITO (17 registros)
-- =============================================
INSERT INTO item_carrito (item_carrito_id, carrito_id, producto_id, cantidad, fecha_agregado) VALUES
('IC600001', 'CR500001', 'PR300001', 1, '2024-06-18 10:20:00'),
('IC600002', 'CR500002', 'PR300002', 2, '2024-06-19 11:35:00'),
('IC600003', 'CR500003', 'PR300003', 1, '2024-06-20 09:50:00'),
('IC600004', 'CR500004', 'PR300004', 1, '2024-06-21 14:05:00'),
('IC600005', 'CR500005', 'PR300005', 1, '2024-06-22 16:35:00'),
('IC600006', 'CR500006', 'PR300006', 1, '2024-06-23 10:05:00'),
('IC600007', 'CR500007', 'PR300007', 1, '2024-06-24 13:50:00'),
('IC600008', 'CR500008', 'PR300008', 1, '2024-06-25 15:25:00'),
('IC600009', 'CR500009', 'PR300009', 1, '2024-06-26 09:15:00'),
('IC600010', 'CR500010', 'PR300010', 1, '2024-06-27 12:55:00'),
('IC600011', 'CR500011', 'PR300011', 1, '2024-06-28 14:40:00'),
('IC600012', 'CR500012', 'PR300012', 1, '2024-06-29 10:10:00'),
('IC600013', 'CR500013', 'PR300013', 1, '2024-06-30 11:25:00'),
('IC600014', 'CR500014', 'PR300014', 1, '2024-07-01 15:50:00'),
('IC600015', 'CR500015', 'PR300015', 1, '2024-07-02 09:35:00'),
('IC600016', 'CR500016', 'PR300016', 1, '2024-07-03 14:20:00'),
('IC600017', 'CR500017', 'PR300017', 1, '2024-07-04 16:55:00');

-- =============================================
-- TABLA ORDEN (17 registros)
-- =============================================
INSERT INTO orden (orden_id, usuario_id, fecha_orden, total, estado, metodo_pago, direccion_envio, comprobante_pago) VALUES
('OR700001', 'US100001', '2024-07-05 11:00:00', 1500.00, 'entregada', 'tarjeta_credito', 'Av. Arequipa 2345, Lince, Lima', 'COMP-2024-0001'),
('OR700002', 'US100002', '2024-07-06 12:15:00', 180.00, 'enviada', 'transferencia', 'Jr. Carabaya 456, Cercado de Lima', 'COMP-2024-0002'),
('OR700003', 'US100003', '2024-07-07 10:30:00', 850.00, 'pagada', 'tarjeta_debito', 'Av. Javier Prado Este 1456, San Isidro, Lima', 'COMP-2024-0003'),
('OR700004', 'US100004', '2024-07-08 15:00:00', 400.00, 'entregada', 'tarjeta_credito', 'Calle Schell 789, Miraflores, Lima', 'COMP-2024-0004'),
('OR700005', 'US100005', '2024-07-09 17:30:00', 380.00, 'enviada', 'transferencia', 'Av. Brasil 2345, Pueblo Libre, Lima', 'COMP-2024-0005'),
('OR700006', 'US100006', '2024-07-10 11:00:00', 70.00, 'pagada', 'tarjeta_debito', 'Av. La Marina 3456, San Miguel, Lima', 'COMP-2024-0006'),
('OR700007', 'US100007', '2024-07-11 14:30:00', 1200.00, 'entregada', 'tarjeta_credito', 'Jr. De la Unión 678, Lima Centro', 'COMP-2024-0007'),
('OR700008', 'US100008', '2024-07-12 16:00:00', 950.00, 'enviada', 'transferencia', 'Av. Tacna 1234, Lima Cercado', 'COMP-2024-0008'),
('OR700009', 'US100009', '2024-07-13 10:00:00', 150.00, 'pagada', 'tarjeta_debito', 'Calle Los Pinos 234, Surco, Lima', 'COMP-2024-0009'),
('OR700010', 'US100010', '2024-07-14 13:30:00', 500.00, 'entregada', 'tarjeta_credito', 'Av. Petit Thouars 4567, Lince, Lima', 'COMP-2024-0010'),
('OR700011', 'US100011', '2024-07-15 15:15:00', 110.00, 'enviada', 'transferencia', 'Jr. Washington 789, Lima Cercado', 'COMP-2024-0011'),
('OR700012', 'US100012', '2024-07-16 10:30:00', 350.00, 'pagada', 'tarjeta_debito', 'Av. Benavides 3456, Miraflores, Lima', 'COMP-2024-0012'),
('OR700013', 'US100013', '2024-07-17 12:00:00', 280.00, 'entregada', 'tarjeta_credito', 'Calle Montevideo 123, La Victoria, Lima', 'COMP-2024-0013'),
('OR700014', 'US100014', '2024-07-18 16:15:00', 220.00, 'enviada', 'transferencia', 'Av. Arenales 2345, Lince, Lima', 'COMP-2024-0014'),
('OR700015', 'US100015', '2024-07-19 10:00:00', 55.00, 'pagada', 'tarjeta_debito', 'Jr. Ica 456, Lima Cercado', 'COMP-2024-0015'),
('OR700016', 'US100016', '2024-07-20 14:45:00', 300.00, 'entregada', 'tarjeta_credito', 'Av. Salaverry 3456, Jesús María, Lima', 'COMP-2024-0016'),
('OR700017', 'US100017', '2025-04-18 17:15:00', 150.00, 'pendiente', 'tarjeta_credito', 'Av. Universitaria 2345, San Miguel, Lima', 'COMP-2025-0001');

-- =============================================
-- TABLA ITEM_ORDEN (17 registros)
-- =============================================
INSERT INTO item_orden (item_orden_id, orden_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
('IO800001', 'OR700001', 'PR300001', 1, 1500.00, 1500.00),
('IO800002', 'OR700002', 'PR300002', 2, 90.00, 180.00),
('IO800003', 'OR700003', 'PR300003', 1, 850.00, 850.00),
('IO800004', 'OR700004', 'PR300004', 1, 400.00, 400.00),
('IO800005', 'OR700005', 'PR300005', 1, 380.00, 380.00),
('IO800006', 'OR700006', 'PR300006', 1, 70.00, 70.00),
('IO800007', 'OR700007', 'PR300007', 1, 1200.00, 1200.00),
('IO800008', 'OR700008', 'PR300008', 1, 950.00, 950.00),
('IO800009', 'OR700009', 'PR300009', 1, 150.00, 150.00),
('IO800010', 'OR700010', 'PR300010', 1, 500.00, 500.00),
('IO800011', 'OR700011', 'PR300011', 1, 110.00, 110.00),
('IO800012', 'OR700012', 'PR300012', 1, 350.00, 350.00),
('IO800013', 'OR700013', 'PR300013', 1, 280.00, 280.00),
('IO800014', 'OR700014', 'PR300014', 1, 220.00, 220.00),
('IO800015', 'OR700015', 'PR300015', 1, 55.00, 55.00),
('IO800016', 'OR700016', 'PR300016', 1, 300.00, 300.00),
('IO800017', 'OR700017', 'PR300017', 1, 150.00, 150.00);

-- =============================================
-- TABLA PAGO (17 registros)
-- =============================================
INSERT INTO pago (pago_id, orden_id, monto, metodo, fecha, estado, codigo_transaccion) VALUES
('PA900001', 'OR700001', 1500.00, 'tarjeta_credito', '2024-07-05 11:05:00', 'aprobado', 'TRX-2024-0001'),
('PA900002', 'OR700002', 180.00, 'transferencia', '2024-07-06 12:20:00', 'aprobado', 'TRX-2024-0002'),
('PA900003', 'OR700003', 850.00, 'tarjeta_debito', '2024-07-07 10:35:00', 'aprobado', 'TRX-2024-0003'),
('PA900004', 'OR700004', 400.00, 'tarjeta_credito', '2024-07-08 15:05:00', 'aprobado', 'TRX-2024-0004'),
('PA900005', 'OR700005', 380.00, 'transferencia', '2024-07-09 17:35:00', 'aprobado', 'TRX-2024-0005'),
('PA900006', 'OR700006', 70.00, 'tarjeta_debito', '2024-07-10 11:05:00', 'aprobado', 'TRX-2024-0006'),
('PA900007', 'OR700007', 1200.00, 'tarjeta_credito', '2024-07-11 14:35:00', 'aprobado', 'TRX-2024-0007'),
('PA900008', 'OR700008', 950.00, 'transferencia', '2024-07-12 16:05:00', 'aprobado', 'TRX-2024-0008'),
('PA900009', 'OR700009', 150.00, 'tarjeta_debito', '2024-07-13 10:05:00', 'aprobado', 'TRX-2024-0009'),
('PA900010', 'OR700010', 500.00, 'tarjeta_credito', '2024-07-14 13:35:00', 'aprobado', 'TRX-2024-0010'),
('PA900011', 'OR700011', 110.00, 'transferencia', '2024-07-15 15:20:00', 'aprobado', 'TRX-2024-0011'),
('PA900012', 'OR700012', 350.00, 'tarjeta_debito', '2024-07-16 10:35:00', 'aprobado', 'TRX-2024-0012'),
('PA900013', 'OR700013', 280.00, 'tarjeta_credito', '2024-07-17 12:05:00', 'aprobado', 'TRX-2024-0013'),
('PA900014', 'OR700014', 220.00, 'transferencia', '2024-07-18 16:20:00', 'aprobado', 'TRX-2024-0014'),
('PA900015', 'OR700015', 55.00, 'tarjeta_debito', '2024-07-19 10:05:00', 'aprobado', 'TRX-2024-0015'),
('PA900016', 'OR700016', 300.00, 'tarjeta_credito', '2024-07-20 14:50:00', 'aprobado', 'TRX-2024-0016'),
('PA900017', 'OR700017', 150.00, 'tarjeta_credito', '2025-04-18 17:20:00', 'pendiente', 'TRX-2025-0001');

-- =============================================
-- TABLA ENVIO (17 registros)
-- =============================================
INSERT INTO envio (envio_id, orden_id, transportista, numero_seguimiento, fecha_envio, fecha_estimada, estado, costo_envio) VALUES
('EN100001', 'OR700001', 'Olva Courier', 'OLVA202400001', '2024-07-06 09:00:00', '2024-07-09 18:00:00', 'entregado', 20.00),
('EN100002', 'OR700002', 'DHL', 'DHL202400002', '2024-07-07 10:30:00', '2024-07-10 18:00:00', 'en transito', 25.00),
('EN100003', 'OR700003', 'Serpost', 'SER202400003', '2024-07-08 11:00:00', '2024-07-11 18:00:00', 'entregado', 15.00),
('EN100004', 'OR700004', 'Olva Courier', 'OLVA202400004', '2024-07-09 14:00:00', '2024-07-12 18:00:00', 'entregado', 20.00),
('EN100005', 'OR700005', 'DHL', 'DHL202400005', '2024-07-10 15:30:00', '2024-07-13 18:00:00', 'en transito', 25.00),
('EN100006', 'OR700006', 'Serpost', 'SER202400006', '2024-07-11 09:30:00', '2024-07-14 18:00:00', 'preparando', 15.00),
('EN100007', 'OR700007', 'Olva Courier', 'OLVA202400007', '2024-07-12 10:00:00', '2024-07-15 18:00:00', 'entregado', 20.00),
('EN100008', 'OR700008', 'DHL', 'DHL202400008', '2024-07-13 11:30:00', '2024-07-16 18:00:00', 'en transito', 25.00),
('EN100009', 'OR700009', 'Serpost', 'SER202400009', '2024-07-14 13:00:00', '2024-07-17 18:00:00', 'preparando', 15.00),
('EN100010', 'OR700010', 'Olva Courier', 'OLVA202400010', '2024-07-15 14:30:00', '2024-07-18 18:00:00', 'entregado', 20.00),
('EN100011', 'OR700011', 'DHL', 'DHL202400011', '2024-07-16 15:00:00', '2024-07-19 18:00:00', 'en transito', 25.00),
('EN100012', 'OR700012', 'Serpost', 'SER202400012', '2024-07-17 09:00:00', '2024-07-20 18:00:00', 'preparando', 15.00),
('EN100013', 'OR700013', 'Olva Courier', 'OLVA202400013', '2024-07-18 10:30:00', '2024-07-21 18:00:00', 'entregado', 20.00),
('EN100014', 'OR700014', 'DHL', 'DHL202400014', '2024-07-19 11:00:00', '2024-07-22 18:00:00', 'en transito', 25.00),
('EN100015', 'OR700015', 'Serpost', 'SER202400015', '2024-07-20 13:30:00', '2024-07-23 18:00:00', 'preparando', 15.00),
('EN100016', 'OR700016', 'Olva Courier', 'OLVA202400016', '2024-07-21 14:00:00', '2024-07-24 18:00:00', 'entregado', 20.00),
('EN100017', 'OR700017', 'DHL', 'DHL202500001', '2025-04-19 15:30:00', '2025-04-22 18:00:00', 'preparando', 25.00);

-- =============================================
-- TABLA INVENTARIO (17 registros)
-- =============================================
INSERT INTO inventario (inventario_id, producto_id, cantidad_disponible, cantidad_reservada, ubicacion, fecha_actualizacion) VALUES
('IN110001', 'PR300001', 0, 0, 'A1-01', '2024-06-01 10:00:00'),
('IN110002', 'PR300002', 3, 2, 'B2-02', '2024-06-02 11:15:00'),
('IN110003', 'PR300003', 0, 0, 'C3-03', '2024-06-03 09:30:00'),
('IN110004', 'PR300004', 0, 0, 'D4-04', '2024-06-04 14:20:00'),
('IN110005', 'PR300005', 2, 1, 'E5-05', '2024-06-05 16:45:00'),
('IN110006', 'PR300006', 5, 1, 'F6-06', '2024-06-06 10:30:00'),
('IN110007', 'PR300007', 0, 0, 'G7-07', '2024-06-07 12:00:00'),
('IN110008', 'PR300008', 1, 1, 'H8-08', '2024-06-08 15:30:00'),
('IN110009', 'PR300009', 3, 1, 'I9-09', '2024-06-09 11:45:00'),
('IN110010', 'PR300010', 0, 0, 'J10-10', '2024-06-10 13:20:00'),
('IN110011', 'PR300011', 2, 1, 'K11-11', '2024-06-11 16:00:00'),
('IN110012', 'PR300012', 1, 1, 'L12-12', '2024-06-12 10:15:00'),
('IN110013', 'PR300013', 4, 1, 'M13-13', '2024-06-13 14:30:00'),
('IN110014', 'PR300014', 0, 0, 'N14-14', '2024-06-14 11:20:00'),
('IN110015', 'PR300015', 3, 1, 'O15-15', '2024-06-15 16:45:00'),
('IN110016', 'PR300016', 1, 1, 'P16-16', '2024-06-16 09:30:00'),
('IN110017', 'PR300017', 2, 1, 'Q17-17', '2024-06-17 13:15:00');

-- =============================================
-- TABLA RESEÑA (17 registros)
-- =============================================
INSERT INTO resena (resena_id, producto_id, usuario_id, puntuacion, comentario, fecha, aprobada) VALUES
('RE120001', 'PR300001', 'US100001', 5, 'Excelente refrigeradora, igual que nueva', '2024-07-06 18:30:00', TRUE),
('RE120002', 'PR300002', 'US100002', 4, 'Los jeans en buen estado, aunque un poco desgastados en los bolsillos', '2024-07-07 19:45:00', TRUE),
('RE120003', 'PR300003', 'US100003', 5, 'El iPhone funciona perfectamente, muy contento con mi compra', '2024-07-08 20:15:00', TRUE),
('RE120004', 'PR300004', 'US100004', 3, 'El sofá es cómodo pero tiene un pequeño rasgón no mencionado', '2024-07-09 17:30:00', TRUE),
('RE120005', 'PR300005', 'US100005', 5, 'La PlayStation 5 funciona perfectamente, incluye todos los accesorios', '2024-07-10 18:45:00', TRUE),
('RE120006', 'PR300006', 'US100006', 4, 'Zapatillas como nuevas, muy buen precio', '2024-07-11 19:00:00', TRUE),
('RE120007', 'PR300007', 'US100007', 5, 'La MacBook está impecable, mejor de lo esperado', '2024-07-12 20:30:00', TRUE),
('RE120008', 'PR300008', 'US100008', 4, 'Buena cámara, solo le faltaba el manual de instrucciones', '2024-07-13 18:15:00', TRUE),
('RE120009', 'PR300009', 'US100009', 5, 'Mesa exactamente como en la descripción, muy bonita', '2024-07-14 19:30:00', TRUE),
('RE120010', 'PR300010', 'US100010', 3, 'La bicicleta necesita ajustes en los frenos', '2024-07-15 17:45:00', TRUE),
('RE120011', 'PR300011', 'US100011', 5, 'Colección completa y en perfecto estado', '2024-07-16 20:00:00', TRUE),
('RE120012', 'PR300012', 'US100012', 4, 'Los AirPods funcionan bien, la batería dura menos que nuevos', '2024-07-17 18:30:00', TRUE),
('RE120013', 'PR300013', 'US100013', 5, 'Máquina de café funciona perfectamente, excelente compra', '2024-07-18 19:45:00', TRUE),
('RE120014', 'PR300014', 'US100014', 5, 'Reloj en perfecto estado, muy elegante', '2024-07-19 20:15:00', TRUE),
('RE120015', 'PR300015', 'US100015', 4, 'Juego completo, algunas fichas con signos de uso', '2024-07-20 17:30:00', TRUE),
('RE120016', 'PR300016', 'US100016', 3, 'Cochecito en buen estado pero con algunos rayones', '2024-07-21 18:45:00', TRUE),
('RE120017', 'PR300017', 'US100017', 5, 'Taladro funciona perfectamente, como nuevo', '2024-07-22 19:00:00', TRUE);

-- =============================================
-- TABLA FAVORITO (17 registros)
-- =============================================
INSERT INTO favorito (favorito_id, usuario_id, producto_id, fecha_agregado) VALUES
('FA130001', 'US100001', 'PR300001', '2024-05-25 10:00:00'),
('FA130002', 'US100002', 'PR300002', '2024-05-26 11:15:00'),
('FA130003', 'US100003', 'PR300003', '2024-05-27 09:30:00'),
('FA130004', 'US100004', 'PR300004', '2024-05-28 14:20:00'),
('FA130005', 'US100005', 'PR300005', '2024-05-29 16:45:00'),
('FA130006', 'US100006', 'PR300006', '2024-05-30 10:30:00'),
('FA130007', 'US100007', 'PR300007', '2024-05-31 12:00:00'),
('FA130008', 'US100008', 'PR300008', '2024-06-01 15:30:00'),
('FA130009', 'US100009', 'PR300009', '2024-06-02 11:45:00'),
('FA130010', 'US100010', 'PR300010', '2024-06-03 13:20:00'),
('FA130011', 'US100011', 'PR300011', '2024-06-04 16:00:00'),
('FA130012', 'US100012', 'PR300012', '2024-06-05 10:15:00'),
('FA130013', 'US100013', 'PR300013', '2024-06-06 14:30:00'),
('FA130014', 'US100014', 'PR300014', '2024-06-07 11:20:00'),
('FA130015', 'US100015', 'PR300015', '2024-06-08 16:45:00'),
('FA130016', 'US100016', 'PR300016', '2024-06-09 09:30:00'),
('FA130017', 'US100017', 'PR300017', '2024-06-10 13:15:00');

-- =============================================
-- TABLA CUPON_DESCUENTO (17 registros)
-- =============================================
INSERT INTO cupon_descuento (cupon_id, codigo, descuento_porcentaje, descuento_monto_fijo, fecha_inicio, fecha_expiracion, usos_maximos, usos_actuales, activo) VALUES
('CU140001', 'VERANO10', 10.00, NULL, '2024-06-01', '2024-08-31', 100, 15, TRUE),
('CU140002', 'PRIMERACOMPRA', NULL, 50.00, '2024-06-01', '2024-12-31', 200, 42, TRUE),
('CU140003', 'ELECTRO15', 15.00, NULL, '2024-06-01', '2024-07-31', 50, 12, TRUE),
('CU140004', 'ENVIOGRATIS', NULL, NULL, '2024-06-01', '2024-06-30', 150, 89, TRUE),
('CU140005', 'ROPA20', 20.00, NULL, '2024-06-01', '2024-07-15', 75, 31, TRUE),
('CU140006', 'TECNO50', NULL, 50.00, '2024-06-01', '2024-06-30', 30, 8, TRUE),
('CU140007', 'LIBROS30', 30.00, NULL, '2024-06-01', '2024-09-30', 100, 25, TRUE),
('CU140008', 'MUEBLES200', NULL, 200.00, '2024-06-01', '2024-07-31', 40, 5, TRUE),
('CU140009', 'MUSICA15', 15.00, NULL, '2024-06-01', '2024-08-31', 60, 18, TRUE),
('CU140010', 'DEPORTE25', 25.00, NULL, '2024-06-01', '2024-07-15', 45, 12, TRUE),
('CU140011', 'HOGAR10', 10.00, NULL, '2024-06-01', '2024-12-31', 200, 37, TRUE),
('CU140012', 'NAVIDAD20', 20.00, NULL, '2024-12-01', '2024-12-31', 150, 0, TRUE),
('CU140013', 'BLACKFRIDAY', 30.00, NULL, '2024-11-24', '2024-11-27', 200, 0, TRUE),
('CU140014', 'CYBERMONDAY', 25.00, NULL, '2024-11-27', '2024-11-28', 150, 0, TRUE),
('CU140015', 'ANIVERSARIO', 15.00, NULL, '2024-09-15', '2024-09-30', 100, 0, TRUE),
('CU140016', 'CLIENTEFIEL', 10.00, NULL, '2024-06-01', '2024-12-31', NULL, 63, TRUE),
('CU140017', 'FLASH15', 15.00, NULL, '2024-06-15', '2024-06-17', 50, 22, TRUE);

ALTER TABLE devolucion 
MODIFY estado ENUM('solicitada', 'aprobada', 'rechazada', 'completada', 'pendiente') DEFAULT 'solicitada';

-- =============================================
-- TABLA DEVOLUCION (17 registros)
-- =============================================
INSERT INTO devolucion (devolucion_id, orden_id, producto_id, usuario_id, motivo, estado, fecha_solicitud, monto_reembolso) VALUES
('DE150001', 'OR700001', 'PR300001', 'US100001', 'Producto no coincide con la descripción', 'completada', '2024-07-03 15:00:00', 1500.00),
('DE150002', 'OR700002', 'PR300002', 'US100002', 'Talla incorrecta', 'completada', '2024-07-04 16:30:00', 180.00),
('DE150003', 'OR700003', 'PR300003', 'US100003', 'Arrepentimiento de compra', 'aprobada', '2024-07-05 11:45:00', 850.00),
('DE150004', 'OR700004', 'PR300004', 'US100004', 'Producto dañado', 'completada', '2024-07-06 17:15:00', 400.00),
('DE150005', 'OR700005', 'PR300005', 'US100005', 'No era lo que esperaba', 'rechazada', '2024-07-07 10:30:00', NULL),
('DE150006', 'OR700006', 'PR300006', 'US100006', 'Defecto no mencionado', 'completada', '2024-07-08 14:45:00', 70.00),
('DE150007', 'OR700007', 'PR300007', 'US100007', 'Arrepentimiento de compra', 'aprobada', '2024-07-09 16:00:00', 1200.00),
('DE150008', 'OR700008', 'PR300008', 'US100008', 'Producto no funciona', 'completada', '2024-07-10 12:15:00', 950.00),
('DE150009', 'OR700009', 'PR300009', 'US100009', 'No me gustó el color', 'rechazada', '2024-07-11 15:30:00', NULL),
('DE150010', 'OR700010', 'PR300010', 'US100010', 'Tamaño incorrecto', 'completada', '2024-07-12 09:45:00', 500.00),
('DE150011', 'OR700011', 'PR300011', 'US100011', 'Libro con páginas faltantes', 'completada', '2024-07-13 14:00:00', 110.00),
('DE150012', 'OR700012', 'PR300012', 'US100012', 'Batería defectuosa', 'completada', '2024-07-14 17:15:00', 350.00),
('DE150013', 'OR700013', 'PR300013', 'US100013', 'No funciona correctamente', 'aprobada', '2024-07-15 10:30:00', 280.00),
('DE150014', 'OR700014', 'PR300014', 'US100014', 'Reloj no mantiene hora', 'completada', '2024-07-16 13:45:00', 220.00),
('DE150015', 'OR700015', 'PR300015', 'US100015', 'Fichas faltantes', 'completada', '2024-07-17 16:00:00', 55.00),
('DE150016', 'OR700016', 'PR300016', 'US100016', 'Rayones no mencionados', 'completada', '2024-07-18 11:15:00', 300.00),
('DE150017', 'OR700017', 'PR300017', 'US100017', 'Arrepentimiento de compra', 'pendiente', '2025-04-19 14:30:00', NULL);
