<?php
/**
 * Title: Slider
 * Slug: cosmetics-shop/slider
 * Categories: template
 */
$cosmetics_shop_pluginsList = get_option( 'active_plugins' );
$cosmetics_shop_plugin = 'woocommerce/woocommerce.php';
$cosmetics_shop_results = in_array( $cosmetics_shop_plugin , $cosmetics_shop_pluginsList);
if ( $cosmetics_shop_results )  {
?>

<!-- wp:group {"className":"slider-section","style":{"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"},"margin":{"top":"0","bottom":"0"}},"border":{"radius":"0px"}},"backgroundColor":"section-bg-color","layout":{"type":"default"}} -->
<div class="wp-block-group slider-section has-section-bg-color-background-color has-background" style="border-radius:0px;margin-top:0;margin-bottom:0;padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px"><!-- wp:woocommerce/product-collection {"queryId":0,"query":{"perPage":6,"pages":1,"offset":0,"postType":"product","order":"desc","orderBy":"date","search":"","exclude":[],"inherit":false,"taxQuery":[],"isProductCollectionBlock":true,"featured":false,"woocommerceOnSale":false,"woocommerceStockStatus":["instock","outofstock","onbackorder"],"woocommerceAttributes":[],"woocommerceHandPickedProducts":[],"timeFrame":{"operator":"in","value":"-7 days"},"filterable":false,"relatedBy":{"categories":true,"tags":true}},"tagName":"div","displayLayout":{"type":"flex","columns":1,"shrinkColumns":true},"dimensions":{"widthType":"fill"},"collection":"woocommerce/product-collection/new-arrivals","hideControls":["inherit","order","filterable"],"queryContextIncludes":["collection"],"__privatePreviewState":{"isPreview":false,"previewMessage":"Actual products will vary depending on the page being viewed."},"className":"slider-products-sec"} -->
<div class="wp-block-woocommerce-product-collection slider-products-sec"><!-- wp:woocommerce/product-template {"className":"slider-products owl-carousel"} -->
<!-- wp:columns {"className":"slider-products-content","style":{"spacing":{"blockGap":{"top":"0px","left":"0px"},"margin":{"top":"0px","bottom":"0px"}}}} -->
<div class="wp-block-columns slider-products-content" style="margin-top:0px;margin-bottom:0px"><!-- wp:column {"className":"slider-products-left","layout":{"type":"default"}} -->
<div class="wp-block-column slider-products-left"><!-- wp:woocommerce/product-image {"showSaleBadge":false,"imageSizing":"thumbnail","isDescendentOfQueryLoop":true,"height":"600px","className":"slider-product-img"} -->
<!-- wp:group {"style":{"spacing":{"padding":{"bottom":"var:preset|spacing|50"}}},"layout":{"type":"constrained","contentSize":"70%"}} -->
<div class="wp-block-group" style="padding-bottom:var(--wp--preset--spacing--50)"><!-- wp:post-title {"textAlign":"left","isLink":true,"className":"slider-product-title","style":{"spacing":{"margin":{"bottom":"0.75rem","top":"0"}},"typography":{"lineHeight":"1.4","fontSize":"24px"},"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}}},"textColor":"secondary","__woocommerceNamespace":"woocommerce/product-collection/product-title"} /-->

<!-- wp:woocommerce/product-price {"isDescendentOfQueryLoop":true,"textAlign":"left","className":"slider-product-price","style":{"typography":{"fontSize":"15px","fontStyle":"normal","fontWeight":"600"},"color":{"text":"#585858"},"elements":{"link":{"color":{"text":"#585858"}}},"spacing":{"margin":{"top":"0px","bottom":"0px"}}}} /--></div>
<!-- /wp:group -->
<!-- /wp:woocommerce/product-image --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"slider-products-right"} -->
<div class="wp-block-column slider-products-right"><!-- wp:cover {"isUserOverlayColor":true,"minHeight":600,"gradient":"slider-background","contentPosition":"bottom center","className":"slider-right-bg","style":{"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"}}},"layout":{"type":"default"}} -->
<div class="wp-block-cover has-custom-content-position is-position-bottom-center slider-right-bg" style="padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px;min-height:600px"><span aria-hidden="true" class="wp-block-cover__background has-background-dim-100 has-background-dim has-background-gradient has-slider-background-gradient-background"></span><div class="wp-block-cover__inner-container"><!-- wp:image {"id":39,"scale":"cover","sizeSlug":"full","linkDestination":"none","align":"center","className":"slider-right-img"} -->
<figure class="wp-block-image aligncenter size-full slider-right-img"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/right-img.png" alt="" class="wp-image-39" style="object-fit:cover"/></figure>
<!-- /wp:image -->

