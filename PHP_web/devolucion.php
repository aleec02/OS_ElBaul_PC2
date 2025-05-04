<?php
include 'db_connection.php';

echo "<h1>Devoluciones</h1>";
echo "<p><a href='index.php'>Volver al inicio</a></p>";
echo "<table border='1'>";
echo "<tr><th>ID Devolución</th><th>Orden</th><th>Producto</th><th>Cliente</th><th>Motivo</th><th>Estado</th><th>Fecha</th><th>Monto Reembolso</th></tr>";

$test_query = "SELECT d.*, p.titulo, u.nombre, u.apellido FROM devolucion d 
               JOIN producto p ON d.producto_id = p.producto_id
               JOIN usuario u ON d.usuario_id = u.usuario_id";
$result = mysqli_query($link, $test_query);
$devCnt = 0;

while($dev = mysqli_fetch_array($result)) {
    $devCnt++;
    echo "<tr>";
    echo "<td>".$dev['devolucion_id']."</td>";
    echo "<td>".$dev['orden_id']."</td>";
    echo "<td>".$dev['titulo']."</td>";
    echo "<td>".$dev['nombre']." ".$dev['apellido']."</td>";
    echo "<td>".$dev['motivo']."</td>";
    echo "<td>".$dev['estado']."</td>";
    echo "<td>".$dev['fecha_solicitud']."</td>";
    echo "<td>".($dev['monto_reembolso'] ? 'S/. '.$dev['monto_reembolso'] : '-')."</td>";
    echo "</tr>";
}

echo "</table>";

if (!$devCnt) {
    echo "No hay devoluciones registradas<br />\n";
} else {
    echo "Hay $devCnt devoluciones registradas<br />\n";
}
mysqli_close($link);
?>
