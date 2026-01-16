<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// HTTPS Proxy Fix
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

if (getenv('WP_SITE_URL')) {
    define('WP_HOME', getenv('WP_SITE_URL'));
    define('WP_SITEURL', getenv('WP_SITE_URL'));
}

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress');

/** Database username */
define('DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wordpress');

/** Database password */
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'password');

/** Database hostname */
define('DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'db');

/** Database charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The database collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY', getenv('WORDPRESS_AUTH_KEY'));
define('SECURE_AUTH_KEY', getenv('WORDPRESS_SECURE_AUTH_KEY'));
define('LOGGED_IN_KEY', getenv('WORDPRESS_LOGGED_IN_KEY'));
define('NONCE_KEY', getenv('WORDPRESS_NONCE_KEY'));
define('AUTH_SALT', getenv('WORDPRESS_AUTH_SALT'));
define('SECURE_AUTH_SALT', getenv('WORDPRESS_SECURE_AUTH_SALT'));
define('LOGGED_IN_SALT', getenv('WORDPRESS_LOGGED_IN_SALT'));
define('NONCE_SALT', getenv('WORDPRESS_NONCE_SALT'));

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define('WP_DEBUG', filter_var(getenv('WORDPRESS_DEBUG'), FILTER_VALIDATE_BOOLEAN));

// S3 Offload Media Settings
// S3 Offload Media Settings
$as3cf_settings = array(
    'provider' => 'aws',
    'use-server-roles' => true,
    'bucket' => getenv('S3_BUCKET_NAME'),
    'copy-to-s3' => true,
    'serve-from-s3' => true,
    'remove-local-file' => true,
    'force-https' => true,
    'object-versioning' => true,
    'use-yearmonth-folders' => true,
);

// If CloudFront Domain is provided, configure it as the delivery provider
if (getenv('CLOUDFRONT_DOMAIN')) {
    $as3cf_settings['delivery-provider'] = 'aws'; // Or 'cloudfront' depending on plugin version, 'aws' usually works for CloudFront via S3
    $as3cf_settings['delivery-domain'] = getenv('CLOUDFRONT_DOMAIN');
    $as3cf_settings['enable-delivery-domain'] = true;
}

define('AS3CF_SETTINGS', serialize($as3cf_settings));

// Load extra config from environment if needed
if (getenv('WORDPRESS_CONFIG_EXTRA')) {
    eval (getenv('WORDPRESS_CONFIG_EXTRA'));
}

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
