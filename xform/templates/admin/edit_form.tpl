<div class="container">
    <section class="mini-layout">
        <div class="frame_title clearfix">
            <div class="pull-left">
                <span class="help-inline"></span>
                <span class="title">xForm / Редактировать форму</span>
            </div>
            <div class="pull-right">
                <div class="d-i_b">
                    <a href="/admin/components/cp/xform/" class="t-d_n m-r_15"><span class="f-s_14">←</span> <span class="t-d_u">Венуться</span></a>
                    <button type="button" class="btn btn-small btn-info formSubmit" data-form="#save" data-submit><i class="icon-ok icon-white"></i>Сохранить</button>
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
                                        <form id="save" method="post" action="{site_url('admin/components/cp/xform/edit_form')}/{$form.id}">
                                            <div class="control-group">
                                                <label class="control-label" for="page_title">Название</label>
                                                <div class="controls">
                                                    <input type="text" class="textbox_long" name="page_title" id="page_title_u" value="{$form.title}">
                                                    <span class="help-block">Выводиться в заголовке и title</span>
                                                </div>
                                            </div>
                                            
                                            <div class="control-group">
                                                <label class="control-label" for="page_url">
                                                    URL:
                                                </label>
                                                <div class="controls">
                                                    <button onclick="translite_title('#page_title_u', '#page_url');" type="button" class="btn btn-small pull-right"><i class="icon-refresh"></i>&nbsp;&nbsp;Автоподбор</button>
                                                    <div class="o_h">
                                                        <input type="text" name="page_url" value="{$form.url}" id="page_url">
                                                    </div>
                                                    <div class="help-block">(только латинские символы)</div>
                                                </div>
                                            </div>
                                            
                                            <div class="control-group">
                                                <label class="control-label" for="email">E-mail</label>
                                                <div class="controls">
                                                    <input type="text" class="textbox_long" name="email" id="email" value="{$form.email}" />
                                                    <span class="help-block">E-mail куда приходят сообщения с формы</span>
                                                </div>
                                            </div>
                                            
                                            <div class="control-group">
                                                <label class="control-label" for="subject">Тема</label>
                                                <div class="controls">
                                                    <input type="text" class="textbox_long" name="subject" id="subject" value="{$form.subject}" />
                                                    <span class="help-block">Тема письма</span>
                                                </div>
                                            </div>
                                            
                                            <div class="control-group">
                                                <div class="control-label">
                                                    Описание формы
                                                </div>
                                                <div class="controls">
                                                    <textarea id="desc" class="elRTE" name="desc" rows="10" cols="180">{$form.desc}</textarea>
                                                </div>
                                            </div>
                                            
                                            <div class="control-group">
                                                <div class="control-label">
                                                    Сообщение об успехе
                                                </div>
                                                <div class="controls">
                                                    <textarea id="good" class="elRTE required" name="good" rows="10" cols="180">{$form.success}</textarea>
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