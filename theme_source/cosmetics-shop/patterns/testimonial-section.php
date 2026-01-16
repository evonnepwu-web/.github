<?php
/**
 * Title: Testimonial Section
 * Slug: cosmetics-shop/testimonial-section
 * Categories: template
 */
?>
<!-- wp:group {"className":"testimonial-section","style":{"spacing":{"padding":{"right":"0px","left":"0px","top":"var:preset|spacing|70","bottom":"var:preset|spacing|70"},"margin":{"top":"0px","bottom":"0px"}}},"backgroundColor":"primary","layout":{"type":"constrained","contentSize":"85%"}} -->
<div class="wp-block-group testimonial-section has-primary-background-color has-background" style="margin-top:0px;margin-bottom:0px;padding-top:var(--wp--preset--spacing--70);padding-right:0px;padding-bottom:var(--wp--preset--spacing--70);padding-left:0px"><!-- wp:columns {"className":"testimonial-heading-box wow fadeInDown"} -->
<div class="wp-block-columns testimonial-heading-box wow fadeInDown"><!-- wp:column {"width":"25%"} -->
<div class="wp-block-column" style="flex-basis:25%"></div>
<!-- /wp:column -->

<!-- wp:column {"width":"50%","className":"testimonial-heading-cont","style":{"spacing":{"padding":{"bottom":"var:preset|spacing|40"}}}} -->
<div class="wp-block-column testimonial-heading-cont" style="padding-bottom:var(--wp--preset--spacing--40);flex-basis:50%"><!-- wp:heading {"textAlign":"center","level":4,"style":{"elements":{"link":{"color":{"text":"var:preset|color|background"}}},"typography":{"fontSize":"24px","fontStyle":"Regular","fontWeight":"400","textTransform":"capitalize"}},"textColor":"background","fontFamily":"rum-raisin"} -->
<h4 class="wp-block-heading has-text-align-center has-background-color has-text-color has-link-color has-rum-raisin-font-family" style="font-size:24px;font-style:Regular;font-weight:400;text-transform:capitalize"><?php echo esc_html__('Reviews', 'cosmetics-shop'); ?></h4>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","className":"testimonial-sec-heading","style":{"elements":{"link":{"color":{"text":"var:preset|color|background"}}},"typography":{"fontSize":"30px","fontStyle":"normal","fontWeight":"700","textTransform":"capitalize"},"spacing":{"margin":{"top":"0px"},"padding":{"right":"25px","left":"25px"}}},"textColor":"background"} -->
<p class="has-text-align-center testimonial-sec-heading has-background-color has-text-color has-link-color" style="margin-top:0px;padding-right:25px;padding-left:25px;font-size:30px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('clients insights', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div>
<!-- /wp:column -->

<!-- wp:column {"width":"25%"} -->
<div class="wp-block-column" style="flex-basis:25%"></div>
<!-- /wp:column --></div>
<!-- /wp:columns -->

