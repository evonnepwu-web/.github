<?php
/**
 * Cosmetics Shop: Block Patterns
 *
 * @since Cosmetics Shop 1.0
 */

 /**
  * Get patterns content.
  *
  * @param string $file_name Filename.
  * @return string
  */
function cosmetics_shop_get_pattern_content( $file_name ) {
	ob_start();
	include get_theme_file_path( '/patterns/' . $file_name . '.php' );
	$output = ob_get_contents();
	ob_end_clean();
	return $output;
}

/**
 * Registers block patterns and categories.
 *
 * @since Cosmetics Shop 1.0
 *
 * @return void
 */
function cosmetics_shop_register_block_patterns() {

	$patterns = array(
		'header-default' => array(
			'title'      => __( 'Default header', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-headers' ),
			'blockTypes' => array( 'parts/header' ),
		),
		'footer-default' => array(
			'title'      => __( 'Default footer', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-footers' ),
			'blockTypes' => array( 'parts/footer' ),
		),
		'slider' => array(
			'title'      => __( 'Slider', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-slider' ),
		),
		'product-section' => array(
			'title'      => __( 'Product Section', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-product-section' ),
		),
		'about-us-section' => array(
			'title'      => __( 'About Us Section', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-about-us-section' ),
		),
		'testimonial-section' => array(
			'title'      => __( 'Testimonial Section', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-testimonial-section' ),
		),
		'news-section' => array(
			'title'      => __( 'News Section', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-news-section' ),
		),
		'faq-section' => array(
			'title'      => __( 'FAQ Section', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-faq-section' ),
		),
		'primary-sidebar' => array(
			'title'    => __( 'Primary Sidebar', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-sidebars' ),
		),
		'hidden-404' => array(
			'title'    => __( '404 content', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-pages' ),
		),
		'post-listing-single-column' => array(
			'title'    => __( 'Post Single Column', 'cosmetics-shop' ),
			//'inserter' => false,
			'categories' => array( 'cosmetics-shop-query' ),
		),
		'post-listing-two-column' => array(
			'title'    => __( 'Post Two Column', 'cosmetics-shop' ),
			//'inserter' => false,
			'categories' => array( 'cosmetics-shop-query' ),
		),
		'post-listing-three-column' => array(
			'title'    => __( 'Post Three Column', 'cosmetics-shop' ),
			//'inserter' => false,
			'categories' => array( 'cosmetics-shop-query' ),
		),
		'post-listing-four-column' => array(
			'title'    => __( 'Post Four Column', 'cosmetics-shop' ),
			//'inserter' => false,
			'categories' => array( 'cosmetics-shop-query' ),
		),
		'feature-post-column' => array(
			'title'    => __( 'Feature Post Column', 'cosmetics-shop' ),
			//'inserter' => false,
			'categories' => array( 'cosmetics-shop-query' ),
		),
		'comment-section-1' => array(
			'title'    => __( 'Comment Section 1', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-comment-sections' ),
		),
		'cover-with-post-title' => array(
			'title'    => __( 'Cover With Post Title', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-banner-sections' ),
		),
		'cover-with-search-title' => array(
			'title'    => __( 'Cover With Search Title', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-banner-sections' ),
		),
		'cover-with-archive-title' => array(
			'title'    => __( 'Cover With Archive Title', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-banner-sections' ),
		),
		'cover-with-index-title' => array(
			'title'    => __( 'Cover With Index Title', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-banner-sections' ),
		),
		'theme-button' => array(
			'title'    => __( 'Theme Button', 'cosmetics-shop' ),
			'categories' => array( 'cosmetics-shop-theme-button' ),
		),
	);

	$block_pattern_categories = array(
		'cosmetics-shop-footers' => array( 'label' => __( 'Footers', 'cosmetics-shop' ) ),
		'cosmetics-shop-headers' => array( 'label' => __( 'Headers', 'cosmetics-shop' ) ),
		'cosmetics-shop-pages'   => array( 'label' => __( 'Pages', 'cosmetics-shop' ) ),
		'cosmetics-shop-query'   => array( 'label' => __( 'Query', 'cosmetics-shop' ) ),
		'cosmetics-shop-sidebars'   => array( 'label' => __( 'Sidebars', 'cosmetics-shop' ) ),
		'cosmetics-shop-slider'   => array( 'label' => __( 'Slider', 'cosmetics-shop' ) ),
		'cosmetics-shop-product-section'   => array( 'label' => __( 'Product Section', 'cosmetics-shop' ) ),
		'cosmetics-shop-about-us-section'   => array( 'label' => __( 'About Us Section', 'cosmetics-shop' ) ),
		'cosmetics-shop-testimonial-section'   => array( 'label' => __( 'Testimonial Section', 'cosmetics-shop' ) ),
		'cosmetics-shop-news-section'   => array( 'label' => __( 'News Section', 'cosmetics-shop' ) ),
		'cosmetics-shop-faq-section'   => array( 'label' => __( 'FAQ Section', 'cosmetics-shop' ) ),
		'cosmetics-shop-comment-section'   => array( 'label' => __( 'Comment Sections', 'cosmetics-shop' ) ),
		'cosmetics-shop-theme-button'   => array( 'label' => __( 'Theme Button Sections', 'cosmetics-shop' ) ),
	);

	/**
	 * Filters the theme block pattern categories.
	 *
	 * @since Cosmetics Shop 1.0
	 *
	 * @param array[] $block_pattern_categories {
	 *     An associative array of block pattern categories, keyed by category name.
	 *
	 *     @type array[] $properties {
	 *         An array of block category properties.
	 *
	 *         @type string $label A human-readable label for the pattern category.
	 *     }
	 * }
	 */
	$block_pattern_categories = apply_filters( 'cosmetics_shop_block_pattern_categories', $block_pattern_categories );

	foreach ( $block_pattern_categories as $name => $properties ) {
		if ( ! WP_Block_Pattern_Categories_Registry::get_instance()->is_registered( $name ) ) {
			register_block_pattern_category( $name, $properties );
		}
	}

	/**
	 * Filters the theme block patterns.
	 *
	 * @since Cosmetics Shop 1.0
	 *
	 * @param array $block_patterns List of block patterns by name.
	 */
	$patterns = apply_filters( 'cosmetics_shop_block_patterns', $patterns );

	foreach ( $patterns as $block_pattern => $pattern ) {
		$pattern['content'] = cosmetics_shop_get_pattern_content( $block_pattern );
		register_block_pattern(
			'cosmetics-shop/' . $block_pattern,
			$pattern
		);
	}
}
add_action( 'init', 'cosmetics_shop_register_block_patterns', 9 );
