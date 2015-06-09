<div class="container">
    <section class="mini-layout">
        <div class="frame_title clearfix">
            <div class="pull-left">
                <span class="help-inline"></span>
                <span class="title">xForm / Добавить поле в форму <b>{echo $CI->load->model('xform_m')->get_form_name($fid)}</b></span>
            </div>
            <div class="pull-right">
                <div class="d-i_b">
                    <a href="/admin/components/cp/xform/fields/{$fid}" class="t-d_n m-r_15"><span class="f-s_14">←</span> <span class="t-d_u">Вернуться</span></a>
                    <button type="button" class="btn btn-small btn-primary formSubmit" data-form="#save" data-submit><i class="icon-ok icon-white"></i>{if $field}Сохранить поле{else:}Добавить поле{/if}</button>
                </div>
            </div>                            
        </div>               
        <div class="tab-content">

            <div class="tab-pane active" id="xform">
                <table class="table table-striped table-bordered table-hover table-condensed">
                    <thead>
                        <tr>
                            <th colspan="6">
                                Параметры
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="6">
                                <div class="inside_padd span9">
                                    <div class="form-horizontal">
                                        <form id="save" method="post" action="{site_url('/admin/components/cp/xform/mix_field')}/{$fid}/{$field.id}">
                                            <div class="control-group">
                                                <label class="control-label" for="type">Тип: </label>
                                                <div class="controls">
                                                    <select name="type" id="type">
                                                        <option value="text"{if $field.type=='text'} selected="selected"{/if}>text</option>
                                                        <option value="textarea"{if $field.type=='textarea'} selected="selected"{/if}>textarea</option>
                                                        <option value="checkbox"{if $field.type=='checkbox'} selected="selected"{/if}>checkbox</option>
                                                        <option value="select"{if $field.type=='select'} selected="selected"{/if}>select</option>
                                                        <option value="radio"{if $field.type=='radio'} selected="selected"{/if}>radio</option>
                                                        <option value="file"{if $field.type=='file'} selected="selected"{/if}>file</option>
                                                    </select>
                                                    <span class="help-block">Тип поля</span>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="name">
                                                    Имя:
                                                </label>
                                                <div class="controls">
                                                    <div class="o_h">
                                                        <input type="text" name="name" id="name" value="{$field.label}">
                                                    </div>
                                                    <div class="help-block">Имя поля</div>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="value">
                                                    Значение
                                                </label>
                                                <div class="controls">
                                                    <textarea name="value" id="value">{$field.value}</textarea>
                                                    <span class="help-block">Аттрибут value, для checkbox, select, radio каждое новое значение указывайте в новой строке. </span>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="desc">
                                                    Описание
                                                </label>
                                                <div class="controls">
                                                    <textarea name="desc" id="desc">{$field.desc}</textarea>
                                                    <span class="help-block">Подсказка для поля</span>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <div class="control-label">
                                                    Операции и стили
                                                </div>
                                                <div class="controls">
                                                    <textarea id="oper" name="oper" rows="10" cols="180" >{$field.operation}</textarea>
                                                    <span class="help-block">Возможность добавить к полю новые аттрибуты, классы, стили, события.</span>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="position">
                                                    Позиция:
                                                </label>
                                                <div class="controls">
                                                    <div class="o_h">
                                                        <input type="text" name="position" id="position" value="{if $field.position!==0}{$field.position}{else:}0{/if}">
                                                    </div>
                                                    <div class="help-block">Позиция поля</div>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="max">
                                                    Максимум символов:
                                                </label>
                                                <div class="controls">
                                                    <div class="o_h">
                                                        <input type="text" name="max" id="max" value="{$field.maxlength}">
                                                    </div>
                                                    <div class="help-block">Максимальное количество символов</div>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <div class="control-label"></div>
                                                <div class="controls">
                                                    <span class="frame_label no_connection">
                                                        <span class="niceCheck" style="background-position: -46px 0px;">
                                                            <input type="checkbox" name="check" value="1" {if $field.checked==1} checked="checked"{/if}>
                                                        </span>
                                                        Отмеченный чекбокс</span>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <div class="control-label"></div>
                                                <div class="controls">
                                                    <span class="frame_label no_connection">
                                                        <span class="niceCheck" style="background-position: -46px 0px;">
                                                            <input type="checkbox" name="disable" value="1" {if $field.disabled==1} checked="checked"{/if}>
                                                        </span>
                                                        Отключённое поле</span>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <div class="control-label"></div>
                                                <div class="controls">
                                                    <span class="frame_label no_connection">
                                                        <span class="niceCheck" style="background-position: -46px 0px;">
                                                            <input type="checkbox" name="required" value="1" {if $field.require==1} checked="checked"{/if}>
                                                        </span>
                                                        Обязательно для заполнения</span>
                                                </div>
                                            </div>

                                            {form_csrf()}
                                        </form>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</div>