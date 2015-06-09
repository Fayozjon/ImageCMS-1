<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Click_Widgets extends MY_Controller {

    private $defaults = array(
        'category' => ''
    );

    public function __construct() {
        parent::__construct();
    } 

    public function list_banners($widget = array()) {
        $where = array(
            'type' => 'banner',
            'category' => $widget['settings']['category'],
        );
        $banners = $this->db->where($where)->get('click')->result_array();
        $data = array('banners' => $banners);
        return $this->template->fetch('widgets/' . $widget['name'], $data);
    }

    public function rotate_banners($widget = array()) {
        $where = array(
            'type' => 'banner',
            'category' => $widget['settings']['category'],
        );
        $banners = $this->db->where($where)->order_by('id', 'random')->limit(1)->get('click')->row_array();
        $data = array('banners' => $banners);
        return $this->template->fetch('widgets/' . $widget['name'], $data);
    }

    public function list_banners_configure($action = 'show_settings', $widget_data = array()) {
        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        switch ($action) {
            case 'show_settings':
                $category = $this->db->select('category')->distinct()->where('type', 'banner')->order_by('category', 'asc')->from('click')->get()->result_array();
                if ($this->load->module('click/admin')->settings('active') == TRUE) {
                    $this->render('list_banners_form', array('widget' => $widget_data, 'category' => $category));
                } else {
                    $this->display_tpl('/admin/settings');
                }

                break;

            case 'update_settings':
                $this->form_validation->set_rules('category', 'Категория', 'required');

                if ($this->form_validation->run($this) == FALSE) {
                    showMessage(validation_errors(), false, 'r');
                } else {
                    $data = array(
                        'category' => $_POST['category'],
                    );

                    $this->load->module('admin/widgets_manager')->update_config($widget_data['id'], $data);

                    showMessage(lang('amt_settings_saved'));
                    if ($_POST['action'] == 'tomain')
                        pjax('/admin/widgets_manager/index');
                    break;
                }
                break;

            case 'install_defaults':
                $this->load->module('admin/widgets_manager')->update_config($widget_data['id'], $this->defaults);
                break;
        }
    }
    
    public function rotate_banners_configure($action = 'show_settings', $widget_data = array()) {
        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        switch ($action) {
            case 'show_settings':
                $category = $this->db->select('category')->distinct()->where('type', 'banner')->order_by('category', 'asc')->from('click')->get()->result_array();
                if ($this->load->module('click/admin')->settings('active') == TRUE) {
                    $this->render('list_banners_form', array('widget' => $widget_data, 'category' => $category));
                } else {
                    $this->display_tpl('/admin/settings');
                }

                break;

            case 'update_settings':
                $this->form_validation->set_rules('category', 'Категория', 'required');

                if ($this->form_validation->run($this) == FALSE) {
                    showMessage(validation_errors(), false, 'r');
                } else {
                    $data = array(
                        'category' => $_POST['category'],
                    );

                    $this->load->module('admin/widgets_manager')->update_config($widget_data['id'], $data);

                    showMessage(lang('amt_settings_saved'));
                    if ($_POST['action'] == 'tomain')
                        pjax('/admin/widgets_manager/index');
                    break;
                }
                break;

            case 'install_defaults':
                $this->load->module('admin/widgets_manager')->update_config($widget_data['id'], $this->defaults);
                break;
        }
    }

    public function render($viewName, array $data = array(), $return = false) {
        if (!empty($data))
            $this->template->add_array($data);

        $this->template->show('file:' . 'application/modules/click/templates/' . $viewName);
        exit;

        if ($return === false)
            $this->template->show('file:' . 'application/modules/click/templates/' . $viewName);
        else
            return $this->template->fetch('file:' . 'application/modules/click/templates/' . $viewName);
    }

}
