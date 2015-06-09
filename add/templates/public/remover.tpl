<div class="frame-inside">
    <div class="container">
        <div class="frame-crumbs">
            {widget('path')}
        </div>
        <div class="clearfix">
            <div class="text left">
			
<link href="{site_url('application/modules/add/templates/public')}/style.css" type="text/css" rel="stylesheet" />

<h3>Удалить страницу <a href="{site_url($page.cat_url)}/{$page.url}" target="_blank">{$page.title}</a></h3>

{if $result}
<div>{$result}</div>
{/if}

<form action="{site_url('add/remover')}/{echo $CI->uri->segment(3)}" method="post">
<div class="xinput">
    <label for="email">E-mail для идентификации</label>
    <input type="text" name="email" value="" />
</div>
<div class="submit">
    <p>Удалить?</p>
    {form_csrf()}
    <input type="button" value="Нет" onclick="window.location.href='{site_url()}';" />
    <input type="submit" value="Да" />
</div>
</form>

</div>
            </div>
            <div class="right">
                {widget('news')}
            </div>
        </div>
    </div>
</div>