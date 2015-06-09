<section class="mini-layout">
    <div class="frame_title clearfix">
        <div class="pull-left">
            <span class="help-inline"></span>
            <span class="title">Click / Список ссылок</span>
        </div>
        <div class="pull-right">
            <div class="d-i_b">
                <button class="btn btn-small btn-danger disabled action_on" id="del_in_search" onclick="$('.modal').modal();" disabled="disabled"><i class="icon-trash icon-white"></i>Удалить</button>
                <a href="/admin/components/cp/click/links/new" class="btn btn-small pjax btn-success"><i class="icon-plus-sign icon-white"></i>Создать ссылку</a>
                <a href="/admin/components/cp/click/about" class="btn btn-small pjax btn-info"><i class="icon-book icon-white"></i>Документация</a>
            </div>
        </div>
    </div> 
    {if $links}
        <table class="table table-bordered table-condensed content_big_td">
            <thead>
            <th class="t-a_c span1">
                <span class="frame_label">
                    <span class="niceCheck">
                        <input type="checkbox">
                    </span>
                </span>
            </th>
            <th width="50">ID</th>
            <th width="100">Тип</th>
            <th>Заголовок</th>
            <th>Категория</th>
            <th>Изображение</th>
            <th>Ссылка</th>
            <th>Кол-во кликов</th>
            <th>Редактировать</th>
            </thead>
            <tbody>
                {foreach $links as $link}
                    <tr>
                        <td class="t-a_c">
                            <span class="frame_label">
                                <span class="niceCheck">
                                    <input type="checkbox" name="ids" value="{$link.id}">
                                </span>
                            </span>
                        </td>
                        <td>{$link.id}</td>
                        <td>{$link.type}</td>
                        <td>{$link.title}</td>
                        <td>{$link.category}</td>
                        <td>{$link.image}</td>
                        <td>{$link.link}</td>
                        <td>{$link.count}</td>
                        <td><a class="btn btn-small btn-danger my_btn_s pjax" data-rel="tooltip" data-title="Редактировать" href="/admin/components/cp/click/links/{$link.id}" data-original-title=""><i class="icon-wrench icon-white"></i></a>
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    {else:}
        <div class="alert alert-info m-t_20">
            Ни одной ссылки, ещё не создано.
        </div>
    {/if}
</section>

<div class="modal hide fade products_delete_dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Удалить ссылки</h3>
    </div>
    <div class="modal-footer">
        <a href="#" class="btn" onclick="$('.modal').modal('hide');">Отмена</a>
        <a href="#" class="btn btn-primary" onclick="Click.deleteFieldsConfirm();$('.modal').modal('hide');">Удалить</a>
    </div>
</div>
        {literal}
            <script>
            var Click = new Object({
                deleteFieldsConfirm:function(){
                    var ids = new Array();
                $('input[name=ids]:checked').each(function() {
                    ids.push($(this).val());
                });
                $.post('/admin/components/cp/click/delete_link', {
                    id: ids
                }, function(data) {
                    $('#mainContent').after(data);
                    $.pjax({
                        url: window.location.pathname,
                        container: '#mainContent',
                        timeout: 3000
                    });
                });
                $('.modal').modal('hide');
                return false;
                }
            });
            </script>
        {/literal}