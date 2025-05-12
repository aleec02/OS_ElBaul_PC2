<?php
session_start();

define('ROOT_PATH', realpath(dirname(__FILE__) . '/..'));
define('ADMIN_PATH', ROOT_PATH . '/admin');
define('USER_PATH', ROOT_PATH . '/user');

// URLs
$site_url = 'http://' . $_SERVER['HTTP_HOST'];
define('SITE_URL', $site_url);
define('ADMIN_URL', $site_url . '/admin');
define('USER_URL', $site_url . '/user');

// Constantes del sistema
define('SITE_NAME', 'ElBaúl');
define('SITE_DESC', 'Plataforma de e-commerce peruana de segunda mano');

// Roles de usuario
define('ROLE_ADMIN', 'admin');
define('ROLE_USER', 'user');
?>