<!-- wp:group {"className":"owl-carousel  wow fadeInUp","style":{"spacing":{"margin":{"top":"var:preset|spacing|70"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-group owl-carousel wow fadeInUp" style="margin-top:var(--wp--preset--spacing--70)"><!-- wp:group {"className":"client-box","style":{"dimensions":{"minHeight":""},"spacing":{"padding":{"bottom":"45px"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-group client-box" style="padding-bottom:45px"><!-- wp:cover {"overlayColor":"background","isUserOverlayColor":true,"minHeight":200,"isDark":false,"style":{"border":{"radius":"20px"},"spacing":{"padding":{"top":"var:preset|spacing|60","bottom":"var:preset|spacing|60","left":"var:preset|spacing|60","right":"var:preset|spacing|60"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-cover is-light" style="border-radius:20px;padding-top:var(--wp--preset--spacing--60);padding-right:var(--wp--preset--spacing--60);padding-bottom:var(--wp--preset--spacing--60);padding-left:var(--wp--preset--spacing--60);min-height:200px"><span aria-hidden="true" class="wp-block-cover__background has-background-background-color has-background-dim-100 has-background-dim"></span><div class="wp-block-cover__inner-container"><!-- wp:paragraph {"align":"center","placeholder":"Write title…","style":{"color":{"text":"#797979"},"elements":{"link":{"color":{"text":"#797979"}}}},"fontSize":"extra-small"} -->
<p class="has-text-align-center has-text-color has-link-color has-extra-small-font-size" style="color:#797979"><?php echo esc_html__('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam lobortis laoreet ante, ut rutrum felis tincidunt vel. Proin tellus magna, malesuada sit amet justo non, interdum congue tortor. Donec volutpat sollicitudin urna consequat luctus.', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph -->

<!-- wp:heading {"textAlign":"center","level":5,"style":{"typography":{"textTransform":"capitalize","fontSize":"22px"},"spacing":{"margin":{"top":"var:preset|spacing|40","bottom":"0px"}},"elements":{"link":{"color":{"text":"var:preset|color|heading-color"}}}},"textColor":"heading-color"} -->
<h5 class="wp-block-heading has-text-align-center has-heading-color-color has-text-color has-link-color" style="margin-top:var(--wp--preset--spacing--40);margin-bottom:0px;font-size:22px;text-transform:capitalize"><?php echo esc_html__('ruth polina', 'cosmetics-shop'); ?></h5>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","style":{"spacing":{"margin":{"top":"0px","bottom":"var:preset|spacing|50"}},"elements":{"link":{"color":{"text":"var:preset|color|heading-color"}}},"typography":{"fontSize":"15px","fontStyle":"normal","fontWeight":"500","textTransform":"capitalize"}},"textColor":"heading-color"} -->
<p class="has-text-align-center has-heading-color-color has-text-color has-link-color" style="margin-top:0px;margin-bottom:var(--wp--preset--spacing--50);font-size:15px;font-style:normal;font-weight:500;text-transform:capitalize"><?php echo esc_html__('sales associate', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div></div>
<!-- /wp:cover -->

<!-- wp:image {"id":466,"width":"80px","height":"80px","scale":"cover","sizeSlug":"full","linkDestination":"none","align":"center","className":"client-img","style":{"border":{"radius":"50px","width":"4px"}},"borderColor":"secondary"} -->
<figure class="wp-block-image aligncenter size-full is-resized has-custom-border client-img"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/client1.png" alt="" class="has-border-color has-secondary-border-color wp-image-466" style="border-width:4px;border-radius:50px;object-fit:cover;width:80px;height:80px"/></figure>
<!-- /wp:image --></div>
<!-- /wp:group -->

<!-- wp:group {"className":"client-box","style":{"dimensions":{"minHeight":""},"spacing":{"padding":{"bottom":"45px"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-group client-box" style="padding-bottom:45px"><!-- wp:cover {"overlayColor":"background","isUserOverlayColor":true,"minHeight":200,"isDark":false,"style":{"border":{"radius":"20px"},"spacing":{"padding":{"top":"var:preset|spacing|60","bottom":"var:preset|spacing|60","left":"var:preset|spacing|60","right":"var:preset|spacing|60"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-cover is-light" style="border-radius:20px;padding-top:var(--wp--preset--spacing--60);padding-right:var(--wp--preset--spacing--60);padding-bottom:var(--wp--preset--spacing--60);padding-left:var(--wp--preset--spacing--60);min-height:200px"><span aria-hidden="true" class="wp-block-cover__background has-background-background-color has-background-dim-100 has-background-dim"></span><div class="wp-block-cover__inner-container"><!-- wp:paragraph {"align":"center","placeholder":"Write title…","style":{"color":{"text":"#797979"},"elements":{"link":{"color":{"text":"#797979"}}}},"fontSize":"extra-small"} -->
<p class="has-text-align-center has-text-color has-link-color has-extra-small-font-size" style="color:#797979"><?php echo esc_html__('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam lobortis laoreet ante, ut rutrum felis tincidunt vel. Proin tellus magna, malesuada sit amet justo non, interdum congue tortor. Donec volutpat sollicitudin urna consequat luctus.', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph -->

<!-- wp:heading {"textAlign":"center","level":5,"style":{"typography":{"textTransform":"capitalize","fontSize":"22px"},"spacing":{"margin":{"top":"var:preset|spacing|40","bottom":"0px"}},"elements":{"link":{"color":{"text":"var:preset|color|heading-color"}}}},"textColor":"heading-color"} -->
<h5 class="wp-block-heading has-text-align-center has-heading-color-color has-text-color has-link-color" style="margin-top:var(--wp--preset--spacing--40);margin-bottom:0px;font-size:22px;text-transform:capitalize"><?php echo esc_html__('john wick', 'cosmetics-shop'); ?></h5>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","style":{"spacing":{"margin":{"top":"0px","bottom":"var:preset|spacing|50"}},"typography":{"fontSize":"15px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"500"},"elements":{"link":{"color":{"text":"var:preset|color|heading-color"}}}},"textColor":"heading-color"} -->
<p class="has-text-align-center has-heading-color-color has-text-color has-link-color" style="margin-top:0px;margin-bottom:var(--wp--preset--spacing--50);font-size:15px;font-style:normal;font-weight:500;text-transform:capitalize"><?php echo esc_html__('retail specialist', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div></div>
<!-- /wp:cover -->

<!-- wp:image {"id":481,"width":"80px","height":"80px","scale":"cover","sizeSlug":"full","linkDestination":"none","align":"center","className":"client-img","style":{"border":{"radius":"50px","width":"4px"}},"borderColor":"secondary"} -->
<figure class="wp-block-image aligncenter size-full is-resized has-custom-border client-img"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/client2.png" alt="" class="has-border-color has-secondary-border-color wp-image-481" style="border-width:4px;border-radius:50px;object-fit:cover;width:80px;height:80px"/></figure>
<!-- /wp:image --></div>
<!-- /wp:group -->

<!-- wp:group {"className":"client-box","style":{"dimensions":{"minHeight":""},"spacing":{"padding":{"bottom":"45px"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-group client-box" style="padding-bottom:45px"><!-- wp:cover {"overlayColor":"background","isUserOverlayColor":true,"minHeight":200,"isDark":false,"style":{"border":{"radius":"20px"},"spacing":{"padding":{"top":"var:preset|spacing|60","bottom":"var:preset|spacing|60","left":"var:preset|spacing|60","right":"var:preset|spacing|60"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-cover is-light" style="border-radius:20px;padding-top:var(--wp--preset--spacing--60);padding-right:var(--wp--preset--spacing--60);padding-bottom:var(--wp--preset--spacing--60);padding-left:var(--wp--preset--spacing--60);min-height:200px"><span aria-hidden="true" class="wp-block-cover__background has-background-background-color has-background-dim-100 has-background-dim"></span><div class="wp-block-cover__inner-container"><!-- wp:paragraph {"align":"center","placeholder":"Write title…","style":{"color":{"text":"#797979"},"elements":{"link":{"color":{"text":"#797979"}}}},"fontSize":"extra-small"} -->
<p class="has-text-align-center has-text-color has-link-color has-extra-small-font-size" style="color:#797979"><?php echo esc_html__('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam lobortis laoreet ante, ut rutrum felis tincidunt vel. Proin tellus magna, malesuada sit amet justo non, interdum congue tortor. Donec volutpat sollicitudin urna consequat luctus.', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph -->

<!-- wp:heading {"textAlign":"center","level":5,"style":{"typography":{"textTransform":"capitalize","fontSize":"22px"},"spacing":{"margin":{"top":"var:preset|spacing|40","bottom":"0px"}},"elements":{"link":{"color":{"text":"var:preset|color|heading-color"}}}},"textColor":"heading-color"} -->
<h5 class="wp-block-heading has-text-align-center has-heading-color-color has-text-color has-link-color" style="margin-top:var(--wp--preset--spacing--40);margin-bottom:0px;font-size:22px;text-transform:capitalize"><?php echo esc_html__('sophia james', 'cosmetics-shop'); ?></h5>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","style":{"spacing":{"margin":{"top":"0px","bottom":"var:preset|spacing|50"}},"elements":{"link":{"color":{"text":"var:preset|color|heading-color"}}},"typography":{"fontSize":"15px","fontStyle":"normal","fontWeight":"500","textTransform":"capitalize"}},"textColor":"heading-color"} -->
<p class="has-text-align-center has-heading-color-color has-text-color has-link-color" style="margin-top:0px;margin-bottom:var(--wp--preset--spacing--50);font-size:15px;font-style:normal;font-weight:500;text-transform:capitalize"><?php echo esc_html__('studio executive', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div></div>
<!-- /wp:cover -->

<!-- wp:image {"id":482,"width":"80px","height":"80px","scale":"cover","sizeSlug":"full","linkDestination":"none","align":"center","className":"client-img","style":{"border":{"radius":"50px","width":"4px"}},"borderColor":"secondary"} -->
<figure class="wp-block-image aligncenter size-full is-resized has-custom-border client-img"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/client3.png" alt="" class="has-border-color has-secondary-border-color wp-image-482" style="border-width:4px;border-radius:50px;object-fit:cover;width:80px;height:80px"/></figure>
<!-- /wp:image --></div>
<!-- /wp:group -->

<!-- wp:group {"className":"client-box","style":{"dimensions":{"minHeight":""},"spacing":{"padding":{"bottom":"45px"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-group client-box" style="padding-bottom:45px"><!-- wp:cover {"overlayColor":"background","isUserOverlayColor":true,"minHeight":200,"isDark":false,"style":{"border":{"radius":"20px"},"spacing":{"padding":{"top":"var:preset|spacing|60","bottom":"var:preset|spacing|60","left":"var:preset|spacing|60","right":"var:preset|spacing|60"}}},"layout":{"type":"constrained"}} -->
<div class="wp-block-cover is-light" style="border-radius:20px;padding-top:var(--wp--preset--spacing--60);padding-right:var(--wp--preset--spacing--60);padding-bottom:var(--wp--preset--spacing--60);padding-left:var(--wp--preset--spacing--60);min-height:200px"><span aria-hidden="true" class="wp-block-cover__background has-background-background-color has-background-dim-100 has-background-dim"></span><div class="wp-block-cover__inner-container"><!-- wp:paragraph {"align":"center","placeholder":"Write title…","style":{"color":{"text":"#797979"},"elements":{"link":{"color":{"text":"#797979"}}}},"fontSize":"extra-small"} -->
<p class="has-text-align-center has-text-color has-link-color has-extra-small-font-size" style="color:#797979"><?php echo esc_html__('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam lobortis laoreet ante, ut rutrum felis tincidunt vel. Proin tellus magna, malesuada sit amet justo non, interdum congue tortor. Donec volutpat sollicitudin urna consequat luctus.', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph -->

<!-- wp:heading {"textAlign":"center","level":5,"style":{"typography":{"textTransform":"capitalize","fontSize":"22px"},"spacing":{"margin":{"top":"var:preset|spacing|40","bottom":"0px"}},"elements":{"link":{"color":{"text":"var:preset|color|heading-color"}}}},"textColor":"heading-color"} -->
<h5 class="wp-block-heading has-text-align-center has-heading-color-color has-text-color has-link-color" style="margin-top:var(--wp--preset--spacing--40);margin-bottom:0px;font-size:22px;text-transform:capitalize"><?php echo esc_html__('Liam Alexander', 'cosmetics-shop'); ?></h5>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","style":{"spacing":{"margin":{"top":"0px","bottom":"var:preset|spacing|50"}},"elements":{"link":{"color":{"text":"var:preset|color|heading-color"}}},"typography":{"fontSize":"15px","fontStyle":"normal","fontWeight":"500","textTransform":"capitalize"}},"textColor":"heading-color"} -->
<p class="has-text-align-center has-heading-color-color has-text-color has-link-color" style="margin-top:0px;margin-bottom:var(--wp--preset--spacing--50);font-size:15px;font-style:normal;font-weight:500;text-transform:capitalize"><?php echo esc_html__('Business Analyst', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div></div>
<!-- /wp:cover -->

<!-- wp:image {"id":483,"width":"80px","height":"80px","scale":"cover","sizeSlug":"full","linkDestination":"none","align":"center","className":"client-img","style":{"border":{"radius":"50px","width":"4px"}},"borderColor":"secondary"} -->
<figure class="wp-block-image aligncenter size-full is-resized has-custom-border client-img"><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/client4.png" alt="" class="has-border-color has-secondary-border-color wp-image-483" style="border-width:4px;border-radius:50px;object-fit:cover;width:80px;height:80px"/></figure>
<!-- /wp:image --></div>
<!-- /wp:group --></div>
<!-- /wp:group --></div>
<!-- /wp:group -->

<!-- wp:spacer {"height":"50px"} -->
<div style="height:50px" aria-hidden="true" class="wp-block-spacer"></div>
<!-- /wp:spacer -->