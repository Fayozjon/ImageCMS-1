<div class="container">
    <section class="mini-layout">
        <div class="frame_title clearfix">
            <div class="pull-left">
                <span class="help-inline"></span>
                <span class="title">Click / {if $link}Редактировать{else:}Добавить{/if} ссылку</span>
            </div>
            <div class="pull-right">
                <div class="d-i_b">
                    <a href="/admin/components/cp/click/" class="t-d_n m-r_15"><span class="f-s_14">←</span> <span class="t-d_u">Вернуться</span></a>
                    <button type="button" class="btn btn-small btn-primary formSubmit" data-form="#save" data-submit><i class="icon-ok icon-white"></i>{if $link}Сохранить{else:}Создать{/if}</button>
                </div>
            </div>                            
        </div>               
        <div class="tab-content">

            <div class="tab-pane active" id="xform">
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
                                <div class="inside_padd span9">
                                    <div class="form-horizontal">
                                        <form id="save" method="post" action="{site_url('/admin/components/cp/click/links')}/{if $link.id}{$link.id}{else:}new{/if}">
                                            <div class="control-group">
                                                <label class="control-label" for="type">Тип: </label>
                                                <div class="controls">
                                                    <select name="type" id="type">
                                                        <option value="link"{if $link.type=='link'} selected="selected"{/if}>Ссылка</option>
                                                        <option value="banner"{if $link.type=='banner'} selected="selected"{/if}>Баннер</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="title">
                                                    Заголовок:
                                                </label>
                                                <div class="controls">
                                                    <div class="o_h">
                                                        <input type="text" name="title" value="{$link.title}">
                                                    </div>
                                                    <div class="help-block">title для img, либо заголовок ссылки</div>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="category">
                                                    Категория
                                                </label>
                                                <div class="controls">
                                                    <input type="text" name="category" value="{$link.category}">
                                                    <span class="help-block">Для идентификации списка баннеров</span>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="image">
                                                    Изображение
                                                </label>
                                                <div class="controls">
                                                    <div class="group_icon pull-right">            
                                                        <button class="btn btn-small" onclick="elFinderPopup('image', 'image');
                                                                return false;"><i class="icon-picture"></i>  Выбрать Изображение</button>
                                                    </div>
                                                    <div class="o_h">		            
                                                        <input type="text" name="image" id="image" value="{$link.image}">
                                                    </div>
                                                    <span class="help-block"></span>
                                                </div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="link">
                                                    Ссылка
                                                </label>
                                                <div class="controls">
                                                    <div class="group_icon pull-right">
                                                        <button class="btn btn-small" onclick="elFinderPopup('file', 'link');
                                                                return false;"> <i class="icon-folder-open"></i> Выберите файл</button>
                                                    </div>

                                                    <div class="o_h">		            
                                                        <input type="text" name="link" id="link" value="{$link.link}">					</div>

                                                    <span class="help-block">Выбирите файл из списка, либо укажите абсолютный адрес</span>
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
