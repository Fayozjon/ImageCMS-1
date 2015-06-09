<div class="frame-inside">
    <div class="container">
        <div class="frame-crumbs">
            {widget('path')}
        </div>
        <div class="clearfix">
            <div class="left">
               <link href="{site_url('application/modules/cart/templates/assets')}/css.css" rel="stylesheet">
<h3 align="center">Заказы</h3>
{if count($order)==0}
    <b>Нет заказов</b>
{else:}
    {foreach $order as $zakaz}
        <div class="order">
            <div class="data_order">
                <div>{$zakaz.list_item}</div><br>
                <div>{$zakaz.user_info}</div>
            </div>
            <div class="info_order">
                <div>ID заказа - <b>{$zakaz.id}</b></div>
                <div>Дата заказа: <br>
                    <b>{date('d.m.Y - H:m',$zakaz.date)}</b>
                </div>
                    <div>Статус заказа: <br>
                        <b class="status_order">{$zakaz.status}</b> <br>
                        <a style="cursor:pointer" onclick="Cart.cancel_order('{$zakaz.id}');
                    $(this).parent().find('b').text('Отменён');
                    $(this).hide();">{if $zakaz.status=='Отменён'}{else:}Отменён{/if}</a>
                   </div>
            </div>
        </div>
    {/foreach}
{/if}
<br />
<h3 align="center">Корзина</h3>
{if $cnt == 0}
    <b>Нет товаров</b>
{else:}
    <table class="itemcart">
        <thead>
        <th>ID</th>
        <th>Наименование</th>
        <th>Количество</th>
        <th>Цена</th>
        <th>Всего</th>
        <th></th>
    </thead>
    <tbody valign="top" align="center">
        {foreach $items as $item}
            {switch $format}
            {case "1"}{$item.price = number_format($item.price);break;}
            {case "2"}{$item.price = number_format($item.price,2,',',' ');break;}
            {case "3"}{$item.price = str_replace(',',' ',number_format($item.price,0));break;}
            {/switch}
            <tr class="item_{$item.id}">
                <td>{$item.item_id}</td>
                <td>{$item.item_title}</td>
                <td>
                    <span class="number" title="Изменить" onclick="Cart.change_number(this,{$item.id},$(this).text());">{$item.number}</span>
                </td>
                <td class="item_elem_price">{$item.price}</td>
                <td class="item_total_price">{bcmul(number_format($item.price),$item.number,2)}</td>
                <td><a style="cursor:pointer" onclick="Cart.delete_item('{$item.id}');$('.item_{$item.id}').empty();">
                        Удалить</a>
                </td>
            </tr>
        {/foreach}
    </tbody>
</table><br>
<div class="cart" style="float:right; margin-right:10px;">В корзине <b>{$cnt}</b> {$slovo} на сумму <b>{$total}</b> RUB.</div>
<p style="text-align:left;">
    <a class="form_order" onclick="$('#add_order').toggle('normal');
                    $(this).text('Заполните внимательно все поля!');">Оформить заказ</a>
</p>
<div class="load"><img src="{site_url('application/modules/cart/templates/assets')}/ajax_div.gif"></div>
<div class="results"></div>
<form action="{site_url('cart/add_order')}" method="post" id="add_order" onsubmit="Cart.add_order();
                    return false;">
    <div class="textbox">
        <input type="text" id="name" name="name" class="text" value="{if $_POST.name}{$_POST.name}{else:}ФИО{/if}" onfocus="if (this.value == 'ФИО')
                        this.value = '';" onblur="if (this.value == '')
                        this.value = 'ФИО';"/>
        <p class="lite">Контактное лицо</p>
    </div>

    <div class="textbox">
        <input type="text" id="area" name="area" class="text" value="{if $_POST.area}{$_POST.area}{else:}Край, область, город{/if}" onfocus="if (this.value == 'Край, область, город')
                        this.value = '';" onblur="if (this.value == '')
                        this.value = 'Край, область, город';"/>
        <p class="lite">Например: Камчатский край, г.Елизово</p>
    </div>

    <div class="textbox">
        <input type="text" id="index" name="index" class="text" value="{if $_POST.index}{$_POST.index}{else:}Индекс{/if}" onfocus="if (this.value == 'Индекс')
                        this.value = '';" onblur="if (this.value == '')
                        this.value = 'Индекс';"/>
        <p class="lite">683000</p>
    </div>

    <div class="textbox">
        <input type="text" id="home" name="home" class="text" value="{if $_POST.home}{$_POST.home}{else:}Домашний адрес{/if}" onfocus="if (this.value == 'Домашний адрес')
                        this.value = '';" onblur="if (this.value == '')
                        this.value = 'Домашний адрес';"/>
        <p class="lite">Например: ул. 50 лет Октября 2/2 кв.22</p>
    </div>

    <div class="textbox">
        <input type="text" id="phone" name="phone" class="text" value="{if $_POST.phone}{$_POST.phone}{else:}Телефоны{/if}" onfocus="if (this.value == 'Телефоны')
                        this.value = '';" onblur="if (this.value == '')
                        this.value = 'Телефоны';"/>
        <p class="lite">Сотовый или домашний для мгновенной связи</p>
    </div>

    <div class="textbox">
        <input type="text" id="email" name="email" class="text" value="{if $_POST.email}{$_POST.email}{else:}E-mail{/if}" onfocus="if (this.value == 'E-mail')
                        this.value = '';" onblur="if (this.value == '')
                        this.value = 'E-mail;"/>
        <p class="lite">На него придёт уведомление о заказе</p>
    </div>

    <div class="textbox">
        <textarea cols="40" rows="5" name="comment" id="comment" onfocus="if (this.value == 'Комментарий')
                        this.value = '';" onblur="if (this.value == '')
                        this.value = 'Комментарий';">{if $_POST.comment}{$_POST.comment}{else:}Комментарий{/if}</textarea>
    </div>
    <input type="submit" class="btn submit" onclick="Cart.add_order();
                    return false;" value="Оформить заказ" />
    {form_csrf()}
</form>
{/if}
            </div>
            <div class="right">
                {widget('product_all')}
            </div>
        </div>
    </div>    
</div>