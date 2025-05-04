<?php
include 'db_connection.php';

echo "<h1>Listado de Usuarios</h1>";
echo "<p><a href='index.php'>Volver al inicio</a></p>";
echo "<table border='1'>";
echo "<tr><th>ID</th><th>Nombre</th><th>Apellido</th><th>Email</th><th>Teléfono</th><th>Rol</th><th>Estado</th></tr>";

$test_query = "SELECT * FROM usuario";
$result = mysqli_query($link, $test_query);
$userCnt = 0;

while($user = mysqli_fetch_array($result)) {
    $userCnt++;
    echo "<tr>";
    echo "<td>".$user['usuario_id']."</td>";
    echo "<td>".$user['nombre']."</td>";
    echo "<td>".$user['apellido']."</td>";
    echo "<td>".$user['email']."</td>";
    echo "<td>".$user['telefono']."</td>";
    echo "<td>".$user['rol']."</td>";
    echo "<td>".($user['estado'] ? 'Activo' : 'Inactivo')."</td>";
    echo "</tr>";
}

echo "</table>";

if (!$userCnt) {
    echo "No hay usuarios registrados<br />\n";
} else {
    echo "Hay $userCnt usuarios registrados<br />\n";
}
mysqli_close($link);
?>
