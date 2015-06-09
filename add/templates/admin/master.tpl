<div class="container">
    <section class="mini-layout">
        <div class="frame_title clearfix">
            <div class="pull-left">
                <span class="help-inline"></span>
                <span class="title">Add / {if $conf}Редактировать{else:}Добавить{/if} мастера</span>
            </div>
            <div class="pull-right">
                <div class="d-i_b">
                    <a href="/admin/components/cp/add/" class="t-d_n m-r_15"><span class="f-s_14">←</span> <span class="t-d_u">Вернуться</span></a>
                    <button type="button" class="btn btn-small btn-primary formSubmit" data-form="#save" data-submit><i class="icon-ok icon-white"></i>{if $conf}Сохранить{else:}Создать{/if}</button>
                </div>
            </div>                            
        </div>               
        <div class="tab-content">
        {if $conf}{$conf.data = unserialize($conf.config)}{/if}
        <div class="tab-pane active">
            <table class="table table-striped table-bordered table-condensed">
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
                            <div class="inside_padd span12">
                                <div class="form-horizontal">
                                    <form id="save" method="post" action="{site_url('admin/components/cp/add/master')}/{if $conf}update/{$conf.id}{else:}add{/if}">
                                        <div class="control-group">
                                            <label class="control-label" for="type">Название мастера: </label>
                                            <div class="controls">
                                                <input type="text" name="name" id="name" value="{$conf.name}" />
                                                <div class="help-block">Выводится в заголовке и title, например "Добавить объявление"</div>
                                            </div>
                                        </div>

                                        <div class="control-group">
                                            <label class="control-label" for="category">
                                                Категория
                                            </label>
                                            <div class="controls">
                                                <select name="category">
                                                    <option value="0">{site_url()}</option>
                                                    {foreach $categ as $cat}
                                                        <option value="{$cat.id}"{if $conf.data.category==$cat.id} selected="selected"{/if}>{$cat.id} - {$cat.name}</option>
                                                    {/foreach}
                                                </select>
                                            </div>
                                        </div>

                                        <div class="control-group">
                                            <div class="control-label">
                                                Описание формы
                                            </div>
                                            <div class="controls">
                                                <textarea id="desc" class="elRTE" name="desc">{$conf.desc}</textarea>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <div class="control-label"></div>
                                            <div class="controls">
                                                <span class="frame_label no_connection">
                                                    <span class="niceCheck" style="background-position: -46px 0px;">
                                                        <input type="checkbox" name="cfcm" value="1" {if $conf.data.cfcm==1} checked="checked"{/if}>
                                                    </span>
                                                    Дополнительные поля</span>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <div class="control-label"></div>
                                            <div class="controls">
                                                <span class="frame_label no_connection">
                                                    <span class="niceCheck" style="background-position: -46px 0px;">
                                                        <input type="checkbox" name="status" value="pending"{if $conf.data.status=='pending'} checked="checked"{/if}>
                                                    </span>
                                                    Премодерация</span>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <div class="control-label"></div>
                                            <div class="controls">
                                                <span class="frame_label no_connection">
                                                    <span class="niceCheck" style="background-position: -46px 0px;">
                                                        <input type="checkbox" name="comments" value="1"{if $conf.data.comments==1} checked="checked"{/if} />
                                                    </span>
                                                    Комментарии</span>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <div class="control-label"></div>
                                            <div class="controls">
                                                <span class="frame_label no_connection">
                                                    <span class="niceCheck" style="background-position: -46px 0px;">
                                                        <input type="checkbox" name="guest" value="1"{if $conf.data.guest==1} checked="checked"{/if} />
                                                    </span>
                                                    Доступ для гостей</span>
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

<div id="elFinder"></div>