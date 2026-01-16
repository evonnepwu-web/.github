<?php
/**
 * Title: Header Default
 * Slug: cosmetics-shop/header-default
 * Categories: header
 */
?>
<!-- wp:group {"className":"main-header-section wow fadeInDown","layout":{"type":"default"}} -->
<div class="wp-block-group main-header-section wow fadeInDown"><!-- wp:group {"className":"topbar","style":{"spacing":{"padding":{"top":"10px","bottom":"10px","left":"0px","right":"0px"}}},"backgroundColor":"secondary","layout":{"type":"constrained","contentSize":"85%"}} -->
<div class="wp-block-group topbar has-secondary-background-color has-background" style="padding-top:10px;padding-right:0px;padding-bottom:10px;padding-left:0px"><!-- wp:paragraph {"align":"center","className":"topbar-text","style":{"elements":{"link":{"color":{"text":"var:preset|color|background"}}},"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"600"}},"textColor":"background"} -->
<p class="has-text-align-center topbar-text has-background-color has-text-color has-link-color" style="font-size:16px;font-style:normal;font-weight:600"><span class="dashicons dashicons-tag"></span><?php echo esc_html__('Limited Time Offer: Free Shipping on Orders Over $50!', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div>
<!-- /wp:group -->

<!-- wp:group {"className":"header-section","style":{"spacing":{"margin":{"top":"0px"},"padding":{"top":"4px","bottom":"0px"}}},"layout":{"type":"constrained","contentSize":"85%"}} -->
<div class="wp-block-group header-section" style="margin-top:0px;padding-top:4px;padding-bottom:0px"><!-- wp:columns {"verticalAlignment":"center","className":"header-inner-section","style":{"border":{"radius":"6px"},"spacing":{"padding":{"top":"0px","bottom":"0px","right":"0px","left":"0px"},"blockGap":{"top":"15px","left":"15px"}}}} -->
<div class="wp-block-columns are-vertically-aligned-center header-inner-section" style="border-radius:6px;padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px"><!-- wp:column {"verticalAlignment":"center","width":"20%","className":"header-logo-box"} -->
<div class="wp-block-column is-vertically-aligned-center header-logo-box" style="flex-basis:20%"><!-- wp:site-title {"textAlign":"left","className":"header-title","style":{"elements":{"link":{"color":{"text":"var:preset|color|primary"}}},"typography":{"textTransform":"capitalize","fontSize":"28px","fontStyle":"normal","fontWeight":"600","lineHeight":"1.2"},"border":{"radius":"100px"}},"textColor":"primary"} /--></div>
<!-- /wp:column -->

<!-- wp:column {"verticalAlignment":"center","width":"60%","className":"header-menu"} -->
<div class="wp-block-column is-vertically-aligned-center header-menu" style="flex-basis:60%"><!-- wp:navigation {"textColor":"secondary","overlayBackgroundColor":"primary","overlayTextColor":"background","metadata":{"ignoredHookedBlocks":["woocommerce/customer-account","woocommerce/mini-cart"]},"className":"top-menus","style":{"typography":{"lineHeight":"1.5","textTransform":"capitalize","fontSize":"15px","fontStyle":"Thin","fontWeight":"500"},"spacing":{"blockGap":"50px"}},"fontFamily":"poppins","layout":{"type":"flex","orientation":"horizontal","justifyContent":"center"}} --><!-- wp:navigation-link {"label":"home","url":"#","kind":"custom","isTopLevelLink":true} /-->

<!-- wp:navigation-link {"label":"shop","url":"#","kind":"custom","isTopLevelLink":true} /-->

<!-- wp:navigation-link {"label":"collection","url":"#","kind":"custom","isTopLevelLink":true} /-->

<!-- wp:navigation-link {"label":"blog","url":"#","kind":"custom","isTopLevelLink":true} /-->

<!-- wp:navigation-link {"label":"Buy Now","opensInNewTab":true,"url":"https://www.vwthemes.com/products/cosmetics-shop-wordpress-theme","kind":"custom","isTopLevelLink":true,"className":"buynow-btn"} /-->
<!-- /wp:navigation --></div>
<!-- /wp:column -->

<!-- wp:column {"verticalAlignment":"center","width":"20%","className":"header-btn-box"} -->
<div class="wp-block-column is-vertically-aligned-center header-btn-box" style="flex-basis:20%"><!-- wp:group {"className":"header-woo-btns","style":{"spacing":{"blockGap":"12px"}},"layout":{"type":"flex","flexWrap":"nowrap","justifyContent":"right"}} -->
<div class="wp-block-group header-woo-btns"><!-- wp:search {"label":"Search","showLabel":false,"placeholder":"Searh here...","buttonText":"Search","buttonPosition":"button-only","buttonUseIcon":true,"className":"header-search","style":{"color":{"background":"#00000000"}}} /-->

<!-- wp:woocommerce/cart-link {"content":"","className":"header-cart"} /-->

<!-- wp:woocommerce/customer-account {"displayStyle":"icon_only","iconClass":"wc-block-customer-account__account-icon","className":"header-account"} /--></div>
<!-- /wp:group --></div>
<!-- /wp:column --></div>
<!-- /wp:columns --></div>
<!-- /wp:group --></div>
<!-- /wp:group -->