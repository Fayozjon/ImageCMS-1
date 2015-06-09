<script type="text/javascript" src="{site_url('application/modules/cart/templates/assets')}/cart.js"></script>
<h5>Корзина:</h5>
{if $cnt>0}
<div class="cart">В корзине <b>{$cnt}</b> {$slovo} на сумму <b>{$total}</b> RUB</div>
{else:}
<div class="cart">Добавьте товар в корзину</div>
{/if}
<a class="btn btn-mini" href="{site_url('cart')}" title="Оформить заказ">Оформите заказ</a><br/>