<!-- wp:buttons {"className":"slider-btn","style":{"spacing":{"margin":{"top":"0px","bottom":"0px"}}}} -->
<div class="wp-block-buttons slider-btn" style="margin-top:0px;margin-bottom:0px"><!-- wp:button {"backgroundColor":"background","textColor":"secondary","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"600","textTransform":"capitalize"},"border":{"radius":{"topLeft":"8px","topRight":"8px","bottomLeft":"8px","bottomRight":"8px"},"width":"0px","style":"none"},"spacing":{"padding":{"left":"15px","right":"15px","top":"7px","bottom":"7px"}}}} -->
<div class="wp-block-button"><a class="wp-block-button__link has-secondary-color has-background-background-color has-text-color has-background has-link-color has-custom-font-size wp-element-button" style="border-style:none;border-width:0px;border-top-left-radius:8px;border-top-right-radius:8px;border-bottom-left-radius:8px;border-bottom-right-radius:8px;padding-top:7px;padding-right:15px;padding-bottom:7px;padding-left:15px;font-size:16px;font-style:normal;font-weight:600;text-transform:capitalize"><?php echo esc_html__('shop now', 'cosmetics-shop'); ?><img class="wp-image-50" style="width: 52px;" src="<?php echo esc_url(get_template_directory_uri()); ?>/images/btn-img.png" alt=""></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div></div>
<!-- /wp:cover --></div>
<!-- /wp:column --></div>
<!-- /wp:columns -->
<!-- /wp:woocommerce/product-template --></div>
<!-- /wp:woocommerce/product-collection --></div>
<!-- /wp:group -->

<!-- wp:spacer {"height":"10px"} -->
<div style="height:10px" aria-hidden="true" class="wp-block-spacer"></div>
<!-- /wp:spacer -->

<?php } else { ?>

<!-- wp:group {"className":"slider-section","style":{"dimensions":{"minHeight":""},"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"},"margin":{"top":"0","bottom":"0"}},"border":{"radius":"0px"}},"backgroundColor":"section-bg-color","layout":{"type":"default"}} -->
<div class="wp-block-group slider-section has-section-bg-color-background-color has-background" style="border-radius:0px;margin-top:0;margin-bottom:0;padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px"><!-- wp:group {"className":"slider-products-sec","layout":{"type":"default"}} -->
<div class="wp-block-group slider-products-sec"><!-- wp:group {"className":"slider-products owl-carousel","layout":{"type":"default"}} -->
<div class="wp-block-group slider-products owl-carousel"><!-- wp:columns {"className":"slider-products-content","style":{"spacing":{"blockGap":{"top":"0px","left":"0px"},"margin":{"bottom":"0px"}}}} -->
<div class="wp-block-columns slider-products-content" style="margin-bottom:0px"><!-- wp:column {"className":"slider-products-left"} -->
<div class="wp-block-column slider-products-left"><!-- wp:cover {"url":"<?php echo esc_url(get_template_directory_uri()); ?>/images/slider-product1.png","id":32,"dimRatio":0,"isUserOverlayColor":true,"minHeight":600,"contentPosition":"bottom center","isDark":false,"sizeSlug":"full","className":"slider-product-img","style":{"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"}}},"layout":{"type":"default"}} -->
<div class="wp-block-cover is-light has-custom-content-position is-position-bottom-center slider-product-img" style="padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px;min-height:600px"><img class="wp-block-cover__image-background wp-image-32 size-full" alt="" src="<?php echo esc_url(get_template_directory_uri()); ?>/images/slider-product1.png" data-object-fit="cover"/><span aria-hidden="true" class="wp-block-cover__background has-background-dim-0 has-background-dim"></span><div class="wp-block-cover__inner-container"><!-- wp:group {"style":{"spacing":{"padding":{"bottom":"var:preset|spacing|50"}}},"layout":{"type":"constrained","contentSize":"70%"}} -->
<div class="wp-block-group" style="padding-bottom:var(--wp--preset--spacing--50)"><!-- wp:heading {"className":"slider-product-title","style":{"typography":{"fontSize":"22px","fontStyle":"normal","fontWeight":"700","textTransform":"capitalize"}}} -->
<h2 class="wp-block-heading slider-product-title" style="font-size:22px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('product name here', 'cosmetics-shop'); ?></h2>
<!-- /wp:heading -->

