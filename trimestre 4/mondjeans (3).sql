-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-10-2025 a las 00:40:36
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `mondjeans`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrito`
--

CREATE TABLE `carrito` (
  `IdCarrito` int(10) UNSIGNED NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `FechaAgregado` timestamp NOT NULL DEFAULT current_timestamp(),
  `NumeroDocumentoUsuario` bigint(20) NOT NULL,
  `IdProducto` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `IdCategoria` int(10) UNSIGNED NOT NULL,
  `NombreCategoria` varchar(50) NOT NULL,
  `Descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`IdCategoria`, `NombreCategoria`, `Descripcion`) VALUES
(1, 'Camisetas', 'Camisetas y playeras'),
(2, 'Pantalones', 'Pantalones y jeans'),
(3, 'Vestidos', 'Vestidos casuales y formales'),
(4, 'Zapatos', 'Calzado en general'),
(5, 'Accesorios', 'Gorras, cinturones y más');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras`
--

CREATE TABLE `compras` (
  `IdCompras` int(10) UNSIGNED NOT NULL,
  `FechaCompra` date NOT NULL,
  `Total` decimal(10,2) NOT NULL,
  `Estado` enum('pendiente','recibida','cancelada') NOT NULL DEFAULT 'pendiente',
  `FechaCreacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `IdProveedor` int(10) UNSIGNED NOT NULL,
  `NumeroDocumentoUsuario` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `compras`
--

INSERT INTO `compras` (`IdCompras`, `FechaCompra`, `Total`, `Estado`, `FechaCreacion`, `IdProveedor`, `NumeroDocumentoUsuario`) VALUES
(1, '2025-09-29', 0.01, 'recibida', '2025-09-29 18:28:34', 4, 12345),
(2, '2025-09-29', 0.01, 'cancelada', '2025-09-29 18:29:24', 4, 12345),
(3, '2025-09-30', 0.05, 'recibida', '2025-09-30 03:23:52', 3, 12345);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallecompra`
--

CREATE TABLE `detallecompra` (
  `IdDetalleCompra` int(10) UNSIGNED NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `PrecioUnitario` decimal(10,2) NOT NULL,
  `Total` decimal(10,2) NOT NULL,
  `IdCompra` int(10) UNSIGNED NOT NULL,
  `IdProducto` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleventa`
--

