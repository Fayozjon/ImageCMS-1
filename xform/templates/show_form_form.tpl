<section class="mini-layout">
    <div class="frame_title clearfix">
        <div class="pull-left">
            <span class="help-inline"></span>
            <span class="title">Настройки виджета <b>{$widget.name}</b></span>
        </div>
        <div class="pull-right">
            <div class="d-i_b">
                <a href="{$BASE_URL}admin/widgets_manager/index" class="t-d_n m-r_15 pjax"><span class="f-s_14">←</span> <span class="t-d_u">Вернуться</span></a>
                <button type="button" class="btn btn-small formSubmit" data-form="#widget_form"><i class="icon-ok"></i>Сохранить</button>
                <button type="button" class="btn btn-small formSubmit" data-form="#widget_form" data-action="tomain"><i class="icon-edit"></i>Сохранить и выйти</button>
            </div>
        </div>                            
    </div>
    <div class="tab-content">
        <div class="row-fluid">
            <form action="{$BASE_URL}admin/widgets_manager/update_widget/{$widget.id}" id="widget_form" method="post" class="form-horizontal">
                <table class="table table-striped table-bordered table-hover table-condensed content_big_td">
                    <thead>
                    <th>Настройки</th>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <div class="inside_padd">
                                    <div class="row-fluid">
                                        <div class="control-group">
                                            <label class="control-label" for="symcount">Выбирите форму:</label>
                                            <div class="controls">
                                                <select name="form_id" id="form_id">
                                                    {foreach $forms as $form}
                                                        <option value="{$form.id}"{if $widget.settings.form_id==$form.id} selected="selected"{/if}>{$form.title}</option>
                                                    {/foreach}
                                                </select>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                                <div class="control-label"></div>
                                                <div class="controls">
                                                    <span class="frame_label no_connection">
                                                        <span class="niceCheck" style="background-position: -46px 0px;">
                                                            <input type="checkbox" name="ajax" value="1" {if $widget.settings.ajax==1} checked="checked"{/if}>
                                                        </span>
                                                        Использовать AJAX (файлы не передаются)</span>
                                                </div>
                                            </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                {form_csrf()}
            </form>
        </div>
    </div>
</section>