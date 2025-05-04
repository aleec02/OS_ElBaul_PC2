<?php
include 'db_connection.php';

echo "<h1>Reseñas de Productos</h1>";
echo "<p><a href='index.php'>Volver al inicio</a></p>";
echo "<table border='1'>";
echo "<tr><th>ID Reseña</th><th>Producto</th><th>Cliente</th><th>Puntuación</th><th>Comentario</th><th>Fecha</th><th>Aprobada</th></tr>";

$test_query = "SELECT r.*, p.titulo, u.nombre, u.apellido FROM resena r 
               JOIN producto p ON r.producto_id = p.producto_id
               JOIN usuario u ON r.usuario_id = u.usuario_id";
$result = mysqli_query($link, $test_query);
$resCnt = 0;

while($res = mysqli_fetch_array($result)) {
    $resCnt++;
    echo "<tr>";
    echo "<td>".$res['resena_id']."</td>";
    echo "<td>".$res['titulo']."</td>";
    echo "<td>".$res['nombre']." ".$res['apellido']."</td>";
    echo "<td>".$res['puntuacion']."/5</td>";
    echo "<td>".$res['comentario']."</td>";
    echo "<td>".$res['fecha']."</td>";
    echo "<td>".($res['aprobada'] ? 'Sí' : 'No')."</td>";
    echo "</tr>";
}

echo "</table>";

if (!$resCnt) {
    echo "No hay reseñas registradas<br />\n";
} else {
    echo "Hay $resCnt reseñas registradas<br />\n";
}
mysqli_close($link);
?>
