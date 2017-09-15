{extends file="parent:frontend/checkout/cart.tpl"}

{block name="frontend_checkout_actions_confirm"}
    {$smarty.block.parent}
    {if !$sMinimumSurcharge && !$sDispatchNoOrder}
        <div class="button--container right" style="margin-right: 10px">
            <div id="LoginWithAmazon"></div>
            <div class="clear"></div>
            <script>
                window.onAmazonLoginReady = function () {
                    amazon.Login.setClientId("{$payoneAmazonPayConfig->getClientId()}");
                };
                window.onAmazonPaymentsReady = function () {
                    console.log('LoginButton');
                    console.log(Date.now());
                    var authRequest;
                    OffAmazonPayments.Button('LoginWithAmazon', "{$payoneAmazonPayConfig->getSellerId()}", {
                        type: "{$payoneAmazonPayConfig->getButtonType()}",
                        color: "{$payoneAmazonPayConfig->getButtonColor()}",
                        size: 'medium',
                        //language: "{$payoneAmazonPayConfig->getButtonLanguage()}",
                        language: "{$Locale|replace:"_":"-"}",

                        authorization: function () {
                            loginOptions = {
                                scope: 'profile payments:widget payments:shipping_address payments:billing_address',
                                popup: true
                            };
                            authRequest = amazon.Login.authorize(loginOptions, '{url controller='moptPaymentAmazon' action='index'}');
                        },
                        onError: function(error) {
                            alert("The following error occurred: "
                                + error.getErrorCode()
                                + ' - ' + error.getErrorMessage());
                        }
                    });
                }
            </script>
            <script async="async"
                    src='https://static-eu.payments-amazon.com/OffAmazonPayments/de/sandbox/lpa/js/Widgets.js'>
            </script>
        </div>
    {/if}
{/block}

{block name='frontend_checkout_cart_error_messages'}
    <div>
        Im Div
        Amazon clientId: {$payoneAmazonPayConfig->getSellerId()}<BR>
        AmazonLogout:  {$moptAmazonLogout} <BR>
        {if $moptAmazonError}
            {include file="frontend/_includes/messages.tpl" type="error" content="{s name='amazonDeclined ' namespace='frontend/MoptPaymentPayone/errorMessages'}{/s}" bold=false}
        {/if}
    </div>
    {$smarty.block.parent}
{/block}

{block name="frontend_index_header_javascript_jquery"}
    {if $moptAmazonLogout === true}
        <script async="async"
                src='https://static-eu.payments-amazon.com/OffAmazonPayments/de/sandbox/lpa/js/Widgets.js'>
        </script>
        <script>
            window.onAmazonLoginReady = function () {
                amazon.Login.logout();
                amazon.Login.setClientId("{$payoneAmazonPayConfig->getClientId()}");
                console.log(Date.now());
                console.log("Amazon Logout");
            };
            console.log('Reinit Button')

        </script>
    {/if}
    {$smarty.block.parent}
{/block}