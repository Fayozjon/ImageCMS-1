<section class="mini-layout">
    <div class="frame_title clearfix">
        <div class="pull-left">
            <span class="help-inline"></span>
            <span class="title">xForm - Конструктор форм для ImageCMS</span>
        </div>
        <div class="pull-right">
            <div class="d-i_b">
                <a href="/admin/components/cp/xform/create_form" class="btn btn-small pjax btn-success"><i class="icon-plus-sign icon-white"></i>Создать форму</a>
				<a href="/admin/components/cp/xform/msg" class="btn btn-small pjax btn-success"><i class="icon-envelope icon-white"></i>Сообщения</a>
            </div>
        </div>
    </div>
    {if $forms}
        <table id="cats_table" class="table table-striped table-bordered table-hover table-condensed content_big_td">
            <thead>
            <th>ID</th>
            <th>Наименование</th>
            <th>URL</th>
            <th>Тема</th>
            <th>E-mail</th>
            <th>Действия</th>
            </thead>
            <tbody>
                {foreach $forms as $form}
                    <tr>
                        <td>{$form.id}</td>
                        <td class="share_alt">
                            <a class="pjax" href="/admin/components/cp/xform/fields/{$form.id}" data-rel="tooltip" data-placement="top" data-original-title="Редактировать поля">{$form.title}</a>
                        </td>
                        <td>
                           <a href="{site_url('xform/show')}/{$form.url}" target="_blank"  data-rel="tooltip" data-placement="top" data-original-title="Посмотреть на сайте">{$form.url}</a>
                        </td>
                        <td>{$form.subject}</td>
                        <td>{$form.email}</td>
                        <td>
                            <a class="btn btn-small btn-danger my_btn_s pjax" data-rel="tooltip" data-title="Настройки формы" href="/admin/components/cp/xform/edit_form/{$form.id}" data-original-title="">
                            <i class="icon-wrench icon-white"></i>
                             </a>
                            <button onclick="xForm.deleteForm({$form.id});" class="btn btn-small btn-danger my_btn_s" data-rel="tooltip" data-title="Удалить форму"> <i class="icon-trash icon-white"></i></button>
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    {else:}
        <div class="alert alert-info m-t_20">
            <p>Ещё не создано ни одной формы. <a href="/admin/components/cp/xform/create_form" class="pjax">Создайте</a> форму для начала работы!</p>
        </div>
    {/if}
</section>
    
    <div class="modal delete_form hide fade">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3>Удалить форму</h3>
        </div>
        <div class="modal-footer">
            <a href="#" class="btn" onclick="$('.modal.delete_form').modal('hide');">Отмена</a>
            <a href="#" class="btn btn-primary" onClick="xForm.deleteFormConfirm();">Удалить</a>
        </div>
    </div>
    
{literal}
    <script>
        var xForm = new Object({
        deleteForm: function(id) {
            $('.modal.delete_form').modal();
            xForm.id = id;
        },
        deleteFormConfirm: function()
        {
            $.post('/admin/components/cp/xform/delete_form', {
                id: xForm.id
            }, function(data) {
                $('#mainContent').after(data);
                    $.pjax({
                        url: window.location.pathname,
                        container: '#mainContent',
                        timeout: 1000
                    });
                    showMessage('Готово','Форма успешно удалена');
                });
            $('.modal.delete_form').modal('hide');
            return false;
        }
    });       
    </script>
{/literal}
