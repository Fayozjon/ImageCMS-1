<div class="container">
    <section class="mini-layout">
        <div class="frame_title clearfix">
            <div class="pull-left">
                <span class="help-inline"></span>
                <span class="title">Настройки модуля</span>
            </div>
            <div class="pull-right">
                <div class="d-i_b">
                    <a href="/admin/components/cp/cart/" class="t-d_n m-r_15"><span class="f-s_14">←</span> <span class="t-d_u">Венуться</span></a>
                    <button type="button" class="btn btn-small btn-info formSubmit" data-form="#save" data-submit><i class="icon-ok icon-white"></i>Сохранить настройки</button>
                </div>
            </div>                            
        </div>               
        <div class="tab-content">

            <div class="tab-pane active" id="xform">
                <table class="table table-striped table-bordered table-hover table-condensed">
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
                                        <form id="save" method="post" action="{site_url('admin/components/cp/cart/settings/update')}">
                                            <div class="control-group">
                                                <label class="control-label" for="page_title">E-mail: </label>
                                                <div class="controls">
                                                    <input type="text" name="email" id="email" value="{$settings.email}">
                                                </div>
                                                <div class="help-block pull-right">Уведомления на какую почту будут приходить?</div>
                                            </div>

                                            <div class="control-group">
                                                <label class="control-label" for="page_title">Денежный формат: </label>
                                                <div class="controls">
                                                    <select name="format">
                                                        <option value="0"{if $settings.format==0} selected="selected"{/if}>Без формата</option>
                                                        <option value="1"{if $settings.format==1} selected="selected"{/if}>{number_format(10123)} - Английский формат</option>
                                                        <option value="2"{if $settings.format==2} selected="selected"{/if}>{number_format(10123,2,',',' ')} - Французский формат</option>
                                                        <option value="3"{if $settings.format==3} selected="selected"{/if}>{str_replace(',',' ',number_format(10123,0))}  - Русский формат</option>
                                                    </select>
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