<?php
require_once 'db_connection.php';
require_once 'functions.php';

function loginUser($email, $password) {
    global $link;
    
    $email = sanitize($email);
    $password = sanitize($password);
    
    // corregir eventualmente esta parte de la contraseña
    $query = "SELECT * FROM usuario WHERE email = '$email' AND password = '$password' AND estado = 1";
    $result = mysqli_query($link, $query);
    
    if (mysqli_num_rows($result) == 1) {
        $user = mysqli_fetch_assoc($result);
        
        // iniciar sesión
        $_SESSION['user_id'] = $user['usuario_id'];
        $_SESSION['user_name'] = $user['nombre'] . ' ' . $user['apellido'];
        $_SESSION['user_email'] = $user['email'];
        $_SESSION['user_role'] = $user['rol'];
        
        return true;
    }
    
    return false;
}

function registerUser($nombre, $apellido, $email, $password, $telefono) {
    global $link;
    
    $nombre = sanitize($nombre);
    $apellido = sanitize($apellido);
    $email = sanitize($email);
    $password = sanitize($password);
    $telefono = sanitize($telefono);
    
    $check_query = "SELECT * FROM usuario WHERE email = '$email'";
    $check_result = mysqli_query($link, $check_query);
    
    if (mysqli_num_rows($check_result) > 0) {
        return false; // El email ya existe
    }
    
    // corregir eventualmente esta parte de la contraseña
    $query = "INSERT INTO usuario (nombre, apellido, email, password, telefono, rol, estado, fecha_registro) 
              VALUES ('$nombre', '$apellido', '$email', '$password', '$telefono', 'user', 1, NOW())";
    
    if (mysqli_query($link, $query)) {
        return mysqli_insert_id($link);
    }
    
    return false;
}

function logoutUser() {
    session_unset();
    session_destroy();
}
?>
