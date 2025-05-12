<?php

function sanitize($data) {
    global $link;
    return mysqli_real_escape_string($link, trim($data));
}

function redirect($url) {
    header("Location: $url");
    exit();
}

function showMessage($message, $type = 'info') {
    $_SESSION['message'] = $message;
    $_SESSION['message_type'] = $type;
}

function isLoggedIn() {
    return isset($_SESSION['user_id']) && !empty($_SESSION['user_id']);
}

function isAdmin() {
    return isLoggedIn() && $_SESSION['user_role'] == ROLE_ADMIN;
}

function requireLogin() {
    if (!isLoggedIn()) {
        showMessage('Debes iniciar sesión para acceder a esta sección', 'error');
        redirect(SITE_URL . '/login.php');
    }
}

function requireAdmin() {
    requireLogin();
    if (!isAdmin()) {
        showMessage('No tienes permisos para acceder a esta sección', 'error');
        redirect(USER_URL);
    }
}
?>
