<div class="frame-inside">
    <div class="container">
        <div class="frame-crumbs">
            {widget('path')}
        </div>
        <div class="clearfix">
            <div class="text left">
                <h1>{$data.name}</h1>
				<h3>Шаг 3. Финиш.</h3>
                <div class="description">
<h3>Спасибо! Вы успешно добавили на сайт страницу <a href="{site_url($page.cat_url)}/{$page.url}" target="_blank">{$page.title}</a></h3>
<p>После проверки модератором, ваша страница будет опубликована. Сейчас статус - <b>{$page.post_status}</b></p>
<p>На ваш e-mail <b>{$email}</b> было отправлено сообщение с ссылкой на удаление страницы.</p>
<p>Если вы хотите удалить страницу прямо сейчас, нажмите ссылку - <a href="{$link}">удалить.</a></p>
</div>
            </div>
            <div class="right">
                {widget('news')}
            </div>
        </div>
    </div>
</div>