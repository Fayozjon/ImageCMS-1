<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Admin extends BaseAdminController {

    public function __construct() {
        parent::__construct();
        $this->load->library('lib_category');
    }

    public function index() {
        $query = $this->db->get('add_page')->result_array();
        $this->template->assign('add', $query);
        $this->display_tpl('admin');
       
    }

    public function config($action = '', $id = '') {
        switch ($action) {
            case 'add':
                $category = $this->lib_category->unsorted();
                $this->template->assign('categ', $category);
                $this->display_tpl('master');
                break;
            case 'edit':
                $category = $this->lib_category->unsorted();
                $this->template->assign('categ', $category);
                $data = $this->config('load', $id);
                $this->template->assign('conf', $data);
                $this->display_tpl('master');
                break;
            case 'delete':
                foreach ($this->input->post('id') as $id) {
                    $this->db->where('id', $id)->delete('add_page');
                }
                break;
            case 'load':
                $this->db->where('id', $id);
                $result = $this->db->get('add_page')->row_array();
                return $result;
                break;
        }
    }
    
    public function master($action = '', $id = '') {
        if (count($_POST) > 0) {
            $name = $_POST['name'];
            $desc = $_POST['desc'];
            $config = array();

            $config['guest'] = $_POST['guest'];
            $config['status'] = $_POST['status'];
            $config['comments'] = $_POST['comments'];
            $config['cfcm'] = $_POST['cfcm'];
            $config['category'] = $_POST['category'];

            $conf = serialize($config);

            $data = array(
                'name' => $name,
                'desc' => $desc,
                'config' => $conf
            );

            if ($action == 'add') {
                $this->db->insert('add_page', $data);
            } else if ($action == 'update') {
                $this->db->where('id', $id);
                $this->db->update('add_page', $data);
            }
            showMessage('Мастер готов', 'Готово!');
            pjax('/admin/components/cp/add/');
        }
    }

    public function about() {
        $this->display_tpl('about');
    }

    private function display_tpl($file = '') {
        $file = realpath(dirname(__FILE__)) . '/templates/admin/' . $file;
        $this->template->show('file:' . $file, FALSE);
    }

}