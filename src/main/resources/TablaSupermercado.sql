
-- Sección de administración (ejecutar una vez en un entorno de desarrollo)
drop database if exists supermercado;
drop user if exists usuario01;
drop user if exists usuario_reportes;

-- Creación del esquema
CREATE database supermercado
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

-- Creación de usuarios con contraseñas seguras (idealmente asignadas fuera del script)
create user 'usuario01'@'%' identified by 'clave123.';
create user 'usuario_reportes'@'%' identified by 'Usuar1o_Reportes.';

-- Asignación de permisos
-- Se otorgan permisos específicos en lugar de todos los permisos a todas las tablas futuras
grant select, insert, update, delete on supermercado.* to 'usuario01'@'%';
grant select on supermercado.* to 'usuario_reportes'@'%';
flush privileges;

use supermercado;

-- --- Sección de Creación de Tablas ---

-- Tabla de categorías
create table categoria (
  id_categoria INT NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(50) NOT NULL,
  ruta_imagen varchar(1024),
  activo boolean,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_categoria),
  unique (descripcion),
  index ndx_descripcion (descripcion))
  ENGINE = InnoDB;

-- Tabla de productos
create table producto (
  id_producto INT NOT NULL AUTO_INCREMENT,
  id_categoria INT NOT NULL,
  descripcion VARCHAR(50) NOT NULL,  
  detalle text, 
  precio decimal(12,2) CHECK (precio >= 0),
  existencias int unsigned CHECK (existencias >= 0),
  ruta_imagen varchar(1024),
  activo boolean,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_producto),
  unique (descripcion),
  index ndx_descripcion (descripcion),
  foreign key fk_producto_categoria (id_categoria) references categoria(id_categoria))
  ENGINE = InnoDB;

-- Tabla de usuarios
CREATE TABLE usuario (
  id_usuario INT NOT NULL AUTO_INCREMENT,
  username varchar(30) NOT NULL UNIQUE,
  password varchar(512) NOT NULL,
  nombre VARCHAR(20) NOT NULL,
  apellidos VARCHAR(30) NOT NULL,
  correo VARCHAR(75) NULL UNIQUE,
  telefono VARCHAR(25) NULL,
  ruta_imagen varchar(1024),
  activo boolean,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  CHECK (correo REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'),
  index ndx_username (username))
  ENGINE = InnoDB;

-- Tabla de facturas
create table factura (
  id_factura INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
  total decimal(12,2) check (total>0),
  estado ENUM('Activa', 'Pagada', 'Anulada') NOT NULL,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_factura),  
  index ndx_id_usuario (id_usuario),
  foreign key fk_factura_usuario (id_usuario) references usuario(id_usuario))
  ENGINE = InnoDB;

-- Tabla de ventas
create table venta (
  id_venta INT NOT NULL AUTO_INCREMENT,
  id_factura INT NOT NULL,
  id_producto INT NOT NULL,
  precio_historico decimal(12,2) check (precio_historico>= 0), 
  cantidad int unsigned check (cantidad> 0),
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_venta),
  index ndx_factura (id_factura),
  index ndx_producto (id_producto),
  UNIQUE (id_factura, id_producto),
  foreign key fk_venta_factura (id_factura) references factura(id_factura),
  foreign key fk_venta_producto (id_producto) references producto(id_producto))
  ENGINE = InnoDB;

-- Tabla de roles
create table rol (
  id_rol INT NOT NULL AUTO_INCREMENT,
  rol varchar(20) unique,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  primary key (id_rol))
  ENGINE = InnoDB;

-- Tabla de relación entre usuarios y roles
create table usuario_rol (
  id_usuario int not null,
  id_rol INT NOT NULL,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario,id_rol),
  foreign key fk_usuarioRol_usuario (id_usuario) references usuario(id_usuario),
  foreign key fk_usuarioRol_rol (id_rol) references rol(id_rol))
  ENGINE = InnoDB;

-- Tabla de rutas
CREATE TABLE ruta (
    id_ruta INT AUTO_INCREMENT NOT NULL,
    ruta VARCHAR(255) NOT NULL,
    id_rol INT NULL,
    requiere_rol boolean NOT NULL DEFAULT TRUE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    check (id_rol IS NOT NULL OR requiere_rol = FALSE),
    PRIMARY KEY (id_ruta),
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol))
    ENGINE = InnoDB;

-- Tabla de constantes de la aplicación
CREATE TABLE constante (
    id_constante INT AUTO_INCREMENT NOT NULL,
    atributo VARCHAR(25) NOT NULL,
    valor VARCHAR(150) NOT NULL,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_constante),
    UNIQUE (atributo))
    ENGINE = InnoDB;

