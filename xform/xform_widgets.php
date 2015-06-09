<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Xform_Widgets extends MY_Controller {

	private $defaults = array(
        'form_id' => 0,
        'ajax' => 0,
    );

   	public function __construct()
	{
		parent::__construct();
		$this->load->model('xform_m');
    } 
	
    public function show_form($widget = array()) {
        $form = $this->xform_m->get_form($widget['settings']['form_id']);
        $fields = $this->xform_m->get_all_field($widget['settings']['form_id']);
        $data = array(
            'form' => $form,
            'fields' => $fields,
            'widget' => $widget
        );
        $this->template->add_array($data);
        return $this->template->fetch('widgets/' . $widget['name']);
    }
	
	public function show_form_configure($action = 'show_settings', $widget_data = array())
	{
		if( $this->dx_auth->is_admin() == FALSE) exit;  
 
        switch ($action)
        {
            case 'show_settings':
		$form = $this->xform_m->get_all_form();
		$this->template->assign('forms',$form);
                if($this->load->module('xform/admin')->settings('active')==TRUE)
                {
                    //$this->display_tpl('show_form_form', array('widget' => $widget_data,'forms' => $form));
                    $this->render('show_form_form', array('widget' => $widget_data,'forms' => $form));
                }
                else
                {
                    $this->display_tpl('/admin/settings');
                }
                
            break;

            case 'update_settings':
                $this->form_validation->set_rules('form_id', 'Форма', 'required');

                if ($this->form_validation->run($this) == FALSE)
                {
                    showMessage( validation_errors(),false,'r' );
                }
                else{
                    $data = array(
                        'form_id' => $_POST['form_id'],
                        'ajax' => $_POST['ajax']
                    ); 

                    $this->load->module('admin/widgets_manager')->update_config($widget_data['id'], $data);
                    
                    showMessage(lang('amt_settings_saved'));
                    if($_POST['action'] == 'tomain')
                        pjax('/admin/widgets_manager/index');
                    break;
                }
            break;

            case 'install_defaults':
                $this->load->module('admin/widgets_manager')->update_config($widget_data['id'], $this->defaults);            
            break;
        }
	}
	
	// Template functions
    function display_tpl($file, $vars = array()) {
        $this->template->add_array($vars);

        $file = realpath(dirname(__FILE__)) . '/templates/' . $file . '.tpl';
        $this->template->display('file:' . $file);
    }

    function fetch_tpl($file, $vars = array()) {
        $this->template->add_array($vars);

        $file = realpath(dirname(__FILE__)) . '/templates/' . $file . '.tpl';
        return $this->template->fetch('file:' . $file);
    }

    public function render($viewName, array $data = array(), $return = false) {
        if (!empty($data))
            $this->template->add_array($data);

        $this->template->show('file:' . 'application/modules/xform/templates/' . $viewName);
        exit;

        if ($return === false)
            $this->template->show('file:' . 'application/modules/xform/templates/' . $viewName);
        else
            return $this->template->fetch('file:' . 'application/modules/xform/templates/' . $viewName);
    }

}