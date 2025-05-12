<?php
require_once 'includes/config.php';
require_once 'includes/auth.php';

logoutUser();
showMessage('Has cerrado sesión correctamente', 'info');
redirect(SITE_URL);
?>