-- --- Sección de Inserción de Datos ---
-- Inserción de usuarios
INSERT INTO usuario (username,password,nombre, apellidos, correo, telefono,ruta_imagen,activo) VALUES 
('juan','$2a$10$P1.w58XvnaYQUQgZUCk4aO/RTRl8EValluCqB3S2VMLTbRt.tlre.','Juan', 'Castro Mora',    'jcastro@gmail.com',    '4556-8978', 'https://img2.rtve.es/i/?w=1600&i=1677587980597.jpg',true),
('rebeca','$2a$10$GkEj.ZzmQa/aEfDmtLIh3udIH5fMphx/35d0EYeqZL5uzgCJ0lQRi','Rebeca',  'Contreras Mora', 'acontreras@gmail.com', '5456-8789','https://media.licdn.com/dms/image/v2/C5603AQGwjJ5ht4bWXQ/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1661476259292?e=2147483647&v=beta&t=9_i5zTdqHRMSXlb9H4TuWkWeRGQXmaZLjxkBlWsg2lg',true),
('pedro','$2a$10$koGR7eS22Pv5KdaVJKDcge04ZB53iMiw76.UjHPY.XyVYlYqXnPbO','Pedro', 'Mena Loria',     'lmena@gmail.com',      '7898-8936','https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Eduardo_de_Pedro_2019.jpg/480px-Eduardo_de_Pedro_2019.jpg?20200109230854',true);

