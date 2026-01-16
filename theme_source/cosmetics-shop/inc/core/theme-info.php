<?php
//about theme info

function cosmetics_shop_menu() {
	add_theme_page( esc_html__( 'Cosmetics Shop', 'cosmetics-shop' ), esc_html__( 'Cosmetics Shop Theme', 'cosmetics-shop' ), 'edit_theme_options', 'cosmetics-shop-info', 'cosmetics_shop_theme_page_display' );
}
add_action( 'admin_menu', 'cosmetics_shop_menu' );

// Add a Custom CSS file to WP Admin Area
function cosmetics_shop_admin_theme_style() {
	wp_enqueue_style('cosmetics-shop-custom-admin-style', esc_url(get_template_directory_uri()) . '/css/admin-style.css');
	wp_enqueue_script('cosmetics-shop-tabs', esc_url(get_template_directory_uri()) . '/inc/core/js/tab.js');
}
add_action('admin_enqueue_scripts', 'cosmetics_shop_admin_theme_style');

//guidline for about theme
function cosmetics_shop_theme_page_display() { 
	//custom function about theme customizer
	$cosmetics_shop_return = add_query_arg( array()) ;
	$cosmetics_shop_theme = wp_get_theme( 'cosmetics-shop' );
?>

<div class="wrapper-info">
	<div class="tab-sec">
    	
    	<div class="tab">
			<button class="tablinks" onclick="cosmetics_shop_open_tab(event, 'lite_theme')"><?php esc_html_e( 'Free Setup', 'cosmetics-shop' ); ?></button>
			<button class="tablinks" onclick="cosmetics_shop_open_tab(event, 'theme_pro')"><?php esc_html_e( 'Get Premium', 'cosmetics-shop' ); ?></button>
  			<button class="tablinks" onclick="cosmetics_shop_open_tab(event, 'free_pro')"><?php esc_html_e( 'Free VS Premium', 'cosmetics-shop' ); ?></button>
  			<button class="tablinks" onclick="cosmetics_shop_open_tab(event, 'get_bundle')"><?php esc_html_e( 'WP Theme Bundle', 'cosmetics-shop' ); ?></button>
		</div>

		<?php 
			$cosmetics_shop_plugin_custom_css = '';
			if(class_exists('Ibtana_Visual_Editor_Menu_Class')){
				$cosmetics_shop_plugin_custom_css ='display: block';
			}
		?>

		<div id="lite_theme" class="tabcontent open">
			<div class="lite-theme-tab">
				<h3><?php esc_html_e( 'Lite Theme Information', 'cosmetics-shop' ); ?></h3>
				<hr class="h3hr">
			  	<p><?php esc_html_e('The Cosmetics Shop theme is designed for beauty brands, skincare stores, makeup boutiques, and cosmetic product retailers who want a clean, conversion-focused online presence. With its stylish layout and mobile-responsive structure, this theme lets you create a stunning Cosmetics Shop website that showcases beauty products with clarity and sophistication. Perfect for makeup stores, skincare shops, beauty product retailers, and cosmetic ecommerce stores, this theme combines elegant design with advanced functionality. Its fully customizable homepage allows you to highlight best-selling products, feature new arrivals, and display promotional banners that help boost engagement. The Cosmetics Shop theme also supports WooCommerce, making it simple to manage products, process payments, and run a fully functional beauty and cosmetics online store. Designed with speed and user experience in mind, this theme ensures that your cosmetic product shop loads fast and provides seamless navigation. You can personalize colors, fonts, sections, and layouts with the easy-to-use Customizer. Whether you\'re creating a makeup online store, skincare ecommerce shop, or beauty and wellness storefront, this theme provides the professionalism and flexibility you need. It includes sections for product categories, testimonials, featured collections, brand highlights, and blog posts to help educate customers about different beauty and cosmetic products. With clean code, Gutenberg compatibility, WooCommerce support, and a user-friendly interface, the Cosmetics Shop theme offers everything you need to launch a successful beauty retail website. Bring your brand to life with a visually appealing, feature-rich theme built exclusively for modern cosmetics businesses.','cosmetics-shop'); ?></p>
			  	<div class="col-left-inner">
					<div class="pro-links">
				    	<a href="<?php echo esc_url( admin_url() . 'site-editor.php' ); ?>" target="_blank"><?php esc_html_e('Edit Your Site', 'cosmetics-shop'); ?></a>
						<a href="<?php echo esc_url( home_url() ); ?>" target="_blank"><?php esc_html_e('Visit Your Site', 'cosmetics-shop'); ?></a>
					</div>
					<div class="support-forum-col-section">
						<div class="support-forum-col">
							<h4><?php esc_html_e('Having Trouble, Need Support?', 'cosmetics-shop'); ?></h4>
							<p> <?php esc_html_e('Our dedicated team is well prepared to help you out in case of queries and doubts regarding our theme.', 'cosmetics-shop'); ?></p>
							<div class="info-link">
								<a href="<?php echo esc_url( COSMETICS_SHOP_SUPPORT ); ?>" target="_blank"><?php esc_html_e('Support Forum', 'cosmetics-shop'); ?></a>
							</div>
						</div>
						<div class="support-forum-col">
							<h4><?php esc_html_e('Reviews & Testimonials', 'cosmetics-shop'); ?></h4>
							<p> <?php esc_html_e('All the features and aspects of this WordPress Theme are phenomenal. I\'d recommend this theme to all.', 'cosmetics-shop'); ?>  </p>
							<div class="info-link">
								<a href="<?php echo esc_url( COSMETICS_SHOP_REVIEW ); ?>" target="_blank"><?php esc_html_e('Reviews', 'cosmetics-shop'); ?></a>
							</div>
						</div>
						<div class="support-forum-col">
							<h4><?php esc_html_e('Theme Documentation', 'cosmetics-shop'); ?></h4>
							<p> <?php esc_html_e('If you need any assistance regarding setting up and configuring the Theme, our documentation is there.', 'cosmetics-shop'); ?>  </p>
							<div class="info-link">
								<a href="<?php echo esc_url( COSMETICS_SHOP_FREE_DOC ); ?>" target="_blank"><?php esc_html_e('Free Theme Documentation', 'cosmetics-shop'); ?></a>
							</div>
						</div>
					</div>
			  	</div>
			</div>
		</div>

		<div id="theme_pro" class="tabcontent">		  	
			<div class="pro-info">
				<div class="col-left-pro">
					<h3><?php esc_html_e( 'Premium Theme Information', 'cosmetics-shop' ); ?></h3>
					<hr class="h3hr">
			    	<p><?php esc_html_e('The Cosmetics Shop WordPress Theme is a beautifully designed, highly functional, and performance-driven template crafted specifically for beauty brands, cosmetic stores, skincare shops, and makeup product websites. Built with a clean layout and modern aesthetics, it helps you showcase your beauty products with elegance while ensuring smooth navigation and engaging user experiences. This theme offers responsive design, ensuring your website looks flawless on all devices, whether smartphones, tablets, or desktops. With strategically placed call-to-action sections, customizable homepage blocks, and support for popular page builders, you can create a professional-looking cosmetic website without any technical expertise. The Cosmetics Shop WordPress Theme integrates seamlessly with WooCommerce, enabling you to manage products, display product variations, and offer quick checkout experiences with ease. Optimized for SEO and speed, it boosts your store’s visibility while delivering fast loading times for better conversions. The Cosmetics WordPress Theme is perfect for beauty salons, organic cosmetic brands, online makeup stores, and personal beauty professionals who want to establish their presence with a stylish and high-performing website. Whether you are launching a new brand or upgrading an existing store, this theme gives you everything you need to create a stunning, user-friendly cosmetics website.','cosmetics-shop'); ?></p>
			    	<div class="pro-links">
				    	<a href="<?php echo esc_url( COSMETICS_SHOP_LIVE_DEMO ); ?>" target="_blank" class="demo-btn"><?php esc_html_e('Live Demo', 'cosmetics-shop'); ?></a>
						<a href="<?php echo esc_url( COSMETICS_SHOP_BUY_NOW ); ?>" target="_blank" class="prem-btn"><?php esc_html_e('Buy Premium', 'cosmetics-shop'); ?></a>
						<a href="<?php echo esc_url( COSMETICS_SHOP_PRO_DOC ); ?>" target="_blank" class="doc-btn"><?php esc_html_e('Documentation', 'cosmetics-shop'); ?></a>
					</div>
			    </div>
			    <div class="col-right-pro scroll-image-wrapper">
			    	<img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/premium-image.jpg" alt="" class="pro-img" />		    	
			    </div>
			</div>		    
		</div>

		<div id="free_pro" class="tabcontent">
		  	<div class="featurebox">
			    <h3><?php esc_html_e( 'Theme Features', 'cosmetics-shop' ); ?></h3>
				<hr class="h3hr">
				<div class="table-image">
					<table class="tablebox">
						<thead>
							<tr>
								<th><?php esc_html_e('Features', 'cosmetics-shop'); ?></th>
								<th><?php esc_html_e('Free Themes', 'cosmetics-shop'); ?></th>
								<th><?php esc_html_e('Premium Themes', 'cosmetics-shop'); ?></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><?php esc_html_e('Easy Setup', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Responsive Design', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('SEO Friendly', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Banner Settings', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Template Pages', 'cosmetics-shop'); ?></td>
								<td class="table-img"><?php esc_html_e('1', 'cosmetics-shop'); ?></td>
								<td class="table-img"><?php esc_html_e('14', 'cosmetics-shop'); ?></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Home Page Template', 'cosmetics-shop'); ?></td>
								<td class="table-img"><?php esc_html_e('1', 'cosmetics-shop'); ?></td>
								<td class="table-img"><?php esc_html_e('1', 'cosmetics-shop'); ?></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Theme sections', 'cosmetics-shop'); ?></td>
								<td class="table-img"><?php esc_html_e('2', 'cosmetics-shop'); ?></td>
								<td class="table-img"><?php esc_html_e('12', 'cosmetics-shop'); ?></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Contact us Page Template', 'cosmetics-shop'); ?></td>
								<td class="table-img">0</td>
								<td class="table-img"><?php esc_html_e('1', 'cosmetics-shop'); ?></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Blog Templates & Layout', 'cosmetics-shop'); ?></td>
								<td class="table-img">0</td>
								<td class="table-img"><?php esc_html_e('3(Full width/Left/Right Sidebar)', 'cosmetics-shop'); ?></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Section Reordering', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Demo Importer', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Full Documentation', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Latest WordPress Compatibility', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Support 3rd Party Plugins', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Secure and Optimized Code', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Exclusive Functionalities', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Section Enable / Disable', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Section Google Font Choices', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Gallery', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Simple & Mega Menu Option', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Support to add custom CSS / JS ', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Shortcodes', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Custom Background, Colors, Header, Logo & Menu', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Premium Membership', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Budget Friendly Value', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Priority Error Fixing', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Custom Feature Addition', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('All Access Theme Pass', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Seamless Customer Support', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('WordPress 6.4 or later', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('PHP 8.2 or 8.3', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('MySQL 5.6 (or greater) | MariaDB 10.0 (or greater)', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Influence Registration', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr class="odd">
								<td><?php esc_html_e('Detailed Influencer Portfolio', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
								<td><?php esc_html_e('Premium Pricing Plan', 'cosmetics-shop'); ?></td>
								<td class="table-img"><span class="dashicons dashicons-no"></span></td>
								<td class="table-img"><span class="dashicons dashicons-saved"></span></td>
							</tr>
							<tr>
							<td></td>
							<td class="table-img"></td>
							<td class="update-link"><a href="<?php echo esc_url( COSMETICS_SHOP_BUY_NOW ); ?>" target="_blank"><?php esc_html_e('Upgrade to Pro', 'cosmetics-shop'); ?></a></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<div id="get_bundle" class="tabcontent">	
			<div class="bundle-info">
				<div class="col-left-pro">
			   		<h3><?php esc_html_e( 'WP Theme Bundle', 'cosmetics-shop' ); ?></h3>
			   		<hr class="h3hr">
			    	<p><?php esc_html_e('Enhance your website effortlessly with our WP Theme Bundle. Get access to 400+ premium WordPress themes and 5+ powerful plugins, all designed to meet diverse business needs. Enjoy seamless integration with any plugins, ultimate customization flexibility, and regular updates to keep your site current and secure. Plus, benefit from our dedicated customer support, ensuring a smooth and professional web experience.','cosmetics-shop'); ?></p>
			    	<div class="feature">
			    		<h4><?php esc_html_e( 'Features:', 'cosmetics-shop' ); ?></h4>
			    		<p><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/tick.png" alt="" /><?php esc_html_e('400+ Premium Themes & 5+ Plugins.', 'cosmetics-shop'); ?></p>
			    		<p><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/tick.png" alt="" /><?php esc_html_e('Seamless Integration.', 'cosmetics-shop'); ?></p>
			    		<p><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/tick.png" alt="" /><?php esc_html_e('Customization Flexibility.', 'cosmetics-shop'); ?></p>
			    		<p><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/tick.png" alt="" /><?php esc_html_e('Regular Updates.', 'cosmetics-shop'); ?></p>
			    		<p><img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/tick.png" alt="" /><?php esc_html_e('Dedicated Support.', 'cosmetics-shop'); ?></p>
			    	</div>
			    	<p><?php esc_html_e('Upgrade now and give your website the professional edge it deserves, all at an unbeatable price of $99!', 'cosmetics-shop'); ?></p>
			    	<div class="pro-links">
						<a href="<?php echo esc_url( COSMETICS_SHOP_THEME_BUNDLE_BUY_NOW ); ?>" target="_blank" class="bundle-buy"><?php esc_html_e('Get Bundle', 'cosmetics-shop'); ?></a>
						<a href="<?php echo esc_url( COSMETICS_SHOP_THEME_BUNDLE_DOC ); ?>" target="_blank" class="bundle-doc"><?php esc_html_e('Documentation', 'cosmetics-shop'); ?></a>
					</div>
			   	</div>
			   	<div class="col-right-pro scroll-image-wrapper">
			    	<img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/bundle.jpg" alt="" />
			   	</div>
			</div>	  	
		</div>
	</div>
	<div class="coupen-code-section">
		<div class="sshot-section">
			<div class="sshot-inner">
				<h2><?php esc_html_e( 'Welcome To Cosmetics Shop', 'cosmetics-shop' ); ?> <span class="version"><?php esc_html_e( 'Version', 'cosmetics-shop' ); ?>: <?php echo esc_html($cosmetics_shop_theme['Version']);?></span></h2>
		    	<p><?php esc_html_e('All Our Wordpress Themes Are Modern, Minimalist, 100% Responsive, Seo-Friendly,Feature-Rich, And Multipurpose That Best Suit Designers, Bloggers And Other Professionals Who Are Working In The Creative Fields.','cosmetics-shop'); ?></p>
		    	<div class="btn-section">
			    	<div class="pro-links">
				    	<a href="<?php echo esc_url( COSMETICS_SHOP_LIVE_DEMO ); ?>" target="_blank" class="demo-btn"><?php esc_html_e('Live Demo', 'cosmetics-shop'); ?></a>
						<a href="<?php echo esc_url( COSMETICS_SHOP_BUY_NOW ); ?>" target="_blank" class="prem-btn"><?php esc_html_e('Buy Premium', 'cosmetics-shop'); ?></a>
						<a href="<?php echo esc_url( COSMETICS_SHOP_PRO_DOC ); ?>" target="_blank" class="doc-btn"><?php esc_html_e('Documentation', 'cosmetics-shop'); ?></a>
						
					</div>
			    	
			    </div>
			</div>
	    	<div class="bundle-banner">
	    		<div class="bundle-img">
	    			<img src="<?php echo esc_url(get_template_directory_uri()); ?>/images/bundle-notice.png" alt="" />
	    		</div>
	    		<div class="bundle-text">
		  			<h2><?php esc_html_e('WP THEME BUNDLE','cosmetics-shop'); ?></h2>
					<h4><?php esc_html_e('Get Access to 400+ Premium WordPress Themes At Just $99','cosmetics-shop'); ?></h4>
					<div class="bundle-button">
			  			<a href="<?php echo esc_url( 'https://www.vwthemes.com/discount/FREEBREF?redirect=/products/wp-theme-bundle'); ?>" target="_blank"><?php esc_html_e('Get 10% OFF On Bundle', 'cosmetics-shop'); ?></a>
			  		</div>
		  		</div>
	    	</div>
	    </div>
	    <div class="coupen-section">
	    	<div class="logo-section">
			  	<img src="<?php echo esc_url(get_template_directory_uri()); ?>/screenshot.png" alt="" />
		  	</div>
		  	<div class="logo-right">	
		  		<div class="logo-text">
		  			<h2><?php esc_html_e('GET PRO','cosmetics-shop'); ?></h2>
					<h4><?php esc_html_e('20% Off','cosmetics-shop'); ?></h4>
		  		</div>						
			</div>
	    </div>
	</div>
</div>

<?php } ?>