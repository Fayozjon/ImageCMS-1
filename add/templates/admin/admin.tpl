<section class="mini-layout">
    <div class="frame_title clearfix">
        <div class="pull-left">
            <span class="help-inline"></span>
            <span class="title">Add - Мастер создания страниц</span>
        </div>
        <div class="pull-right">
            <div class="d-i_b">
                <a href="/admin/components/cp/add/config/add" class="btn btn-small pjax btn-success"><i class="icon-plus-sign icon-white"></i>Создать мастера</a>
                <a href="/admin/components/cp/add/about" class="btn btn-small pjax btn-info"><i class="icon-book icon-white"></i>Документация</a>
            </div>
        </div>
    </div>
    {if $add}
        <table id="cats_table" class="table table-striped table-bordered table-hover table-condensed content_big_td">
            <thead>
            <th width="50">ID</th>
            <th>Наименование</th>
            <th width="100">Действие</th>
            </thead>
            <tbody>
                {foreach $add as $item}
                    <tr>
                        <td>{$item.id}</td>
                        <td class="share_alt">
                            <a class="pjax" href="/admin/components/cp/add/config/edit/{$item.id}" data-rel="tooltip" data-placement="top" data-original-title="Редактировать">{$item.name}</a>
                        </td>
                        <td>
                            <a href="{site_url('add/step')}/{$item.id}" target="_blank"  data-rel="tooltip" data-placement="top" data-original-title="Посмотреть на сайте" class="btn btn-info btn-small my_btn_s"><i class="icon-eye-open"></i></a>
                            <button onclick="Add.deleteMaster({$item.id});" class="btn btn-small btn-danger my_btn_s" data-rel="tooltip" data-title="Удалить мастера"> <i class="icon-trash icon-white"></i></button>
                        </td>
                        
                    </tr>
                {/foreach}
            </tbody>
        </table>
    {else:}
        <div class="alert alert-info m-t_20">
            <p>Мастера добавления страниц, ещё не создано.</p>
        </div>
    {/if}
</section>
    
    <div class="modal hide fade">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3>Удалить мастера</h3>
        </div>
        <div class="modal-footer">
            <a href="#" class="btn" onclick="$('.modal').modal('hide');">Отмена</a>
            <a href="#" class="btn btn-primary" onClick="Add.deleteMasterConfirm();">Удалить</a>
        </div>
    </div>
    
{literal}
    <script>
        var Add = new Object({
        deleteMaster: function(id) {
            $('.modal').modal();
            Add.id = id;
        },
        deleteMasterConfirm: function()
        {
            $.post('/admin/components/cp/add/config/delete/', {
                id: Add.id
            }, function(data) {
                $('#mainContent').after(data);
                    $.pjax({
                        url: window.location.pathname,
                        container: '#mainContent',
                        timeout: 1000
                    });
                    showMessage('Готово','Мастер успешно удалён');
                });
            $('.modal').modal('hide');
            return false;
        }
    });       
    </script>
{/literal}