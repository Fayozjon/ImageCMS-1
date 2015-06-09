<div class="frame-inside">
    <div class="container">
        <div class="frame-crumbs">
            {widget('path')}
        </div>
        <div class="clearfix">
            <div class="text left">
                <h1>{$data.name}</h1>
				<h3>Шаг 2. Дополнительная информация</h3>
                <div class="description">
{if $config.guest==1 OR $is_logged_in}
<link href="{site_url('application/modules/add/templates/public')}/style.css" type="text/css" rel="stylesheet" />
{if $error}
<div class="error">{$error}</div>
{/if}

<form action="" enctype="multipart/form-data" method="post">
{if $forms}
{foreach $forms as $form}
{$data = unserialize($form.data)}
<div class="xinput">
	<label for="{$form.field_name}">{if $data.required==1}*{/if} {$form.label}</label>
    {if $form.type=='text'}
    	{if $data.enable_image_browser == 1 OR $data.enable_file_browser == 1}
        <input type="file" name="{$form.field_name}[]" />
        {else:}
    	<input type="text" name="{$form.field_name}" value="{$data.initial}" />
        {/if}
    {elseif $form.type=='textarea'}
    	<textarea name="{$form.field_name}">{$data.initial}</textarea>
    {elseif $form.type=='checkbox'}
    	<input type="checkbox" name="{$form.field_name}" value="{$data.initial}" />
    {elseif $form.type=='select'}
    	{$value = explode("\n",$data.initial)}
        <select name="{$form.field_name}">
        {foreach $value as $key => $val}
        	<option value="{$key}">{$val}</option>
        {/foreach}
        </select>
    {/if}
    <p class="help_text">{$data.help_text}</p>
</div>
{/foreach}
<div class="submit">
	{form_csrf()}
    <input type="hidden" name="cfcm_use_group" value="{$group}">
    <input type="button" value="Назад" onclick="window.history.back(-1);" />
  	<input type="submit" value="Далее" />
</div>
</form>
{else:}
<p>Дополнительных данных не требуется. Нажмите далее.</p>
<div class="submit">
	{form_csrf()}
    <input type="button" value="Назад" onclick="window.history.back(-1);" />
  	<input type="submit" value="Далее" />
</div>
{/if}

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
