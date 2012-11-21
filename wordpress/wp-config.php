<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'abdoli');

/** MySQL database username */
define('DB_USER', 'abdoli');

/** MySQL database password */
define('DB_PASSWORD', 'kgcH8v7c');

/** MySQL hostname */
define('DB_HOST', 'db.student.chalmers.se');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '16isG$f]$%q}w0QE*.!lC`Y|zn4OAQQ} {Xl@M rcgm>07;QD1zg$/*`<5=-M|-}');
define('SECURE_AUTH_KEY',  'n!=X1oxQ,Z5^0Fg4?/c--azo2gm!@P&Y-<vpp@)j|cE oVc3H-yQm@q*c)@3YSLV');
define('LOGGED_IN_KEY',    'j]tNz@0cOPU9r|=QvG.aD_I}*g|R<qzqNA=v!=?u-cR{RliI=0y$2sM;!yy)Y:>P');
define('NONCE_KEY',        'Hj.+ZSTxi594l^bct32ZjOib<_W P`xtn%9~%gF-wwqq`.{Z[B[=n3-cH ){5crv');
define('AUTH_SALT',        'T1@Wo+j_G:hS^FravcqRMHy)p|ucWhS{k.;(,`g>@c1>x{CeaMc,lpv30|cVKOoM');
define('SECURE_AUTH_SALT', '`_Td6Sd_5R[nXDd*ACLc!7-9%rc-8f8rtiVblcLUNchhF8.lw}}qw-3Eh03i5-Pi');
define('LOGGED_IN_SALT',   '*L=7N!:A)Ka]<yrZnEPiWB-q24FD`|0A$rjB!NB55hOA>!3^cl%I><m.+;2:iFVR');
define('NONCE_SALT',       'q;e5gjaD-rK&;JBY(+y~6=#x9:<}|<r/p5AR+[]GT%OP}sdc!g@b:6.$[Tl8hB:y');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
