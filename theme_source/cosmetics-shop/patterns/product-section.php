<?php
/**
 * Title: Product Section
 * Slug: cosmetics-shop/product-section
 * Categories: template
 */
$cosmetics_shop_pluginsList = get_option( 'active_plugins' );
$cosmetics_shop_plugin = 'woocommerce/woocommerce.php';
$cosmetics_shop_results = in_array( $cosmetics_shop_plugin , $cosmetics_shop_pluginsList);
if ( $cosmetics_shop_results )  {
?>

<!-- wp:group {"className":"product-section wow zoomIn","layout":{"type":"constrained","contentSize":"85%"}} -->
<div class="wp-block-group product-section wow zoomIn"><!-- wp:group {"className":"product-head-box wow zoomIn","style":{"spacing":{"margin":{"bottom":"40px"},"padding":{"bottom":"10px"}}},"layout":{"type":"default"}} -->
<div class="wp-block-group product-head-box wow zoomIn" style="margin-bottom:40px;padding-bottom:10px"><!-- wp:heading {"textAlign":"center","level":3,"className":"product-section-title","style":{"typography":{"fontSize":"24px","textTransform":"capitalize","fontStyle":"Regular","fontWeight":"400"},"elements":{"link":{"color":{"text":"var:preset|color|primary"}}}},"textColor":"primary","fontFamily":"rum-raisin"} -->
<h3 class="wp-block-heading has-text-align-center product-section-title has-primary-color has-text-color has-link-color has-rum-raisin-font-family" style="font-size:24px;font-style:Regular;font-weight:400;text-transform:capitalize"><?php echo esc_html__('shop', 'cosmetics-shop'); ?></h3>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","className":"product-sec-para","style":{"typography":{"fontSize":"27px","fontStyle":"normal","fontWeight":"700","lineHeight":"1.3","textTransform":"capitalize"},"spacing":{"margin":{"top":"0px","bottom":"0px"},"padding":{"right":"25px","left":"25px"}},"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}}},"textColor":"secondary"} -->
<p class="has-text-align-center product-sec-para has-secondary-color has-text-color has-link-color" style="margin-top:0px;margin-bottom:0px;padding-right:25px;padding-left:25px;font-size:27px;font-style:normal;font-weight:700;line-height:1.3;text-transform:capitalize"><?php echo esc_html__('our best selling product', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div>
<!-- /wp:group -->

<!-- wp:woocommerce/product-collection {"queryId":19,"query":{"perPage":4,"pages":1,"offset":0,"postType":"product","order":"desc","orderBy":"date","search":"","exclude":[],"inherit":false,"taxQuery":{},"isProductCollectionBlock":true,"featured":false,"woocommerceOnSale":false,"woocommerceStockStatus":["instock","outofstock","onbackorder"],"woocommerceAttributes":[],"woocommerceHandPickedProducts":[],"timeFrame":{"operator":"in","value":"-7 days"},"filterable":false,"relatedBy":{"categories":true,"tags":true}},"tagName":"div","displayLayout":{"type":"flex","columns":4,"shrinkColumns":true},"dimensions":{"widthType":"fill"},"collection":"woocommerce/product-collection/new-arrivals","hideControls":["inherit","order","filterable"],"queryContextIncludes":["collection"],"__privatePreviewState":{"isPreview":false,"previewMessage":"Actual products will vary depending on the page being viewed."},"className":"product-main-box"} -->
<div class="wp-block-woocommerce-product-collection product-main-box"><!-- wp:woocommerce/product-template {"className":"products-sec-box"} -->
<!-- wp:woocommerce/product-image {"showSaleBadge":false,"imageSizing":"thumbnail","isDescendentOfQueryLoop":true,"height":"320px","className":"product-img"} /-->

<!-- wp:post-title {"textAlign":"center","level":5,"isLink":true,"className":"product-title","style":{"spacing":{"margin":{"bottom":"5px","top":"0"}},"typography":{"lineHeight":"1.4","fontSize":"23px"}},"__woocommerceNamespace":"woocommerce/product-collection/product-title"} /-->

<!-- wp:woocommerce/product-price {"isDescendentOfQueryLoop":true,"textAlign":"center","className":"product-price","textColor":"primary","fontSize":"small","style":{"elements":{"link":{"color":{"text":"var:preset|color|primary"}}},"spacing":{"margin":{"bottom":"0px"}}}} /-->

<!-- wp:buttons {"className":"product-btn","style":{"border":{"width":"0px","style":"none"}},"layout":{"type":"flex","justifyContent":"center"}} -->
<div class="wp-block-buttons product-btn" style="border-style:none;border-width:0px"><!-- wp:button {"textColor":"secondary","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"17px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"},"border":{"radius":{"topLeft":"0px","topRight":"0px","bottomLeft":"0px","bottomRight":"0px"},"width":"0px","style":"none"},"spacing":{"padding":{"left":"5px","right":"5px","top":"0px","bottom":"0px"}},"color":{"background":"#00000000"}}} -->
<div class="wp-block-button"><a class="wp-block-button__link has-secondary-color has-text-color has-background has-link-color has-custom-font-size wp-element-button" style="border-style:none;border-width:0px;border-top-left-radius:0px;border-top-right-radius:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px;background-color:#00000000;padding-top:0px;padding-right:5px;padding-bottom:0px;padding-left:5px;font-size:17px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('order now', 'cosmetics-shop'); ?></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons -->
<!-- /wp:woocommerce/product-template --></div>
<!-- /wp:woocommerce/product-collection --></div>
<!-- /wp:group -->

<!-- wp:spacer {"height":"50px"} -->
<div style="height:50px" aria-hidden="true" class="wp-block-spacer"></div>
<!-- /wp:spacer -->

<?php } else { ?>

<!-- wp:group {"className":"product-section wow zoomIn","layout":{"type":"constrained","contentSize":"85%"}} -->
<div class="wp-block-group product-section wow zoomIn"><!-- wp:group {"className":"product-head-box wow zoomIn","style":{"spacing":{"margin":{"bottom":"40px"},"padding":{"bottom":"10px"}}},"layout":{"type":"default"}} -->
<div class="wp-block-group product-head-box wow zoomIn" style="margin-bottom:40px;padding-bottom:10px"><!-- wp:heading {"textAlign":"center","level":3,"className":"product-section-title","style":{"typography":{"fontSize":"24px","textTransform":"capitalize","fontStyle":"Regular","fontWeight":"400"},"elements":{"link":{"color":{"text":"var:preset|color|primary"}}}},"textColor":"primary","fontFamily":"rum-raisin"} -->
<h3 class="wp-block-heading has-text-align-center product-section-title has-primary-color has-text-color has-link-color has-rum-raisin-font-family" style="font-size:24px;font-style:Regular;font-weight:400;text-transform:capitalize"><?php echo esc_html__('shop', 'cosmetics-shop'); ?></h3>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","className":"product-sec-para","style":{"typography":{"fontSize":"27px","fontStyle":"normal","fontWeight":"700","lineHeight":"1.3","textTransform":"capitalize"},"spacing":{"margin":{"top":"0px","bottom":"0px"},"padding":{"right":"25px","left":"25px"}},"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}}},"textColor":"secondary"} -->
<p class="has-text-align-center product-sec-para has-secondary-color has-text-color has-link-color" style="margin-top:0px;margin-bottom:0px;padding-right:25px;padding-left:25px;font-size:27px;font-style:normal;font-weight:700;line-height:1.3;text-transform:capitalize"><?php echo esc_html__('our best selling product', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div>
<!-- /wp:group -->

<!-- wp:group {"className":"product-main-box","layout":{"type":"default"}} -->
<div class="wp-block-group product-main-box"><!-- wp:columns {"className":"products-sec-box"} -->
<div class="wp-block-columns products-sec-box"><!-- wp:column {"className":"product-box"} -->
<div class="wp-block-column product-box"><!-- wp:image {"id":32,"width":"auto","height":"320px","sizeSlug":"full","linkDestination":"none","className":"product-img","style":{"spacing":{"margin":{"bottom":"var:preset|spacing|50"}}}} -->
<figure class="wp-block-image size-full is-resized product-img" style="margin-bottom:var(--wp--preset--spacing--50)"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/product1.png" alt="" class="wp-image-32" style="width:auto;height:320px"/></figure>
<!-- /wp:image -->

<!-- wp:heading {"textAlign":"center","level":5,"className":"product-title","style":{"typography":{"fontSize":"23px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"}}} -->
<h5 class="wp-block-heading has-text-align-center product-title" style="font-size:23px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('lumiskin glow serum', 'cosmetics-shop'); ?></h5>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","className":"product-price","style":{"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"700"},"elements":{"link":{"color":{"text":"var:preset|color|primary"}}},"spacing":{"margin":{"top":"0px"}}},"textColor":"primary"} -->
<p class="has-text-align-center product-price has-primary-color has-text-color has-link-color" style="margin-top:0px;font-size:16px;font-style:normal;font-weight:700"><?php echo esc_html__('$31.00', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph -->

<!-- wp:buttons {"className":"product-btn","style":{"border":{"width":"0px","style":"none"},"spacing":{"margin":{"top":"0px"}}},"layout":{"type":"flex","justifyContent":"center"}} -->
<div class="wp-block-buttons product-btn" style="border-style:none;border-width:0px;margin-top:0px"><!-- wp:button {"textColor":"secondary","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"17px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"},"border":{"radius":{"topLeft":"0px","topRight":"0px","bottomLeft":"0px","bottomRight":"0px"},"width":"0px","style":"none"},"spacing":{"padding":{"left":"5px","right":"5px","top":"0px","bottom":"0px"}},"color":{"background":"#00000000"}}} -->
<div class="wp-block-button"><a class="wp-block-button__link has-secondary-color has-text-color has-background has-link-color has-custom-font-size wp-element-button" href="#" style="border-style:none;border-width:0px;border-top-left-radius:0px;border-top-right-radius:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px;background-color:#00000000;padding-top:0px;padding-right:5px;padding-bottom:0px;padding-left:5px;font-size:17px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('order now', 'cosmetics-shop'); ?></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"product-box"} -->
<div class="wp-block-column product-box"><!-- wp:image {"id":46,"width":"auto","height":"320px","sizeSlug":"full","linkDestination":"none","className":"product-img","style":{"spacing":{"margin":{"bottom":"var:preset|spacing|50"}}}} -->
<figure class="wp-block-image size-full is-resized product-img" style="margin-bottom:var(--wp--preset--spacing--50)"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/product2.png" alt="" class="wp-image-46" style="width:auto;height:320px"/></figure>
<!-- /wp:image -->

<!-- wp:heading {"textAlign":"center","level":5,"className":"product-title","style":{"typography":{"fontSize":"23px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"}}} -->
<h5 class="wp-block-heading has-text-align-center product-title" style="font-size:23px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('velvet touch foundation', 'cosmetics-shop'); ?></h5>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","className":"product-price","style":{"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"700"},"elements":{"link":{"color":{"text":"var:preset|color|primary"}}},"spacing":{"margin":{"top":"0px"}}},"textColor":"primary"} -->
<p class="has-text-align-center product-price has-primary-color has-text-color has-link-color" style="margin-top:0px;font-size:16px;font-style:normal;font-weight:700"><?php echo esc_html__('$31.00', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph -->

<!-- wp:buttons {"className":"product-btn","style":{"border":{"width":"0px","style":"none"},"spacing":{"margin":{"top":"0px"}}},"layout":{"type":"flex","justifyContent":"center"}} -->
<div class="wp-block-buttons product-btn" style="border-style:none;border-width:0px;margin-top:0px"><!-- wp:button {"textColor":"secondary","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"17px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"},"border":{"radius":{"topLeft":"0px","topRight":"0px","bottomLeft":"0px","bottomRight":"0px"},"width":"0px","style":"none"},"spacing":{"padding":{"left":"5px","right":"5px","top":"0px","bottom":"0px"}},"color":{"background":"#00000000"}}} -->
<div class="wp-block-button"><a class="wp-block-button__link has-secondary-color has-text-color has-background has-link-color has-custom-font-size wp-element-button" href="#" style="border-style:none;border-width:0px;border-top-left-radius:0px;border-top-right-radius:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px;background-color:#00000000;padding-top:0px;padding-right:5px;padding-bottom:0px;padding-left:5px;font-size:17px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('order now', 'cosmetics-shop'); ?></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"product-box"} -->
<div class="wp-block-column product-box"><!-- wp:image {"id":47,"width":"auto","height":"320px","sizeSlug":"full","linkDestination":"none","className":"product-img","style":{"spacing":{"margin":{"bottom":"var:preset|spacing|50"}}}} -->
<figure class="wp-block-image size-full is-resized product-img" style="margin-bottom:var(--wp--preset--spacing--50)"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/product3.png" alt="" class="wp-image-47" style="width:auto;height:320px"/></figure>
<!-- /wp:image -->

<!-- wp:heading {"textAlign":"center","level":5,"className":"product-title","style":{"typography":{"fontSize":"23px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"}}} -->
<h5 class="wp-block-heading has-text-align-center product-title" style="font-size:23px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('purebloom face cream', 'cosmetics-shop'); ?></h5>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","className":"product-price","style":{"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"700"},"elements":{"link":{"color":{"text":"var:preset|color|primary"}}},"spacing":{"margin":{"top":"0px"}}},"textColor":"primary"} -->
<p class="has-text-align-center product-price has-primary-color has-text-color has-link-color" style="margin-top:0px;font-size:16px;font-style:normal;font-weight:700"><?php echo esc_html__('$31.00', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph -->

<!-- wp:buttons {"className":"product-btn","style":{"border":{"width":"0px","style":"none"},"spacing":{"margin":{"top":"0px"}}},"layout":{"type":"flex","justifyContent":"center"}} -->
<div class="wp-block-buttons product-btn" style="border-style:none;border-width:0px;margin-top:0px"><!-- wp:button {"textColor":"secondary","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"17px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"},"border":{"radius":{"topLeft":"0px","topRight":"0px","bottomLeft":"0px","bottomRight":"0px"},"width":"0px","style":"none"},"spacing":{"padding":{"left":"5px","right":"5px","top":"0px","bottom":"0px"}},"color":{"background":"#00000000"}}} -->
<div class="wp-block-button"><a class="wp-block-button__link has-secondary-color has-text-color has-background has-link-color has-custom-font-size wp-element-button" href="#" style="border-style:none;border-width:0px;border-top-left-radius:0px;border-top-right-radius:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px;background-color:#00000000;padding-top:0px;padding-right:5px;padding-bottom:0px;padding-left:5px;font-size:17px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('order now', 'cosmetics-shop'); ?></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"product-box"} -->
<div class="wp-block-column product-box"><!-- wp:image {"id":48,"width":"auto","height":"320px","sizeSlug":"full","linkDestination":"none","className":"product-img","style":{"spacing":{"margin":{"bottom":"var:preset|spacing|50"}}}} -->
<figure class="wp-block-image size-full is-resized product-img" style="margin-bottom:var(--wp--preset--spacing--50)"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/product4.png" alt="" class="wp-image-48" style="width:auto;height:320px"/></figure>
<!-- /wp:image -->

<!-- wp:heading {"textAlign":"center","level":5,"className":"product-title","style":{"typography":{"fontSize":"23px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"}}} -->
<h5 class="wp-block-heading has-text-align-center product-title" style="font-size:23px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('radiance revive toner', 'cosmetics-shop'); ?></h5>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","className":"product-price","style":{"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"700"},"elements":{"link":{"color":{"text":"var:preset|color|primary"}}},"spacing":{"margin":{"top":"0px"}}},"textColor":"primary"} -->
<p class="has-text-align-center product-price has-primary-color has-text-color has-link-color" style="margin-top:0px;font-size:16px;font-style:normal;font-weight:700"><?php echo esc_html__('$31.00', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph -->

<!-- wp:buttons {"className":"product-btn","style":{"border":{"width":"0px","style":"none"},"spacing":{"margin":{"top":"0px"}}},"layout":{"type":"flex","justifyContent":"center"}} -->
<div class="wp-block-buttons product-btn" style="border-style:none;border-width:0px;margin-top:0px"><!-- wp:button {"textColor":"secondary","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"17px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"},"border":{"radius":{"topLeft":"0px","topRight":"0px","bottomLeft":"0px","bottomRight":"0px"},"width":"0px","style":"none"},"spacing":{"padding":{"left":"5px","right":"5px","top":"0px","bottom":"0px"}},"color":{"background":"#00000000"}}} -->
<div class="wp-block-button"><a class="wp-block-button__link has-secondary-color has-text-color has-background has-link-color has-custom-font-size wp-element-button" href="#" style="border-style:none;border-width:0px;border-top-left-radius:0px;border-top-right-radius:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px;background-color:#00000000;padding-top:0px;padding-right:5px;padding-bottom:0px;padding-left:5px;font-size:17px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('order now', 'cosmetics-shop'); ?></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:column --></div>
<!-- /wp:columns --></div>
<!-- /wp:group --></div>
<!-- /wp:group -->

<!-- wp:spacer {"height":"50px"} -->
<div style="height:50px" aria-hidden="true" class="wp-block-spacer"></div>
<!-- /wp:spacer -->

<?php } ?>