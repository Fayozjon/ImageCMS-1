<div class="container">
    <section class="mini-layout">
        <div class="frame_title clearfix">
            <div class="pull-left">
                <span class="help-inline"></span>
                <span class="title">Настройки модуля</span>
            </div>
            <div class="pull-right">
                <div class="d-i_b">
                    <button type="button" class="btn btn-small btn-info formSubmit" data-form="#save" data-submit><i class="icon-ok icon-white"></i>Сохранить настройки</button>
            </div>
        </div>                            
    </div>               
    <div class="tab-content">

        <div class="tab-pane active">
            <table class="table table-striped table-bordered table-hover table-condensed">
                <thead>
                    <tr>
                        <th colspan="6">
                            Выбирите стиль отображения
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="6">
                            <div class="inside_padd span9">
                                <div class="form-horizontal">
                                    <form id="save" method="post" action="{site_url('admin/components/cp/rating/settings/update')}">
                                        <div class="control-group">
                                            <label class="control-label" for="style">Стиль: </label>
                                            <div class="controls">
                                                <label class="d-i_b m-r_15"><input type="radio" value="1" {if $settings.style == 1}checked="checked"{/if}   name="style" /><img src="{site_url('application/modules/rating/templates/img/')}/style1.png"></label><br><br>
                                                <label class="d-i_b"><input type="radio" value="2" {if $settings.style == 2}checked="checked"{/if} name="style" /><img src="{site_url('application/modules/rating/templates/img/')}/style2.png"></label><br><br>
                                                <label class="d-i_b"><input type="radio" value="3" {if $settings.style == 3}checked="checked"{/if} name="style" /><img src="{site_url('application/modules/rating/templates/img/')}/style3.png"></label>
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
            <table class="table table-striped table-bordered table-hover table-condensed">
                <thead>
                    <tr>
                        <th colspan="6">
                            Документация
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="6">
                            <div class="inside_padd span12">
                                <h4>Описание</h4>
                                <p>
                                    Rating - Модуль для оценки материалов сайта на движке ImageCMS. Он позволяет оценивать как отдельные страницы, так и комментарии к страницам, а так же фотографии и альбомы из модуля Галереи. Модуль прост в установке и интеграции в дизайн, имеет 3 варианта стилевого оформления, настроиваемых в админке.
                                </p>
                                <h4>Оцениваем страницы</h4>
                                <p>
                                    Для того, чтобы вставить блок оценки материала на одну страницу, открываем <b>page_full.tpl</b>, и в место, куда хотим установить его, вставляем следующий код:
                                </p>
                                <textarea rows="1">&lbrace;echo &dollar;CI->rating->show(&dollar;page.id,'page')&rbrace;</textarea>
                                <p>
                                    Для того, чтобы сделать несколько блоков оценки для каждой страницы в <b>category.tpl</b>, необходимо просто в цикле <code>foreach</code>, в место где необходима оценка, вставить тот же код, только заменить <code>$page.id</code> на <code>$item.id</code>
                                </p>
                                <h4>Оцениваем комментарии</h4>
                                <p>Для того, чтобы вставить блок оценки, к каждому комментарию, необходимо открыть в папке вашего шаблона, файл <b>comments.tpl</b>, и между блоком <code>foreach</code> вставить следующий код:</p>
                                <textarea rows="1">&lbrace;echo &dollar;CI->rating->show(&dollar;comment.id,'comments')&rbrace;</textarea>
                                <p>Теперь каждый человек, может оценить мнение другого человека у вас на сайте.</p>

                                <h4>Оцениваем фотографии</h4>
                                <p>
                                    Для того, чтобы вставить блок оценки к определённой фотографии из модуля Галерея, необходимо открыть шаблоны модуля по пути: <code>/application/modules/templates/public/</code>, найти необходимый шаблон, например <b>album.tpl</b>, и под фотографию, либо в любое другое нужное вам место, вставляем следующий код:</p>
                                <textarea rows="1">&lbrace;echo &dollar;CI->rating->show(&dollar;prev_img.id,'image')&rbrace;</textarea>
                                <p>
                                    Примерно так же поступаем в случае, если нам нужны оценки для альбомов. Нужно только открыть файл <b>albums.tpl</b>, и вставить код между <code>foreach</code>, такой же как выше, только заменить параметры: <code>$prev_img.id</code> на <code>$album.id</code>, и <code>'image'</code>, на <code>'album'</code>
                                </p>
                                <p>Автор: <a href="http://chuikoff.ru" target="_blank">Чуйков Константин</a></p>
                                <p></p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</section>
</div>