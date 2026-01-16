<?php
// Add Getstart admin notice
function cosmetics_shop_admin_notice() { 
    global $pagenow;
    $cosmetics_shop_theme_args      = wp_get_theme();
    $cosmetics_shop_meta            = get_option( 'cosmetics_shop_admin_notice' );
    $cosmetics_shop_name            = $cosmetics_shop_theme_args->__get( 'Name' );
    $cosmetics_shop_current_screen  = get_current_screen();

    if( !$cosmetics_shop_meta ){
        if( is_network_admin() ){
            return;
        }

        if( ! current_user_can( 'manage_options' ) ){
            return;
        } if($cosmetics_shop_current_screen->base != 'appearance_page_cosmetics-shop-guide-page' && $cosmetics_shop_current_screen->id != 'appearance_page_cosmetics-shop-info' && $cosmetics_shop_current_screen->base != 'toplevel_page_cretats-theme-showcase' ) { ?>
        <div class="notice notice-success is-dismissible welcome-notice">
            <div class="notice-row">
                <div class="notice-text">
                    <p class="welcome-text1"><?php esc_html_e( '🎉 Welcome to VW Themes,', 'cosmetics-shop' ); ?></p>
                    <p class="welcome-text2"><?php esc_html_e( 'You are now using the Cosmetics Shop, a beautifully designed theme to kickstart your website.', 'cosmetics-shop' ); ?></p>
                    <p class="welcome-text3"><?php esc_html_e( 'To help you get started quickly, use the options below:', 'cosmetics-shop' ); ?></p>

                    <span class="import-btn">
                        <a href="javascript:void(0);" id="install-activate-button" class="button admin-button info-button">
                           <?php echo __('GET STARTED', 'cosmetics-shop'); ?>
                        </a>
                        <script type="text/javascript">
                            document.getElementById('install-activate-button').addEventListener('click', function () {
                                const cosmetics_shop_button = this;
                                const cosmetics_shop_redirectUrl = '<?php echo esc_url(admin_url("themes.php?page=cosmetics-shop-info")); ?>';
                                // First, check if plugin is already active
                                jQuery.post(ajaxurl, { action: 'check_plugin_activation' }, function (response) {
                                    if (response.success && response.data.active) {
                                        // Plugin already active — just redirect
                                        window.location.href = cosmetics_shop_redirectUrl;
                                    } else {
                                        // Show Installing & Activating only if not already active
                                        cosmetics_shop_button.textContent = 'Installing & Activating...';

                                        jQuery.post(ajaxurl, {
                                            action: 'install_and_activate_required_plugin',
                                            nonce: '<?php echo wp_create_nonce("install_activate_nonce"); ?>'
                                        }, function (response) {
                                            if (response.success) {
                                                window.location.href = cosmetics_shop_redirectUrl;
                                            } else {
                                                alert('Failed to activate the plugin.');
                                                cosmetics_shop_button.textContent = 'Try Again';
                                            }
                                        });
                                    }
                                });
                            });
                        </script>
                    </span>

                    <span class="demo-btn">
                        <a href="https://www.vwthemes.net/cosmetics-shop-pro/" class="button button-primary" target="_blank">
                            <?php esc_html_e( 'VIEW DEMO', 'cosmetics-shop' ); ?>
                        </a>
                    </span>

                    <span class="upgrade-btn">
                        <a href="https://www.vwthemes.com/products/cosmetics-shop-wordpress-theme" class="button button-primary" target="_blank">
                            <?php esc_html_e( 'UPGRADE TO PRO', 'cosmetics-shop' ); ?>
                        </a>
                    </span>

                    <span class="bundle-btn">
                        <a href="https://www.vwthemes.com/products/wp-theme-bundle" class="button button-primary" target="_blank">
                            <?php esc_html_e( 'BUNDLE OF 400+ THEMES', 'cosmetics-shop' ); ?>
                        </a>
                    </span>
                </div>

                <div class="notice-img1">
                    <img src="<?php echo esc_url( get_template_directory_uri() . '/images/arrow-notice.png' ); ?>" width="180" alt="<?php esc_attr_e( 'Cosmetics Shop', 'cosmetics-shop' ); ?>" />
                </div>

                <div class="notice-img2">
                    <img src="<?php echo esc_url( get_template_directory_uri() . '/images/bundle-notice.png' ); ?>" width="180" alt="<?php esc_attr_e( 'Cosmetics Shop', 'cosmetics-shop' ); ?>" />
                </div>
            </div>
        </div>
        <?php

    }?>
        <?php

    }
}

add_action( 'admin_notices', 'cosmetics_shop_admin_notice' );

if( ! function_exists( 'cosmetics_shop_update_admin_notice' ) ) :
/**
 * Updating admin notice on dismiss
*/
function cosmetics_shop_update_admin_notice(){
    if ( isset( $_GET['cosmetics_shop_admin_notice'] ) && $_GET['cosmetics_shop_admin_notice'] = '1' ) {
        update_option( 'cosmetics_shop_admin_notice', true );
    }
}
endif;
add_action( 'admin_init', 'cosmetics_shop_update_admin_notice' );

//After Switch theme function
add_action('after_switch_theme', 'cosmetics_shop_getstart_setup_options');
function cosmetics_shop_getstart_setup_options () {
    update_option('cosmetics_shop_admin_notice', FALSE );
}