<!-- wp:paragraph {"className":"slider-product-price","style":{"color":{"text":"#585858"},"elements":{"link":{"color":{"text":"#585858"}}},"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"700"},"spacing":{"margin":{"top":"8px"}}}} -->
<p class="slider-product-price has-text-color has-link-color" style="color:#585858;margin-top:8px;font-size:16px;font-style:normal;font-weight:700"><?php echo esc_html__('$120.00', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div>
<!-- /wp:group --></div></div>
<!-- /wp:cover --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"slider-products-right"} -->
<div class="wp-block-column slider-products-right"><!-- wp:cover {"isUserOverlayColor":true,"minHeight":600,"gradient":"slider-background","contentPosition":"bottom center","className":"slider-right-bg","style":{"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"}}},"layout":{"type":"default"}} -->
<div class="wp-block-cover has-custom-content-position is-position-bottom-center slider-right-bg" style="padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px;min-height:600px"><span aria-hidden="true" class="wp-block-cover__background has-background-dim-100 has-background-dim has-background-gradient has-slider-background-gradient-background"></span><div class="wp-block-cover__inner-container"><!-- wp:image {"id":39,"scale":"cover","sizeSlug":"full","linkDestination":"none","align":"center","className":"slider-right-img"} -->
<figure class="wp-block-image aligncenter size-full slider-right-img"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/right-img.png" alt="" class="wp-image-39" style="object-fit:cover"/></figure>
<!-- /wp:image -->

<!-- wp:buttons {"className":"slider-btn","style":{"spacing":{"margin":{"top":"0px","bottom":"0px"}}}} -->
<div class="wp-block-buttons slider-btn" style="margin-top:0px;margin-bottom:0px"><!-- wp:button {"backgroundColor":"background","textColor":"secondary","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"600","textTransform":"capitalize"},"border":{"radius":{"topLeft":"8px","topRight":"8px","bottomLeft":"8px","bottomRight":"8px"},"width":"0px","style":"none"},"spacing":{"padding":{"left":"15px","right":"15px","top":"7px","bottom":"7px"}}}} -->
<div class="wp-block-button"><a class="wp-block-button__link has-secondary-color has-background-background-color has-text-color has-background has-link-color has-custom-font-size wp-element-button" href="#" style="border-style:none;border-width:0px;border-top-left-radius:8px;border-top-right-radius:8px;border-bottom-left-radius:8px;border-bottom-right-radius:8px;padding-top:7px;padding-right:15px;padding-bottom:7px;padding-left:15px;font-size:16px;font-style:normal;font-weight:600;text-transform:capitalize"><?php echo esc_html__('shop now', 'cosmetics-shop'); ?><img class="wp-image-50" style="width: 52px;" src="<?php echo esc_url(get_template_directory_uri()); ?>/images/btn-img.png" alt=""></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div></div>
<!-- /wp:cover --></div>
<!-- /wp:column --></div>
<!-- /wp:columns -->

<!-- wp:columns {"className":"slider-products-content","style":{"spacing":{"blockGap":{"top":"0px","left":"0px"},"margin":{"bottom":"0px"}}}} -->
<div class="wp-block-columns slider-products-content" style="margin-bottom:0px"><!-- wp:column {"className":"slider-products-left"} -->
<div class="wp-block-column slider-products-left"><!-- wp:cover {"url":"<?php echo esc_url(get_template_directory_uri()); ?>/images/slider-product2.png","id":48,"dimRatio":0,"isUserOverlayColor":true,"minHeight":600,"contentPosition":"bottom center","isDark":false,"sizeSlug":"full","className":"slider-product-img","style":{"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"}}},"layout":{"type":"default"}} -->
<div class="wp-block-cover is-light has-custom-content-position is-position-bottom-center slider-product-img" style="padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px;min-height:600px"><img class="wp-block-cover__image-background wp-image-48 size-full" alt="" src="<?php echo esc_url(get_template_directory_uri()); ?>/images/slider-product2.png" data-object-fit="cover"/><span aria-hidden="true" class="wp-block-cover__background has-background-dim-0 has-background-dim"></span><div class="wp-block-cover__inner-container"><!-- wp:group {"style":{"spacing":{"padding":{"bottom":"var:preset|spacing|50"}}},"layout":{"type":"constrained","contentSize":"70%"}} -->
<div class="wp-block-group" style="padding-bottom:var(--wp--preset--spacing--50)"><!-- wp:heading {"className":"slider-product-title","style":{"typography":{"fontSize":"22px","fontStyle":"normal","fontWeight":"700","textTransform":"capitalize"}}} -->
<h2 class="wp-block-heading slider-product-title" style="font-size:22px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('product name here', 'cosmetics-shop'); ?></h2>
<!-- /wp:heading -->

