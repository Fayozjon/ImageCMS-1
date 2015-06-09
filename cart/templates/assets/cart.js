/*
 * Модуль корзины для ImageCMS
 * Автор: Чуйков Константин
 * www.chuikoff.ru
 */

var Cart = new Object({
    show_cart: function() {
        $.ajax({
            url: '/cart/show_cart',
            type: 'post',
            success: function(data) {
                $('.cart').empty().html(data);
                if (data === 'В корзине <b>0</b> товар на сумму <b></b> рублей') {
                    $('.cart').empty().html('В корзине нет товаров.');
                    $('.form_order,#add_order').hide();
                }
            },
            error: function(data) {
                $('.cart').empty().text('Нет данных');
            }
        });
    },
    add_cart: function(id, title, price, number) {
        $.ajax({
            url: '/cart/add_cart',
            type: 'post',
            data: ({'id': id, 'title': title, 'price': price, 'number': number}),
            success: function(data) {
                Cart.show_cart();
            },
            error: function(data) {
            }
        });
    },
    delete_item: function(id) {
        $.ajax({
            url: '/cart/delete_item',
            type: 'post',
            data: ({'id': id}),
            success: function(data) {
                Cart.show_cart();
            },
            error: function(data) {
            }
        });
    },
    change_number: function(it, id, num) {
        $(it).hide();
        $(it).after('<input type="text" name="number" size="3" value="' + num + '" \/>');
        $(it).next().blur(function()
        {
            $.ajax({
                url: '/cart/change_number',
                data: {'id': id, 'num': $(this).val()},
                type: 'post',
                success: function(data)
                {   
                    Cart.show_cart();
                }
            });
            $(it).html($(this).val()).show();
            var total = parseFloat($(this).val()) * parseFloat($('tr.item_'+id+' td.item_elem_price').text());
            $('tr.item_'+id+' td.item_total_price').text(total);
            $(this).remove();
        });
    },
    cancel_order: function(id) {
        $.ajax({
            url: '/cart/cancel_order',
            type: 'post',
            data: ({'id': id}),
            success: function(data) {
            },
            error: function(data) {
            }
        });
    },
    add_order: function() {
        $('.load').show();
        $.ajax({
            url: '/cart/add_order',
            type: 'post',
            data: $('#add_order').serialize(),
            success: function(data) {
                $('.load').hide();
                $('.results').html(data);
            },
            error: function(data) {
                $('.load').hide();
            }
        });
    }
});