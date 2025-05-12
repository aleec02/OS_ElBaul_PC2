<?php
$page_title = "Panel de Administración";
require_once '../includes/config.php';
require_once '../includes/db_connection.php';
require_once '../includes/functions.php';

// Verificar que sea administrador
requireAdmin();

// Obtener estadísticas
$stats = [];

// Total de usuarios
$query = "SELECT COUNT(*) as total FROM usuario";
$result = mysqli_query($link, $query);
$stats['usuarios'] = mysqli_fetch_assoc($result)['total'];

// Total de productos
$query = "SELECT COUNT(*) as total FROM producto";
$result = mysqli_query($link, $query);
$stats['productos'] = mysqli_fetch_assoc($result)['total'];

// Total de órdenes
$query = "SELECT COUNT(*) as total FROM orden";
$result = mysqli_query($link, $query);
$stats['ordenes'] = mysqli_fetch_assoc($result)['total'];

// Ventas totales
$query = "SELECT SUM(total) as total FROM orden";
$result = mysqli_query($link, $query);
$stats['ventas'] = mysqli_fetch_assoc($result)['total'] ?? 0;

include '../includes/header.php';
?>

<h1>Panel de Administración</h1>

<p>Bienvenido, <?php echo $_SESSION['user_name']; ?>!</p>

<div class="admin-stats">
    <div class="stat-box">
        <h3>Usuarios</h3>
        <p class="stat-value"><?php echo $stats['usuarios']; ?></p>
        <a href="usuarios.php" class="btn">Gestionar Usuarios</a>
    </div>
    
    <div class="stat-box">
        <h3>Productos</h3>
        <p class="stat-value"><?php echo $stats['productos']; ?></p>
        <a href="productos.php" class="btn">Gestionar Productos</a>
    </div>
    
    <div class="stat-box">
        <h3>Órdenes</h3>
        <p class="stat-value"><?php echo $stats['ordenes']; ?></p>
        <a href="ordenes.php" class="btn">Gestionar Órdenes</a>
    </div>
    
    <div class="stat-box">
        <h3>Ventas Totales</h3>
        <p class="stat-value">S/. <?php echo number_format($stats['ventas'], 2); ?></p>
        <a href="ventas.php" class="btn">Ver Informe</a>
    </div>
</div>

<h2>Gestión del Sistema</h2>

<div class="admin-menu">
    <ul>
        <li><a href="usuarios.php">Usuarios</a></li>
        <li><a href="categorias.php">Categorías</a></li>
        <li><a href="productos.php">Productos</a></li>
        <li><a href="ordenes.php">Órdenes</a></li>
        <li><a href="envios.php">Envíos</a></li>
        <li><a href="pagos.php">Pagos</a></li>
        <li><a href="inventario.php">Inventario</a></li>
        <li><a href="cupones.php">Cupones</a></li>
        <li><a href="devoluciones.php">Devoluciones</a></li>
    </ul>
</div>

<?php include '../includes/footer.php'; ?>
