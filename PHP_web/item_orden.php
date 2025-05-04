<?php
include 'db_connection.php';

echo "<h1>Items en Órdenes</h1>";
echo "<p><a href='index.php'>Volver al inicio</a></p>";
echo "<table border='1'>";
echo "<tr><th>ID Item</th><th>ID Orden</th><th>Producto</th><th>Cantidad</th><th>Precio Unitario</th><th>Subtotal</th></tr>";

$test_query = "SELECT io.*, p.titulo FROM item_orden io 
               JOIN producto p ON io.producto_id = p.producto_id";
$result = mysqli_query($link, $test_query);
$itemCnt = 0;

while($item = mysqli_fetch_array($result)) {
    $itemCnt++;
    echo "<tr>";
    echo "<td>".$item['item_orden_id']."</td>";
    echo "<td>".$item['orden_id']."</td>";
    echo "<td>".$item['titulo']."</td>";
    echo "<td>".$item['cantidad']."</td>";
    echo "<td>S/. ".$item['precio_unitario']."</td>";
    echo "<td>S/. ".$item['subtotal']."</td>";
    echo "</tr>";
}

echo "</table>";

if (!$itemCnt) {
    echo "No hay items en órdenes registrados<br />\n";
} else {
    echo "Hay $itemCnt items en órdenes registrados<br />\n";
}
mysqli_close($link);
?>
