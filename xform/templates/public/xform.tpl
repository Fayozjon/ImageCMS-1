<div class="frame-inside">
    <div class="container">
        <div class="frame-crumbs">
            {widget('path')}
        </div>
        <div class="clearfix">
            <div class="text left">
                <h1>{$form.title}</h1>
                <div class="description">

<link rel="stylesheet" type="text/css" href="{site_url('application/modules/xform/templates/public')}/xform.css">

{$form.desc}
<form action="{site_url('xform/show')}/{$form.url}" method="post" enctype="multipart/form-data" id="{$form.url}">
{if $result}
	<div class="result{if $result==$form.success} good{/if}">{$result}</div>
{/if}
{$file=0}
{foreach $fields as $field}
{if $field.type=='text'}
<div class="xinput">
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
	<input type="text" name="{$field.name}" id="{$field.name}" value="{set_value($field.name,$field.value)}"{if $field.maxlength >0} maxlength="{$field.maxlength}"{/if} {$field.operation}{if $field.disabled==1} disabled="disabled"{/if}  />
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='textarea'}
<div class="xinput">
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
	<textarea name="{$field.name}" id="{$field.name}"{$field.operation}{if $field.disabled==1} disabled="disabled"{/if}>{set_value($field.name,$field.value)}</textarea>
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='checkbox'}
<div class="xinput">
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
	<input type="checkbox" name="{$field.name}" id="{$field.name}" value="{$field.value}"{$field.operation}{if $field.disabled==1} disabled="disabled"{/if} {set_checkbox($field.name,$field.value)} />
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='select'}
<div class="xinput">
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
	<select name="{$field.name}" id="{$field.name}" {$field.operation}{if $field.disabled==1}disabled="disabled"{/if}>
    {$value = explode("\n",$field.value)}
    {foreach $value as $val}
    <option value="{$val}"  {set_select($field.name,$val)}>{$val}</option>
    {/foreach}
    </select>
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='radio'}
<div class="xinput">
	{$value = explode("\n",$field.value)}
    <p>{$field.label}</p>
    {foreach $value as $val}
    <label for="{$field.name}"><input type="radio" name="{$field.name}" value="{$val}" {set_radio($field.name,$val)}/> {if $field.require==1}*{/if} <span>{$val}</span></label>
    {/foreach}
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='file'}
<div class="xinput">
{$file++}
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
    <input type="file" multiple="multiple" name="userfile[]" />
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{/if}
{/foreach}
{if count($fields)>0}
<div class="input" style="display:none;">
	<input type="text" name="captcha" value="" />
</div>
<div class="submit">
	{form_csrf()}
  	<input type="submit" value="Отправить" />
</div>
{/if}
</form>
 </div>
              
            </div>
            <div class="right">
                {widget('news')}
            </div>
        </div>
    </div>
</div>