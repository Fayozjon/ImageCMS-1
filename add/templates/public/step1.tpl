<div class="frame-inside">
    <div class="container">
        <div class="frame-crumbs">
            {widget('path')}
        </div>
        <div class="clearfix">
            <div class="text left">
                <h1>{$data.name}</h1>
				<h3>Шаг 1. Основная информация</h3>
                <div class="description">
                    {$data.desc}
					{if $config.guest==1 OR $is_logged_in}
<link href="{site_url('application/modules/add/templates/public')}/style.css" type="text/css" rel="stylesheet" />

{if $error}
<div class="error">{$error}</div>
{/if}

<form action="" method="post">
{$categ = get_sub_categories($config.category)}

    
    {if count($categ)==0}
    <input type="hidden" name="category" value="{$config.category}" />
    {else:}
    <div class="xinput">
	<label for="category">Категория</label>
    <select name="category">
    {foreach $categ as $cat}
      	<option value="{$cat.id}">{$cat.name}</option>
    {/foreach}
    </select>
    </div>
    {/if}


<div class="xinput">
	<label for="page_title">Заголовок</label>
    <input type="text" name="page_title" value="{set_value('page_title')}" />
</div>

<div class="xinput">
	<label for="desc">Описание и контакты</label>
    <textarea name="desc">{set_value('desc')}</textarea>
</div>

<div class="xinput">
	<label for="email">E-mail</label>
    <input type="text" name="email" value="{set_value('email')}" />
</div>

{if $config.comments==1}
<div class="xinput">
	<label for="comments">Комментирование</label>
    <input type="checkbox" name="comments" value="1" {set_checkbox('comments','1');} />
</div>
{/if}
<div class="submit">
	{form_csrf()}
  	<input type="submit" value="Далее" />
</div>
</form>
{else:}
<h2>Для добавления информации, <a href="{site_url('auth/register')}">зарегистрируйтесь</a>, если уже зарегистрированы, то <a href="{site_url('auth/login')}">авторизируйтесь.</a> {$config.guest}</h2>
{/if}
					
                </div>
            </div>
            <div class="right">
                {widget('news')}
            </div>
        </div>
    </div>
</div>
