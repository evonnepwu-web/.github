// Product Slider
jQuery(document).ready(function() {
  jQuery('.slider-section .owl-carousel').owlCarousel({
    loop: true,
    margin: 15,
    nav: false,
    dots: true,
    rtl: false,
    items: 1,
    autoplay: true,
  });
});

// Testimonial Section
jQuery(document).ready(function() {
  jQuery('.testimonial-section .owl-carousel').owlCarousel({
    loop: true,
    margin: 15,
    nav: true,
    navText: ["<span class='left-btn p-3'></span>", "<span class='right-btn p-3'></span>"], 
    dots: false,
    rtl: false,
    responsive: {
    0: { 
      items: 1 
    },
    768: { 
      items: 2 
    },
    992: { 
      items: 2 
    },
    1200: { 
      items: 3 
    }
  },
  autoplay: true,
  });
});

// News Section
jQuery(document).ready(function() {
  jQuery('.news-section .owl-carousel').owlCarousel({
    loop: true,
    margin: 15,
    nav: false, 
    dots: false,
    rtl: false,
    responsive: {
    0: { 
      items: 1 
    },
    768: { 
      items: 2 
    },
    992: { 
      items: 2 
    },
    1200: { 
      items: 3 
    }
  },
  autoplay: true,
  });
});

// Scroll to Top
window.onscroll = function() {
  const cosmetics_shop_button = document.querySelector('.scroll-top-box');
  if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
    cosmetics_shop_button.style.display = "block";
  } else {
    cosmetics_shop_button.style.display = "none";
  }
};

document.querySelector('.scroll-top-box a').onclick = function(event) {
  event.preventDefault();
  window.scrollTo({top: 0, behavior: 'smooth'});
};

//  Single Product Link
document.addEventListener("click", function(e) {
  const cosmetics_shop_btn = e.target.closest(".slider-section .slider-products-sec .slider-products-right .slider-btn, .product-section .products-sec-box .product-btn");
  if (!cosmetics_shop_btn) return;

  const cosmetics_shop_productItem = cosmetics_shop_btn.closest("li.product");
  if (!cosmetics_shop_productItem) return;

  const cosmetics_shop_productLink = cosmetics_shop_productItem.querySelector("a[href*='/product/']");
  if (cosmetics_shop_productLink) {
    window.location.href = cosmetics_shop_productLink.getAttribute("href");
  }
});