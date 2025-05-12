<?php
$page_title = "Inicio";
require_once 'includes/config.php';
require_once 'includes/db_connection.php';
require_once 'includes/functions.php';

// Obtener categorías
$query = "SELECT * FROM categoria ORDER BY nombre";
$categorias = mysqli_query($link, $query);

// Obtener productos destacados
$query = "SELECT p.*, c.nombre as categoria_nombre, 
         (SELECT url_imagen FROM imagen_producto WHERE producto_id = p.producto_id AND es_principal = 1 LIMIT 1) as imagen
         FROM producto p 
         LEFT JOIN categoria c ON p.categoria_id = c.categoria_id
         WHERE p.stock > 0
         ORDER BY p.producto_id DESC LIMIT 8";
$productos = mysqli_query($link, $query);

include 'includes/header.php';
?>

<div class="hero">
    <h1>Bienvenido a <?php echo SITE_NAME; ?></h1>
    <p><?php echo SITE_DESC; ?></p>
    <a href="#productos" class="btn">Ver Productos</a>
</div>

<h2>Categorías</h2>
<div class="categorias-grid">
    <?php while ($cat = mysqli_fetch_assoc($categorias)): ?>
        <div class="categoria-card">
            <a href="categoria.php?id=<?php echo $cat['categoria_id']; ?>">
                <?php if (!empty($cat['imagen_url'])): ?>
                    <img src="<?php echo $cat['imagen_url']; ?>" alt="<?php echo $cat['nombre']; ?>">
                <?php endif; ?>
                <h3><?php echo $cat['nombre']; ?></h3>
            </a>
        </div>
    <?php endwhile; ?>
</div>

<h2 id="productos">Productos Destacados</h2>
<div class="productos-grid">
    <?php while ($prod = mysqli_fetch_assoc($productos)): ?>
        <div class="producto-card">
            <?php if (!empty($prod['imagen'])): ?>
                <img src="<?php echo $prod['imagen']; ?>" alt="<?php echo $prod['titulo']; ?>">
            <?php endif; ?>
            <h3><?php echo $prod['titulo']; ?></h3>
            <p class="categoria"><?php echo $prod['categoria_nombre']; ?></p>
            <p class="precio">S/. <?php echo $prod['precio']; ?></p>
            <div class="producto-actions">
                <a href="producto_detalle.php?id=<?php echo $prod['producto_id']; ?>" class="btn">Ver Detalles</a>
                <a href="carrito_agregar.php?id=<?php echo $prod['producto_id']; ?>" class="btn btn-success">Agregar al Carrito</a>
            </div>
        </div>
    <?php endwhile; ?>
</div>

<div class="cta-section">
    <h2>¿Por qué comprar en ElBaúl?</h2>
    <div class="features">
        <div class="feature">
            <h3>Productos de Calidad</h3>
            <p>Todos nuestros productos de segunda mano pasan por un riguroso control de calidad.</p>
        </div>
        <div class="feature">
            <h3>Envío Rápido</h3>
            <p>Entrega en todo el Perú con seguimiento en tiempo real.</p>
        </div>
        <div class="feature">
            <h3>Pago Seguro</h3>
            <p>Múltiples métodos de pago seguros para tu tranquilidad.</p>
        </div>
    </div>
</div>

<?php include 'includes/footer.php'; ?>