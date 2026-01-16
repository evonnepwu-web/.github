<?php
/**
 * Title: News Section
 * Slug: cosmetics-shop/news-section
 * Categories: template
 */
?>
<!-- wp:group {"className":"news-section","style":{"spacing":{"margin":{"top":"0px","bottom":"0px"},"padding":{"top":"0rem","bottom":"0rem"}}},"layout":{"type":"constrained","contentSize":"85%"}} -->
<div class="wp-block-group news-section" style="margin-top:0px;margin-bottom:0px;padding-top:0rem;padding-bottom:0rem"><!-- wp:columns {"className":"news-heading-box wow fadeInDown","style":{"spacing":{"margin":{"bottom":"var:preset|spacing|70"}}}} -->
<div class="wp-block-columns news-heading-box wow fadeInDown" style="margin-bottom:var(--wp--preset--spacing--70)"><!-- wp:column {"width":"25%"} -->
<div class="wp-block-column" style="flex-basis:25%"></div>
<!-- /wp:column -->

<!-- wp:column {"width":"50%","className":"news-heading-inner-box"} -->
<div class="wp-block-column news-heading-inner-box" style="flex-basis:50%"><!-- wp:heading {"textAlign":"center","level":4,"style":{"elements":{"link":{"color":{"text":"var:preset|color|primary"}}},"typography":{"fontSize":"24px","fontStyle":"Regular","fontWeight":"400","textTransform":"capitalize"}},"textColor":"primary","fontFamily":"rum-raisin"} -->
<h4 class="wp-block-heading has-text-align-center has-primary-color has-text-color has-link-color has-rum-raisin-font-family" style="font-size:24px;font-style:Regular;font-weight:400;text-transform:capitalize"><?php echo esc_html__('our blog', 'cosmetics-shop'); ?></h4>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","className":"news-sec-heading","style":{"elements":{"link":{"color":{"text":"var:preset|color|secondary"}}},"typography":{"fontSize":"30px","textTransform":"capitalize","fontStyle":"normal","fontWeight":"700"},"spacing":{"margin":{"top":"0px"},"padding":{"right":"25px","left":"25px"}}},"textColor":"secondary"} -->
<p class="has-text-align-center news-sec-heading has-secondary-color has-text-color has-link-color" style="margin-top:0px;padding-right:25px;padding-left:25px;font-size:30px;font-style:normal;font-weight:700;text-transform:capitalize"><?php echo esc_html__('our latest news & blogs', 'cosmetics-shop'); ?></p>
<!-- /wp:paragraph --></div>
<!-- /wp:column -->

<!-- wp:column {"width":"25%"} -->
<div class="wp-block-column" style="flex-basis:25%"></div>
<!-- /wp:column --></div>
<!-- /wp:columns -->

<!-- wp:query {"queryId":11,"query":{"perPage":6,"pages":0,"offset":0,"postType":"post","order":"desc","orderBy":"date","author":"","search":"","exclude":[],"sticky":"","inherit":false,"parents":[],"format":[]},"metadata":{"categories":["posts"],"patternName":"core/query-standard-posts","name":"Standard"}} -->
<div class="wp-block-query"><!-- wp:post-template {"className":"news-box owl-carousel wow fadeInUp","layout":{"type":"grid","columnCount":3}} -->
<!-- wp:group {"className":"news-img","style":{"dimensions":{"minHeight":"230px"},"border":{"radius":"20px"},"spacing":{"padding":{"top":"0px","bottom":"0px","left":"0px","right":"0px"}},"color":{"background":"#797979"}},"layout":{"type":"constrained"}} -->
<div class="wp-block-group news-img has-background" style="border-radius:20px;background-color:#797979;min-height:230px;padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px"><!-- wp:post-featured-image {"isLink":true,"height":"230px","align":"wide","style":{"border":{"radius":"20px"},"color":[]}} /--></div>
<!-- /wp:group -->

<!-- wp:post-title {"level":5,"isLink":true,"className":"news-box-title","style":{"spacing":{"margin":{"bottom":"var:preset|spacing|20","top":"var:preset|spacing|30"}}}} /-->

<!-- wp:post-excerpt {"className":"news-box-desc","style":{"typography":{"fontSize":"15px","lineHeight":1.4},"spacing":{"margin":{"top":"0px","bottom":"5px"}}}} /-->

<!-- wp:group {"className":"news-meta","fontFamily":"inter","layout":{"type":"flex","flexWrap":"nowrap","justifyContent":"space-between"}} -->
<div class="wp-block-group news-meta has-inter-font-family"><!-- wp:post-author-name {"style":{"typography":{"textTransform":"capitalize","lineHeight":"1.2","fontStyle":"normal","fontWeight":"600","fontSize":"15px"},"spacing":{"padding":{"left":"var:preset|spacing|50","top":"3px"}}}} /-->

<!-- wp:post-date {"metadata":{"bindings":{"datetime":{"source":"core/post-data","args":{"field":"date"}}}},"style":{"layout":{"selfStretch":"fit","flexSize":null},"spacing":{"padding":{"left":"var:preset|spacing|50","top":"3px"}},"typography":{"fontStyle":"normal","fontWeight":"600","fontSize":"15px"}}} /-->

<!-- wp:comments -->
<div class="wp-block-comments"><!-- wp:comments-title {"showPostTitle":false,"level":6,"style":{"typography":{"fontStyle":"normal","fontWeight":"600","fontSize":"15px","textTransform":"capitalize"},"spacing":{"margin":{"top":"0px","bottom":"0px"},"padding":{"left":"var:preset|spacing|50","top":"3px"}}}} /--></div>
<!-- /wp:comments --></div>
<!-- /wp:group -->
<!-- /wp:post-template --></div>
<!-- /wp:query --></div>
<!-- /wp:group -->

<!-- wp:spacer {"height":"50px"} -->
<div style="height:50px" aria-hidden="true" class="wp-block-spacer"></div>
<!-- /wp:spacer -->