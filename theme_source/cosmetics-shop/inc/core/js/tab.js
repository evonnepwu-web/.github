function cosmetics_shop_open_tab(evt, cityName) {
    var cosmetics_shop_i, cosmetics_shop_tabcontent, cosmetics_shop_tablinks;
    cosmetics_shop_tabcontent = document.getElementsByClassName("tabcontent");
    for (cosmetics_shop_i = 0; cosmetics_shop_i < cosmetics_shop_tabcontent.length; cosmetics_shop_i++) {
        cosmetics_shop_tabcontent[cosmetics_shop_i].style.display = "none";
    }
    cosmetics_shop_tablinks = document.getElementsByClassName("tablinks");
    for (cosmetics_shop_i = 0; cosmetics_shop_i < cosmetics_shop_tablinks.length; cosmetics_shop_i++) {
        cosmetics_shop_tablinks[cosmetics_shop_i].className = cosmetics_shop_tablinks[cosmetics_shop_i].className.replace(" active", "");
    }
    document.getElementById(cityName).style.display = "block";
    evt.currentTarget.className += " active";
}

jQuery(document).ready(function () {
    jQuery( ".tab-sec .tablinks" ).first().addClass( "active" );
});