<!-- wp:paragraph {"className":"slider-product-price","style":{"color":{"text":"#585858"},"elements":{"link":{"color":{"text":"#585858"}}},"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"700"},"spacing":{"margin":{"top":"8px"}}}} -->
<p class="slider-product-price has-text-color has-link-color" style="color:#585858;margin-top:8px;font-size:16px;font-style:normal;font-weight:700"><?php echo esc_html__('$120.00', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div>
<!-- /wp:group --></div></div>
<!-- /wp:cover --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"slider-products-right"} -->
<div class="wp-block-column slider-products-right"><!-- wp:cover {"isUserOverlayColor":true,"minHeight":600,"gradient":"slider-background","contentPosition":"bottom center","className":"slider-right-bg","style":{"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"}}},"layout":{"type":"default"}} -->
<div class="wp-block-cover has-custom-content-position is-position-bottom-center slider-right-bg" style="padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px;min-height:600px"><span aria-hidden="true" class="wp-block-cover__background has-background-dim-100 has-background-dim has-background-gradient has-slider-background-gradient-background"></span><div class="wp-block-cover__inner-container"><!-- wp:image {"id":51,"scale":"cover","sizeSlug":"full","linkDestination":"none","align":"center","className":"slider-right-img"} -->
<figure class="wp-block-image aligncenter size-full slider-right-img"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/right-img1.png" alt="" class="wp-image-51" style="object-fit:cover"/></figure>
<!-- /wp:image -->

<!-- wp:buttons {"className":"slider-btn","style":{"spacing":{"margin":{"top":"0px","bottom":"0px"}}}} -->
<div class="wp-block-buttons slider-btn" style="margin-top:0px;margin-bottom:0px"><!-- wp:button {"backgroundColor":"background","textColor":"secondary","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"600","textTransform":"capitalize"},"border":{"radius":{"topLeft":"8px","topRight":"8px","bottomLeft":"8px","bottomRight":"8px"},"width":"0px","style":"none"},"spacing":{"padding":{"left":"15px","right":"15px","top":"7px","bottom":"7px"}}}} -->
<div class="wp-block-button"><a class="wp-block-button__link has-secondary-color has-background-background-color has-text-color has-background has-link-color has-custom-font-size wp-element-button" href="#" style="border-style:none;border-width:0px;border-top-left-radius:8px;border-top-right-radius:8px;border-bottom-left-radius:8px;border-bottom-right-radius:8px;padding-top:7px;padding-right:15px;padding-bottom:7px;padding-left:15px;font-size:16px;font-style:normal;font-weight:600;text-transform:capitalize"><?php echo esc_html__('shop now', 'cosmetics-shop'); ?><img class="wp-image-50" style="width: 52px;" src="<?php echo esc_url(get_template_directory_uri()); ?>/images/btn-img.png" alt=""></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div></div>
<!-- /wp:cover --></div>
<!-- /wp:column --></div>
<!-- /wp:columns -->

<!-- wp:columns {"className":"slider-products-content","style":{"spacing":{"blockGap":{"top":"0px","left":"0px"},"margin":{"bottom":"0px"}}}} -->
<div class="wp-block-columns slider-products-content" style="margin-bottom:0px"><!-- wp:column {"className":"slider-products-left"} -->
<div class="wp-block-column slider-products-left"><!-- wp:cover {"url":"<?php echo esc_url(get_template_directory_uri()); ?>/images/slider-product3.png","id":49,"dimRatio":0,"isUserOverlayColor":true,"minHeight":600,"contentPosition":"bottom center","isDark":false,"sizeSlug":"full","className":"slider-product-img","style":{"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"}}},"layout":{"type":"default"}} -->
<div class="wp-block-cover is-light has-custom-content-position is-position-bottom-center slider-product-img" style="padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px;min-height:600px"><img class="wp-block-cover__image-background wp-image-49 size-full" alt="" src="<?php echo esc_url(get_template_directory_uri()); ?>/images/slider-product3.png" data-object-fit="cover"/><span aria-hidden="true" class="wp-block-cover__background has-background-dim-0 has-background-dim"></span><div class="wp-block-cover__inner-container"><!-- wp:group {"style":{"spacing":{"padding":{"bottom":"var:preset|spacing|50"}}},"layout":{"type":"constrained","contentSize":"70%"}} -->
<div class="wp-block-group" style="padding-bottom:var(--wp--preset--spacing--50)"><!-- wp:heading {"className":"slider-product-title","style":{"typography":{"fontSize":"22px","fontStyle":"normal","fontWeight":"700","textTransform":"capitalize"}}} -->
<h2 class="wp-block-heading slider-product-title" style="font-size:22px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('product name here', 'cosmetics-shop'); ?></h2>
<!-- /wp:heading -->