CREATE TABLE `detalleventa` (
  `IdDetalleVenta` int(10) UNSIGNED NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `PrecioUnitario` decimal(10,2) NOT NULL,
  `Total` decimal(10,2) NOT NULL,
  `IdVenta` int(11) NOT NULL,
  `IdProducto` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(3, '2025_09_27_041525_create_password_reset_tokens_table', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulos`
--

CREATE TABLE `modulos` (
  `IdModulo` int(11) NOT NULL,
  `NombreModulo` varchar(50) NOT NULL,
  `Descripcion` text DEFAULT NULL,
  `Ruta` varchar(100) DEFAULT NULL,
  `Icono` varchar(50) DEFAULT NULL,
  `Orden` int(11) DEFAULT 0,
  `Activo` tinyint(1) DEFAULT 1,
  `FechaCreacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `modulos`
--

INSERT INTO `modulos` (`IdModulo`, `NombreModulo`, `Descripcion`, `Ruta`, `Icono`, `Orden`, `Activo`, `FechaCreacion`) VALUES
(1, 'inventario', 'Gestiona entradas, salidas y el control de stock', '/inventario', 'bi-box', 1, 1, '2025-09-30 05:28:10'),
(2, 'reportes', 'Genera reportes detallados del sistema', '/reportes', 'bi-graph-up', 2, 1, '2025-09-30 05:28:10'),
(3, 'proveedores', 'Administra proveedores y sus compras', '/proveedores', 'bi-truck', 3, 1, '2025-09-30 05:28:10'),
(4, 'compras', 'Registra, consulta y gestiona las compras realizadas', '/compras', 'bi-cart', 4, 1, '2025-09-30 05:28:10'),
(5, 'factura', 'Genera, consulta y administra las facturas del sistema', '/factura', 'bi-receipt', 5, 1, '2025-09-30 05:28:10'),
(6, 'permisos', 'Edita tu información personal y agrega permisos', '/permisos', 'bi-person-gear', 6, 1, '2025-09-30 05:28:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientosinventario`
--

CREATE TABLE `movimientosinventario` (
  `IdMovimientosInventario` int(10) UNSIGNED NOT NULL,
  `TipoMovimiento` enum('entrada','salida','ajuste','devolucion') NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `StockAnterior` int(11) NOT NULL,
  `StockNuevo` int(11) NOT NULL,
  `Motivo` text DEFAULT NULL,
  `FechaMovimiento` timestamp NOT NULL DEFAULT current_timestamp(),
  `IdProducto` int(10) UNSIGNED NOT NULL,
  `NumeroDocumentoUsuario` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `IdNotificacion` int(11) NOT NULL,
  `NumeroDocumento` bigint(20) NOT NULL,
  `Tipo` enum('solicitud_acceso','respuesta_solicitud','permiso_otorgado','permiso_revocado') NOT NULL,
  `Titulo` varchar(200) NOT NULL,
  `Mensaje` text NOT NULL,
  `Leida` tinyint(1) DEFAULT 0,
  `IdReferencia` int(11) DEFAULT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`IdNotificacion`, `NumeroDocumento`, `Tipo`, `Titulo`, `Mensaje`, `Leida`, `IdReferencia`, `FechaCreacion`) VALUES
(1, 12345, 'solicitud_acceso', 'Nueva Solicitud de Acceso', 'El usuario george12@gmail.com ha solicitado acceso a un módulo.', 0, 1, '2025-09-30 12:56:31'),
(2, 23423423, 'solicitud_acceso', 'Nueva Solicitud de Acceso', 'El usuario george12@gmail.com ha solicitado acceso a un módulo.', 0, 1, '2025-09-30 12:56:31'),
(3, 1029220893, 'respuesta_solicitud', '✓ Solicitud Aprobada', 'Tu solicitud de acceso al módulo \'inventario\' ha sido APROBADA ✓. Ya puedes acceder al módulo.\n\nComentario del administrador: ok', 0, 1, '2025-09-30 12:58:20'),
(4, 12345, 'solicitud_acceso', 'Nueva Solicitud de Acceso', 'El usuario george12@gmail.com ha solicitado acceso a un módulo.', 0, 2, '2025-09-30 13:06:01'),
(5, 23423423, 'solicitud_acceso', 'Nueva Solicitud de Acceso', 'El usuario george12@gmail.com ha solicitado acceso a un módulo.', 0, 2, '2025-09-30 13:06:01'),
(6, 1029220893, 'respuesta_solicitud', '✓ Solicitud Aprobada', 'Tu solicitud de acceso al módulo \'reportes\' ha sido APROBADA ✓. Ya puedes acceder al módulo.\n\nComentario del administrador: si bro te amo y', 0, 2, '2025-09-30 13:06:31'),
(7, 1029220893, 'permiso_otorgado', 'Nuevo Permiso Otorgado', 'Se te ha otorgado acceso a un nuevo módulo del sistema.', 0, NULL, '2025-10-01 01:49:06'),
(8, 1029220893, 'permiso_otorgado', 'Nuevo Permiso Otorgado', 'Se te ha otorgado acceso a un nuevo módulo del sistema.', 0, NULL, '2025-10-01 01:49:06'),
(9, 1029220893, 'permiso_otorgado', 'Nuevo Permiso Otorgado', 'Se te ha otorgado acceso a un nuevo módulo del sistema.', 0, NULL, '2025-10-01 01:49:06'),
(10, 12345, 'solicitud_acceso', 'Nueva Solicitud de Acceso', 'El usuario george12@gmail.com ha solicitado acceso a un módulo.', 0, 3, '2025-10-01 01:49:37'),
(11, 23423423, 'solicitud_acceso', 'Nueva Solicitud de Acceso', 'El usuario george12@gmail.com ha solicitado acceso a un módulo.', 0, 3, '2025-10-01 01:49:37'),
(12, 1029220893, 'respuesta_solicitud', '✓ Solicitud Aprobada', 'Tu solicitud de acceso al módulo \'compras\' ha sido APROBADA ✓. Ya puedes acceder al módulo.', 0, 3, '2025-10-01 01:49:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`email`, `token`, `created_at`) VALUES
('george3212378060@gmail.com', '$2y$12$1gsdKpzsGey9WLLGirDXh.ArrAMfqYgPfna1Z8n0Rf0EhsCxTL9Ny', '2025-09-29 08:56:54'),
('justin@gmail.com', '$2y$12$gpIQVCqVWmZePMsMjccwVuS8yZZ/JGanBJpul57SWYlFkt2UFjuBS', '2025-09-30 11:55:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_usuario`
--

CREATE TABLE `permisos_usuario` (
  `IdPermiso` int(11) NOT NULL,
  `NumeroDocumento` bigint(20) NOT NULL,
  `IdModulo` int(11) NOT NULL,
  `TieneAcceso` tinyint(1) DEFAULT 0,
  `FechaAsignacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `AsignadoPor` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos_usuario`
--

INSERT INTO `permisos_usuario` (`IdPermiso`, `NumeroDocumento`, `IdModulo`, `TieneAcceso`, `FechaAsignacion`, `AsignadoPor`) VALUES
(1, 1029220893, 1, 1, '2025-09-30 07:58:20', 12345),
(2, 1029220893, 2, 1, '2025-09-30 08:06:31', 12345),
(3, 1029220893, 3, 1, '2025-09-30 20:49:06', 12345),
(4, 1029220893, 4, 1, '2025-09-30 20:49:06', 12345),
(5, 1029220893, 5, 0, '2025-09-30 20:49:06', 12345),
(6, 1029220893, 6, 0, '2025-09-30 20:49:06', 12345);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `IdProducto` int(10) UNSIGNED NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Descripcion` text DEFAULT NULL,
  `Marca` varchar(45) NOT NULL,
  `Color` varchar(45) NOT NULL,
  `Talla` varchar(45) NOT NULL,
  `PrecioBase` decimal(10,2) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `IdCategoria` int(10) UNSIGNED NOT NULL,
  `Stock` int(11) DEFAULT 0,
  `Activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`IdProducto`, `Nombre`, `Descripcion`, `Marca`, `Color`, `Talla`, `PrecioBase`, `FechaCreacion`, `IdCategoria`, `Stock`, `Activo`) VALUES
(2, 'jenas', 'hoila', 'sdfsd', 'asdasd', 'm', 0.39, '2025-09-27 13:07:30', 1, 3, 1),
(3, 'gsdfdf', 'asdasd', 'asdas', 'asd', 'm', 0.01, '2025-09-27 13:16:03', 2, 1, 1),
(4, 'asdasd', 'asdasd', 'sdfsd', 'sdfsd', 'm', 0.02, '2025-09-27 13:18:10', 3, 3, 1),
(7, 'Pantalon de mezclilla', 'Color azul rasgado', 'Polo', 'Azul cielo', '32', 20000.00, '2025-10-01 01:26:02', 1, 11, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `IdProveedor` int(10) UNSIGNED NOT NULL,
  `NombreProveedor` varchar(100) NOT NULL,
  `Contacto` varchar(100) DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Direccion` text DEFAULT NULL,
  `Activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`IdProveedor`, `NombreProveedor`, `Contacto`, `Telefono`, `Email`, `Direccion`, `Activo`) VALUES
(2, 'Moda Express Ltda.', NULL, '3102222222', 'ventas@modaexpress.com', 'Cl 80 #50-20', 1),
(3, 'Global Shoes SAS', NULL, '3103333333', 'info@globalshoes.com', 'Av 30 #10-25', 1),
(4, 'adsasd', 'dsasd', '234234', 'asdas@gmail.com', 'aszdc', 1),
(5, 'jh777000', 'luis', '2431243', 'justin@gmail.com', '', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes_acceso`
--

CREATE TABLE `solicitudes_acceso` (
  `IdSolicitud` int(11) NOT NULL,
  `NumeroDocumento` bigint(20) NOT NULL,
  `IdModulo` int(11) NOT NULL,
  `Justificacion` text DEFAULT NULL,
  `Estado` enum('pendiente','aprobada','rechazada') DEFAULT 'pendiente',
  `FechaSolicitud` timestamp NOT NULL DEFAULT current_timestamp(),
  `FechaRespuesta` timestamp NULL DEFAULT NULL,
  `RespondidoPor` bigint(20) DEFAULT NULL,
  `ComentarioAdmin` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solicitudes_acceso`
--

INSERT INTO `solicitudes_acceso` (`IdSolicitud`, `NumeroDocumento`, `IdModulo`, `Justificacion`, `Estado`, `FechaSolicitud`, `FechaRespuesta`, `RespondidoPor`, `ComentarioAdmin`) VALUES
(1, 1029220893, 1, 'hola soy gay y necesito el modulo', 'aprobada', '2025-09-30 12:56:31', '2025-09-30 12:58:20', 12345, 'ok'),
(2, 1029220893, 2, 'yuigyuioiuyfg', 'aprobada', '2025-09-30 13:06:01', '2025-09-30 13:06:31', 12345, 'si bro te amo y'),
(3, 1029220893, 4, 'efergt3rhhyth', 'aprobada', '2025-10-01 01:49:37', '2025-10-01 01:49:52', 12345, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipodocumento`
--

CREATE TABLE `tipodocumento` (
  `IdTipoDocumento` int(10) UNSIGNED NOT NULL,
  `Nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipodocumento`
--

INSERT INTO `tipodocumento` (`IdTipoDocumento`, `Nombre`) VALUES
(1, 'Cédula de Ciudadanía'),
(3, 'Cédula de Extranjería'),
(5, 'NIT'),
(4, 'Pasaporte'),
(2, 'Tarjeta de Identidad');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `NumeroDocumento` bigint(20) NOT NULL,
  `Nombre1` varchar(45) NOT NULL,
  `Nombre2` varchar(45) DEFAULT NULL,
  `Apellido1` varchar(100) NOT NULL,
  `Apellido2` varchar(45) DEFAULT NULL,
  `Telefono` varchar(15) NOT NULL,
  `Direccion` varchar(255) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Contrasena` varchar(255) NOT NULL,
  `Edad` int(11) NOT NULL,
  `FechaNacimiento` date NOT NULL,
  `Role` enum('user','admin') NOT NULL DEFAULT 'user',
  `IdTipoDocumento` int(10) UNSIGNED NOT NULL,
  `FechaRegistro` timestamp NOT NULL DEFAULT current_timestamp(),
  `Activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`NumeroDocumento`, `Nombre1`, `Nombre2`, `Apellido1`, `Apellido2`, `Telefono`, `Direccion`, `Email`, `Contrasena`, `Edad`, `FechaNacimiento`, `Role`, `IdTipoDocumento`, `FechaRegistro`, `Activo`) VALUES
(12345, 'justin', 'justinnn', 'elrmeyer', 'chanzi', '23234234', 'varrea343', 'justin@gmail.com', '$2y$12$.p2KXNbR9zCPOyzTVdYJa.2OPiWmqB0MeP4UYqEaRMpZrYbG7LXy2', 4, '2025-09-25', 'admin', 1, '2025-09-29 12:57:23', 1),
(23423423, 'george', 'george', 'george', 'george', '465345634', 'carrea 38B bis #2c-27d', 'george3212378060@gmail.com', '$2y$12$Y3QOJc7DsLUO9BIsRWtoPeAdDwDL.6FGOsDxh2Qd9UFFsgm50maJ2', 23, '2025-09-17', 'admin', 1, '2025-09-27 13:03:43', 1),
(1029220893, 'george', 'sebastian', 'sanchez', 'ibarra', '423423', 'carrea 38B bis #2c-27', 'george12@gmail.com', '$2y$12$xL5xGM3dxf/wAe9OBsumwuCo0mX.s6vsPIXm2WzrS2kX2yn1pedVi', 19, '2025-09-09', 'user', 1, '2025-09-30 11:59:59', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `IdVenta` int(10) NOT NULL,
  `NumeroDocumentoCliente` bigint(20) DEFAULT NULL,
  `DocumentoUsuario` bigint(20) NOT NULL,
  `FechaVenta` timestamp NOT NULL DEFAULT current_timestamp(),
  `Total` decimal(10,2) NOT NULL,
  `MetodoPago` enum('efectivo','tarjeta','transferencia','cheque','otro') NOT NULL DEFAULT 'efectivo',
  `Estado` enum('pendiente','completada','cancelada','devuelta') NOT NULL DEFAULT 'completada',
  `Notas` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`IdVenta`, `NumeroDocumentoCliente`, `DocumentoUsuario`, `FechaVenta`, `Total`, `MetodoPago`, `Estado`, `Notas`) VALUES
(49, 102334556, 12345, '2025-09-30 05:00:00', 150000.00, 'efectivo', 'completada', ''),
(50, 1023374534, 12345, '2025-09-30 05:00:00', 200000.00, 'efectivo', 'completada', 'aaaa');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `carrito`
--
ALTER TABLE `carrito`
  ADD PRIMARY KEY (`IdCarrito`),
  ADD UNIQUE KEY `unique_cart_item` (`NumeroDocumentoUsuario`,`IdProducto`),
  ADD KEY `fk_carrito_usuario` (`NumeroDocumentoUsuario`),
  ADD KEY `fk_carrito_producto` (`IdProducto`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`IdCategoria`);

--
-- Indices de la tabla `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`IdCompras`),
  ADD KEY `fk_compras_proveedor` (`IdProveedor`),
  ADD KEY `fk_compras_usuario` (`NumeroDocumentoUsuario`);

--
-- Indices de la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  ADD PRIMARY KEY (`IdDetalleCompra`),
  ADD KEY `fk_detalle_compras_compra` (`IdCompra`),
  ADD KEY `fk_detalle_compras_producto` (`IdProducto`);

--
-- Indices de la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  ADD PRIMARY KEY (`IdDetalleVenta`),
  ADD KEY `fk_detalle_ventas_venta` (`IdVenta`),
  ADD KEY `fk_detalle_ventas_producto` (`IdProducto`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `modulos`
--
ALTER TABLE `modulos`
  ADD PRIMARY KEY (`IdModulo`),
  ADD UNIQUE KEY `NombreModulo` (`NombreModulo`);

--
-- Indices de la tabla `movimientosinventario`
--
ALTER TABLE `movimientosinventario`
  ADD PRIMARY KEY (`IdMovimientosInventario`),
  ADD KEY `fk_movimientos_producto` (`IdProducto`),
  ADD KEY `fk_movimientos_usuario` (`NumeroDocumentoUsuario`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`IdNotificacion`),
  ADD KEY `idx_notificaciones_leida` (`NumeroDocumento`,`Leida`),
  ADD KEY `idx_notificaciones_fecha` (`FechaCreacion`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD KEY `password_reset_tokens_email_index` (`email`);

--
-- Indices de la tabla `permisos_usuario`
--
ALTER TABLE `permisos_usuario`
  ADD PRIMARY KEY (`IdPermiso`),
  ADD UNIQUE KEY `unique_user_module` (`NumeroDocumento`,`IdModulo`),
  ADD KEY `IdModulo` (`IdModulo`),
  ADD KEY `idx_permisos_usuario` (`NumeroDocumento`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`IdProducto`),
  ADD KEY `fk_productos_categoria` (`IdCategoria`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`IdProveedor`);

--
-- Indices de la tabla `solicitudes_acceso`
--
ALTER TABLE `solicitudes_acceso`
  ADD PRIMARY KEY (`IdSolicitud`),
  ADD KEY `IdModulo` (`IdModulo`),
  ADD KEY `idx_solicitudes_estado` (`Estado`),
  ADD KEY `idx_solicitudes_usuario` (`NumeroDocumento`);

--
-- Indices de la tabla `tipodocumento`
--
ALTER TABLE `tipodocumento`
  ADD PRIMARY KEY (`IdTipoDocumento`),
  ADD UNIQUE KEY `Nombre` (`Nombre`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`NumeroDocumento`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `fk_usuarios_tipo_doc` (`IdTipoDocumento`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`IdVenta`),
  ADD KEY `DocumentoUsuario` (`DocumentoUsuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `carrito`
--
ALTER TABLE `carrito`
  MODIFY `IdCarrito` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `IdCategoria` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `IdCompras` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  MODIFY `IdDetalleCompra` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  MODIFY `IdDetalleVenta` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `modulos`
--
ALTER TABLE `modulos`
  MODIFY `IdModulo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `movimientosinventario`
--
ALTER TABLE `movimientosinventario`
  MODIFY `IdMovimientosInventario` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `IdNotificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `permisos_usuario`
--
ALTER TABLE `permisos_usuario`
  MODIFY `IdPermiso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `IdProducto` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `IdProveedor` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `solicitudes_acceso`
--
ALTER TABLE `solicitudes_acceso`
  MODIFY `IdSolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipodocumento`
--
ALTER TABLE `tipodocumento`
  MODIFY `IdTipoDocumento` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `IdVenta` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `carrito`
--
ALTER TABLE `carrito`
  ADD CONSTRAINT `fk_carrito_producto` FOREIGN KEY (`IdProducto`) REFERENCES `productos` (`IdProducto`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_carrito_usuario` FOREIGN KEY (`NumeroDocumentoUsuario`) REFERENCES `usuarios` (`NumeroDocumento`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Filtros para la tabla `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `fk_compras_proveedor` FOREIGN KEY (`IdProveedor`) REFERENCES `proveedores` (`IdProveedor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_compras_usuario` FOREIGN KEY (`NumeroDocumentoUsuario`) REFERENCES `usuarios` (`NumeroDocumento`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  ADD CONSTRAINT `fk_detalle_compras_compra` FOREIGN KEY (`IdCompra`) REFERENCES `compras` (`IdCompras`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_compras_producto` FOREIGN KEY (`IdProducto`) REFERENCES `productos` (`IdProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  ADD CONSTRAINT `fk_detalle_ventas_producto` FOREIGN KEY (`IdProducto`) REFERENCES `productos` (`IdProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_ventas_venta` FOREIGN KEY (`IdVenta`) REFERENCES `ventas` (`IdVenta`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Filtros para la tabla `movimientosinventario`
--
ALTER TABLE `movimientosinventario`
  ADD CONSTRAINT `fk_movimientos_producto` FOREIGN KEY (`IdProducto`) REFERENCES `productos` (`IdProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_movimientos_usuario` FOREIGN KEY (`NumeroDocumentoUsuario`) REFERENCES `usuarios` (`NumeroDocumento`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`NumeroDocumento`) REFERENCES `usuarios` (`NumeroDocumento`) ON DELETE CASCADE;

--
-- Filtros para la tabla `permisos_usuario`
--
ALTER TABLE `permisos_usuario`
  ADD CONSTRAINT `permisos_usuario_ibfk_1` FOREIGN KEY (`NumeroDocumento`) REFERENCES `usuarios` (`NumeroDocumento`) ON DELETE CASCADE,
  ADD CONSTRAINT `permisos_usuario_ibfk_2` FOREIGN KEY (`IdModulo`) REFERENCES `modulos` (`IdModulo`) ON DELETE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_productos_categoria` FOREIGN KEY (`IdCategoria`) REFERENCES `categoria` (`IdCategoria`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `solicitudes_acceso`
--
ALTER TABLE `solicitudes_acceso`
  ADD CONSTRAINT `solicitudes_acceso_ibfk_1` FOREIGN KEY (`NumeroDocumento`) REFERENCES `usuarios` (`NumeroDocumento`) ON DELETE CASCADE,
  ADD CONSTRAINT `solicitudes_acceso_ibfk_2` FOREIGN KEY (`IdModulo`) REFERENCES `modulos` (`IdModulo`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_tipo_doc` FOREIGN KEY (`IdTipoDocumento`) REFERENCES `tipodocumento` (`IdTipoDocumento`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `fk_ventas_usuario` FOREIGN KEY (`DocumentoUsuario`) REFERENCES `usuarios` (`NumeroDocumento`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
