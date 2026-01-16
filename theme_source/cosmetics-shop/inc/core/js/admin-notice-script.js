jQuery(document).ready(function ($) {
    // Attach click event to the dismiss button
    $(document).on('click', '.welcome-notice button.notice-dismiss', function () {
        // Dismiss the notice via AJAX
        $.ajax({
            type: 'POST',
            url: ajaxurl,
            data: {
                action: 'cosmetics_shop_dismissed_notice',
            },
            success: function () {
                // Remove the notice on success
                $('.notice[data-notice="example"]').remove();
            }
        });
    });
});

// Plugin – AI Content Writer plugin activation
document.addEventListener('DOMContentLoaded', function () {
    const cosmetics_shop_button = document.getElementById('install-activate-button');

    if (!cosmetics_shop_button) return;

    cosmetics_shop_button.addEventListener('click', function (e) {
        e.preventDefault();

        const cosmetics_shop_redirectUrl = cosmetics_shop_button.getAttribute('data-redirect');

        // Step 1: Check if plugin is already active
        const cosmetics_shop_checkData = new FormData();
        cosmetics_shop_checkData.append('action', 'check_plugin_activation');

        fetch(installPluginData.ajaxurl, {
            method: 'POST',
            body: cosmetics_shop_checkData,
        })
        .then(res => res.json())
        .then(res => {
            if (res.success && res.data.active) {
                // Plugin is already active → just redirect
                window.location.href = cosmetics_shop_redirectUrl;
            } else {
                // Not active → proceed with install + activate
                cosmetics_shop_button.textContent = 'Installing & Activating...';

                const cosmetics_shop_installData = new FormData();
                cosmetics_shop_installData.append('action', 'install_and_activate_required_plugin');
                cosmetics_shop_installData.append('_ajax_nonce', installPluginData.nonce);

                fetch(installPluginData.ajaxurl, {
                    method: 'POST',
                    body: cosmetics_shop_installData,
                })
                .then(res => res.json())
                .then(res => {
                    if (res.success) {
                        window.location.href = cosmetics_shop_redirectUrl;
                    } else {
                        alert('Activation error: ' + (res.data?.message || 'Unknown error'));
                        cosmetics_shop_button.textContent = 'Try Again';
                    }
                })
                .catch(error => {
                    alert('Request failed: ' + error.message);
                    cosmetics_shop_button.textContent = 'Try Again';
                });
            }
        })
        .catch(error => {
            alert('Check request failed: ' + error.message);
        });
    });
});