<!-- wp:paragraph {"className":"slider-product-price","style":{"color":{"text":"#585858"},"elements":{"link":{"color":{"text":"#585858"}}},"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"700"},"spacing":{"margin":{"top":"8px"}}}} -->
<p class="slider-product-price has-text-color has-link-color" style="color:#585858;margin-top:8px;font-size:16px;font-style:normal;font-weight:700"><?php echo esc_html__('$120.00', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div>
<!-- /wp:group --></div></div>
<!-- /wp:cover --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"slider-products-right"} -->
<div class="wp-block-column slider-products-right"><!-- wp:cover {"isUserOverlayColor":true,"minHeight":600,"gradient":"slider-background","contentPosition":"bottom center","className":"slider-right-bg","style":{"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"}}},"layout":{"type":"default"}} -->
<div class="wp-block-cover has-custom-content-position is-position-bottom-center slider-right-bg" style="padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px;min-height:600px"><span aria-hidden="true" class="wp-block-cover__background has-background-dim-100 has-background-dim has-background-gradient has-slider-background-gradient-background"></span><div class="wp-block-cover__inner-container"><!-- wp:image {"id":50,"scale":"cover","sizeSlug":"full","linkDestination":"none","align":"center","className":"slider-right-img"} -->
<figure class="wp-block-image aligncenter size-full slider-right-img"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/right-img2.png" alt="" class="wp-image-50" style="object-fit:cover"/></figure>
<!-- /wp:image -->

<!-- wp:buttons {"className":"slider-btn","style":{"spacing":{"margin":{"top":"0px","bottom":"0px"}}}} -->
<div class="wp-block-buttons slider-btn" style="margin-top:0px;margin-bottom:0px"><!-- wp:button {"backgroundColor":"background","textColor":"secondary","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"16px","fontStyle":"normal","fontWeight":"600","textTransform":"capitalize"},"border":{"radius":{"topLeft":"8px","topRight":"8px","bottomLeft":"8px","bottomRight":"8px"},"width":"0px","style":"none"},"spacing":{"padding":{"left":"15px","right":"15px","top":"7px","bottom":"7px"}}}} -->
<div class="wp-block-button"><a class="wp-block-button__link has-secondary-color has-background-background-color has-text-color has-background has-link-color has-custom-font-size wp-element-button" href="#" style="border-style:none;border-width:0px;border-top-left-radius:8px;border-top-right-radius:8px;border-bottom-left-radius:8px;border-bottom-right-radius:8px;padding-top:7px;padding-right:15px;padding-bottom:7px;padding-left:15px;font-size:16px;font-style:normal;font-weight:600;text-transform:capitalize"><?php echo esc_html__('shop now', 'cosmetics-shop'); ?><img class="wp-image-50" style="width: 52px;" src="<?php echo esc_url(get_template_directory_uri()); ?>/images/btn-img.png" alt=""></a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div></div>
<!-- /wp:cover --></div>
<!-- /wp:column --></div>
<!-- /wp:columns --></div>
<!-- /wp:group --></div>
<!-- /wp:group --></div>
<!-- /wp:group -->

<!-- wp:spacer {"height":"10px"} -->
<div style="height:10px" aria-hidden="true" class="wp-block-spacer"></div>
<!-- /wp:spacer -->

<?php } ?>