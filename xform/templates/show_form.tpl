
<link rel="stylesheet" type="text/css" href="{site_url('application/modules/xform/templates/public')}/xform.css">
{if $widget.settings.ajax==1}    
<script>
        var id_form = '{$form.url}';
        var success_msg = '{$form.success}';
        {literal}
        function send_widget_form(i){
            $(i).attr('value','Загрузка');
            $.ajax({
                url : $('#'+id_form).attr('action'),
                    type: $('#' + id_form).attr('method'),
                    data: $('#' + id_form).serialize(),
                    success: function(data)
                    {
                        data = $(data).find('.result').text();
                        if (data === success_msg)
                        {
                            $('.result').addClass('good');
                        }
                        else
                        {
                            $('.result').removeClass('good');
                        }
                        $('.result').html(data);
                        $('#btn_send_ajax').attr('value', 'Отправить');
                    }
                });
                return false;
            }
        {/literal}
    </script>
    {/if}
<h1>{$form.title}</h1>
{$form.desc}

{if $widget.settings.ajax==1}
	<div class="result">{$result}</div>
        {else:}
        <div class="result{if $result==$form.success} good{/if}">{$result}</div>    
{/if}

<form action="{site_url('xform/show/')}{$form.url}" method="post" enctype="multipart/form-data" id="{$form.url}">
{$file=0}
{foreach $fields as $field}
{if $field.type=='text'}
<div class="xinput">
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
	<input type="text" name="{$field.name}" id="{$field.name}" value="{$field.value}"{if $field.maxlength >0} maxlength="{$field.maxlength}"{/if} {$field.operation}{if $field.disabled==1} disabled="disabled"{/if}  />
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='textarea'}
<div class="xinput">
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
	<textarea name="{$field.name}" id="{$field.name}"{$field.operation}{if $field.disabled==1} disabled="disabled"{/if}>{$field.value}</textarea>
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='checkbox'}
<div class="xinput">
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
	<input type="checkbox" name="{$field.name}" id="{$field.name}" value="{$field.value}"{$field.operation}{if $field.disabled==1} disabled="disabled"{/if} />
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='select'}
<div class="xinput">
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
	<select name="{$field.name}" id="{$field.name}" {$field.operation}{if $field.disabled==1}disabled="disabled"{/if}>
    {$value = explode("\n",$field.value)}
    {foreach $value as $val}
    	<option value="{$val}">{$val}</option>
    {/foreach}
    </select>
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='radio'}
<div class="xinput">
	{$value = explode("\n",$field.value)}
    <p>{$field.label}</p>
    {foreach $value as $val}
	<label for="{$field.name}"><input type="radio" name="{$field.name}" value="{$val}" /> {if $field.require==1}*{/if} <span>{$val}</span></label>
    {/foreach}
    {if $field.desc}<p class="desc">{$field.desc}</p>{/if}
</div>
{elseif $field.type=='file'}
<div class="xinput">
{$file++}
	<label for="{$field.name}">{if $field.require==1}*{/if}{$field.label}</label>
    <input type="file" name="{$field.name}[]" />
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
    <input type="hidden" name="cms_widget_form" value="1" />
    <input type="hidden" name="form_url" value="{$form.url}" />
    {if $widget.settings.ajax==1}
    <input type="button" id="btn_send_ajax" onClick="send_widget_form($(this));" value="Отправить" />
    {else:}
        <input type="submit" value="Отправить" />
    {/if}
</div>
{/if}
</form>
