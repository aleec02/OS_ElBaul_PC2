<?php
$page_title = "Mi Cuenta";
require_once '../includes/config.php';
require_once '../includes/db_connection.php';
require_once '../includes/functions.php';

// Verificar que esté logueado
requireLogin();

// Obtener información del usuario
$userId = $_SESSION['user_id'];
$query = "SELECT * FROM usuario WHERE usuario_id = $userId";
$result = mysqli_query($link, $query);
$user = mysqli_fetch_assoc($result);

// Obtener órdenes recientes
$query = "SELECT * FROM orden WHERE usuario_id = $userId ORDER BY fecha_orden DESC LIMIT 5";
$ordenes = mysqli_query($link, $query);

// Obtener favoritos
$query = "SELECT f.*, p.titulo, p.precio FROM favorito f 
          JOIN producto p ON f.producto_id = p.producto_id 
          WHERE f.usuario_id = $userId 
          ORDER BY f.fecha_agregado DESC LIMIT 4";
$favoritos = mysqli_query($link, $query);

include '../includes/header.php';
?>

<h1>Mi Cuenta</h1>

<p>Bienvenido, <?php echo $_SESSION['user_name']; ?>!</p>

<div class="user-dashboard">
    <div class="dashboard-section">
        <h2>Mis Datos</h2>
        <p><strong>Nombre:</strong> <?php echo $user['nombre'] . ' ' . $user['apellido']; ?></p>
        <p><strong>Email:</strong> <?php echo $user['email']; ?></p>
        <p><strong>Teléfono:</strong> <?php echo $user['telefono'] ?: 'No registrado'; ?></p>
        <a href="perfil.php" class="btn">Editar Perfil</a>
    </div>
    
    <div class="dashboard-section">
        <h2>Mis Pedidos Recientes</h2>
        <?php if (mysqli_num_rows($ordenes) > 0): ?>
            <table>
                <tr>
                    <th>Orden #</th>
                    <th>Fecha</th>
                    <th>Total</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                <?php while ($orden = mysqli_fetch_assoc($ordenes)): ?>
                <tr>
                    <td><?php echo $orden['orden_id']; ?></td>
                    <td><?php echo $orden['fecha_orden']; ?></td>
                    <td>S/. <?php echo $orden['total']; ?></td>
                    <td><?php echo $orden['estado']; ?></td>
                    <td>
                        <a href="orden_detalle.php?id=<?php echo $orden['orden_id']; ?>">Ver</a>
                    </td>
                </tr>
                <?php endwhile; ?>
            </table>
        <?php else: ?>
            <p>No tienes pedidos recientes.</p>
        <?php endif; ?>
        <a href="pedidos.php" class="btn">Ver Todos los Pedidos</a>
    </div>
</div>

<h2>Mis Favoritos</h2>
<div class="favorites-grid">
    <?php if (mysqli_num_rows($favoritos) > 0): ?>
        <?php while ($fav = mysqli_fetch_assoc($favoritos)): ?>
            <div class="product-card">
                <h3><?php echo $fav['titulo']; ?></h3>
                <p class="price">S/. <?php echo $fav['precio']; ?></p>
                <a href="../producto_detalle.php?id=<?php echo $fav['producto_id']; ?>" class="btn">Ver Producto</a>
            </div>
        <?php endwhile; ?>
    <?php else: ?>
        <p>No tienes productos favoritos aún.</p>
    <?php endif; ?>
</div>
<a href="favoritos.php" class="btn">Ver Todos los Favoritos</a>

<div class="user-menu">
    <h2>Menú de Usuario</h2>
    <ul>
        <li><a href="pedidos.php">Mis Pedidos</a></li>
        <li><a href="favoritos.php">Mis Favoritos</a></li>
        <li><a href="direcciones.php">Mis Direcciones</a></li>
        <li><a href="perfil.php">Editar Perfil</a></li>
        <li><a href="../logout.php">Cerrar Sesión</a></li>
    </ul>
</div>

<?php include '../includes/footer.php'; ?>
