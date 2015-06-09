<div id="banners">
    {foreach $banners as $b}
        <a href="{site_url('click/to')}/{$b.id}"><img src="{$b.image}" title="{$b.title}" width="200" /></a>
    {/foreach}
</div>
