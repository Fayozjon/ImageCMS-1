<section class="mini-layout">
    <div class="frame_title clearfix">
        <div class="pull-left">
            <span class="help-inline"></span>
            <span class="title">xForm / Список полей, формы <b>{$form_name}</b></span>
        </div>
        <div class="pull-right">
            <div class="d-i_b">
                <a href="/admin/components/cp/xform/" class="t-d_n m-r_15"><span class="f-s_14">←</span> <span class="t-d_u">Вернуться</span></a>
                <button class="btn btn-small btn-danger disabled action_on" id="del_in_search" onclick="$('.modal').modal();" disabled="disabled"><i class="icon-trash icon-white"></i>Удалить</button>
                <a href="/admin/components/cp/xform/mix_field/{$form_id}/new" class="btn btn-small pjax btn-success"><i class="icon-plus-sign icon-white"></i>Создать поле</a>
            </div>
        </div>
    </div> 
    {if $fields}
        <table id="cats_table" class="table table-striped table-bordered table-hover table-condensed content_big_td">
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
            <th>Имя</th>
            <th>Лейбл</th>
            </thead>
            <tbody class="sortable save_positions" data-url="/admin/components/cp/xform/update_positions">
                {foreach $fields as $field}
                    <tr>
                        <td class="t-a_c">
                            <span class="frame_label">
                                <span class="niceCheck">
                                    <input type="checkbox" name="ids" value="{$field.id}">
                                </span>
                            </span>
                        </td>
                        <td>{$field.id}</td>
                        <td>
                            {$field.type}
                        </td>
                        <td class="share_alt">
                            <a class="pjax" href="/admin/components/cp/xform/mix_field/{$form_id}/{$field.id}" data-rel="tooltip" data-placement="top" data-original-title="Редактировать поле">{$field.name}</a>
                        </td>
                        <td>{$field.label}</td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    {else:}
        <div class="alert alert-info m-t_20">
            В форме нет полей.
        </div>
    {/if}
</section>

<div class="modal hide fade products_delete_dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Удалить поля</h3>
    </div>
    <div class="modal-footer">
        <a href="" class="btn" onclick="$('.modal').modal('hide');">Отмена</a>
        <a href="" class="btn btn-primary" onclick="xForm.deleteFieldsConfirm();$('.modal').modal('hide');">{lang('a_delete')}</a>
    </div>
</div>
        {literal}
            <script>
            var xForm = new Object({
                deleteFieldsConfirm:function(){
                    var ids = new Array();
                $('input[name=ids]:checked').each(function() {
                    ids.push($(this).val());
                });
                $.post('/admin/components/cp/xform/delete_fields', {
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