-- Inserción de categorias
INSERT INTO categoria (descripcion,ruta_imagen,activo) VALUES 
('Abarrotes', 'https://comerciante.lacuarta.com/wp-content/uploads/2024/04/abarrotes-scaled.jpg',   true), 
('Frutas y verduras', 'https://i.dietdoctor.com/es/wp-content/uploads/2020/09/Fruits-and-vegetables-guide.jpg?auto=compress%2Cformat&w=1200&h=800&fit=crop',   true),
('Carnes, embutidos y Huevo', 'https://conave.org/wp-content/uploads/2023/09/Huevos-carne-de-Pollo-y-Pavo-Alimentos-presentes-en-cada-etapa-de-la-vida-CONAVE.jpg',true),
('Lácteos', 'https://clubdelicatessen.com/wp-content/uploads/2021/05/productos-lacteos.jpg',    false),
('Panes y Horneados', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOeEemNMPzAZllPUWUNUU4kpuXxrxsWWeetA&s',    true),
('bebidas', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQE9MkIJqxM9D7RwVSewcW0jE0rII5gCTS7iQ&s',    true),
('Snacks y Dulces', 'https://cdn-ljgnh.nitrocdn.com/SLUsymRyhLJChtoRwnFLdERUUQLdAAIh/assets/images/optimized/rev-c9f9e3c/www.innovamarketinsights.com/wp-content/uploads/2023/09/snack-trends-sweet-and-savory-1024x707.png',    true),
('Limpieza', 'https://static.bainet.es/clip/068c1be5-d7fe-46f2-93c9-d6382611e34c_source-aspect-ratio_1600w_0.jpg',    true),
('Higiene personal', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVRgUbjZDm7Hcg-OnAUEwmiEJFTHvehfMQ4A&s',    true);

-- Inserción de productos
INSERT INTO producto (id_categoria,descripcion,detalle,precio,existencias,ruta_imagen,activo) VALUES
(1,'Frijoles Tio Pelon','frijoles rojos. 800g.',1800,5,'https://tiopelon.cr/wp-content/uploads/2025/04/Detalle-Frijoles-Rojos-Almohada.webp',true),
(2,'Brocoli','Brocoli nacional. 1kg.',700,21,'https://veggipedia-cms.production.taks.zooma.cloud/assets/Uploads/Products/Broccoli-groenten-veggipedia.png',true),
(3,'Huevos Pipasa','huevos marrón . 30 unidades.',4100,10,'https://info.megasuper.com/ecommerce/00219_1.jpeg',true),
(3,'Jamón Don Cristóbal','Jamón cocido 250g',1120,14,'https://walmartcr.vtexassets.com/arquivos/ids/292908-800-450?v=637823938009100000&width=800&height=450&aspect=true0',true),
(4,'Leche Delactomy','Leche Dos Pinos Delactomy. 946mL.',1180,20,'https://walmartcr.vtexassets.com/arquivos/ids/723541/8970_02.jpg?v=638629895075830000',true),
(4,'Yoplait Griego','Yogurt griego bajo en grasa. 490g.',2150,18,'https://walmartcr.vtexassets.com/arquivos/ids/1049362/yogurt-yoplait-griego-natural-490-g-7441014710975.jpg?v=639041107940200000',true),
(5,'Pan Blanco Bimbo','Pan Blanco mediano. 450g',1240,16,'https://walmartcr.vtexassets.com/arquivos/ids/1007890/pan-blanco-bimbo-mediano-450-g-7441029556759.webp?v=638955879144130000',true),
(5,'Pan Bimbo Artesano','Plan blanco artesamo. 535g.',1584,10,'https://walmarthn.vtexassets.com/arquivos/ids/642896/10486_01.jpg?v=638797869276070000',true),
(6,'Coca Cola Regular','Gaseosa Coca Cola regular. 1.5L',1070,50,'https://walmartcr.vtexassets.com/arquivos/ids/463809/Gaseosa-Coca-Cola-Regular-1-5L-1-26383.jpg?v=638328299968200000',true),
(6,'Bebida de Mango y Fresa del Valle','bebida sabor a mango y fresa del Valle. 375mL',670,15,'https://www.coca-cola.com/content/dam/onexp/cr/es/brands/del-valle/odt-985-kolc-cam-dv-mango-fresa-lata-330ml-sudado-523.png',true),
(7,'Papiolas Queso Deluxe','Chips de papas sabor a queso. 78g.',510,36,'https://bsecommerceprod.blob.core.windows.net/magento/catalog/product/cache/bc9e311e664dbb5929888a78159490c8/7/4/7441000708931-a.jpg',true),
(8,'Lavaplatos Irex Limón','Lavaplatos en crema olor a limón. 1000g',2540,11,'https://media.nidux.net/pull/800/800/13407/26322-product-651af0291bd36-02.jpg',true),
(8,'Limpiador Fabuloso Lavanda','Limpiador multiusos Fabuloso con aroma a lavanda. 900mL.',2870,40,'https://media.nidux.net/pull/800/800/13407/30691-product-65429a04f00fb-1.png',true),
(9,'Shampoo Heand & Shoulders Classic clean','Shampoo 2 en 1. 370mL.',3580,10,'https://images.ctfassets.net/96bre0uq5ome/3gyKOKGyKRl4gR9oZECVr3/bbef2e4744676608c1370165ef55c709/HeadShoulders_2in1_ClassicClean_front.png',true),
(9,'Protex Nutri Protect','Jabón en barra protex con glicerina + vitamina E',780,17,'https://www.protex-soap.com/content/dam/cp-sites-aem/personal-care/protex-relaunch/latam/products/jabon-protex-vitamina-e-latam-desktop.jpg',true);

-- Inserción de facturas
INSERT INTO factura (id_usuario,fecha,total,estado) VALUES
(1,'2025-06-05',211560,'Pagada'),
(2,'2025-06-07',554340,'Pagada'),
(3,'2025-07-07',871000,'Pagada'),
(1,'2025-07-15',244140,'Pagada'),
(2,'2025-07-17',414800,'Pagada'),
(3,'2025-07-21',420000,'Pagada');

-- Inserción de ventas
INSERT INTO venta (id_factura,id_producto,precio_historico,cantidad) values
(1,1,5400,3);

-- Inserción de roles
insert into rol (rol) values ('ADMIN'), ('VENDEDOR'), ('USER');

-- ASignación de roles a usuarios
insert into usuario_rol (id_usuario, id_rol) values
 (1,1), (1,2), (1,3),(2,2),(2,3),(3,3);

-- Inserción de rutas con roles específicos
INSERT INTO ruta (ruta, id_rol) VALUES 
('/producto/nuevo', 1),
('/producto/guardar', 1),
('/producto/modificar/**', 1),
('/producto/eliminar/**', 1),
('/categoria/nuevo', 1),
('/categoria/guardar', 1),
('/categoria/modificar/**', 1),
('/categoria/eliminar/**', 1),
('/usuario/**', 1),
('/constante/**', 1),
('/role/**', 1),
('/usuario_role/**', 1),
('/ruta/**', 1),
('/producto/listado', 2),
('/categoria/listado', 2),
('/pruebas/**', 2),
('/reportes/**', 2),
('/paypal/**', 3),
('/facturar/carrito', 3);

-- Inserción de rutas que no requieren rol
INSERT INTO ruta (ruta,requiere_rol) VALUES 
('/',false),
('/index',false),
('/errores/**',false),
('/carrito/**',false),
('/registro/**',false),
('/403',false),
('/fav/**',false),
('/js/**',false),
('/css/**',false),
('/webjars/**',false);

-- Inserción de constantes de la aplicación
INSERT INTO constante (atributo,valor) VALUES 
('dominio','localhost'),
('dolar','520.75'),
('paypal.client-id','AaDNEUcELb-wQi6_MOboN0a1Ug4BnD4Z2T2-_KIoDjIb8Rif6525nvRhDu-MS-YdKQ8PJqZi7R6T6e_k'),
('paypal.client-secret','EKBpJ1oXlwfcp60KyF9ednFM4i9G_RkzgPCpDXo_NbQbaO_bICxhs_a_mnepi7524BQeK_qdNPRmLt71'),
('paypal.mode','sandbox'),
('url_paypal_cancel','http://localhost/payment/cancel'),
('url_paypal_success','http://localhost/payment/success'),
('servidor.http','http://localhost'),
('app.paypal.return-url','/paypal/order/capture'),
('app.paypal.cancel-url','/paypal/pago_cancel'),
('app.paypal.cancel-error','/paypal/pago_error'),
('app.paypal.cancel-success','/paypal/pago_success');