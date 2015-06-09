<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Admin extends BaseAdminController {
    

    public function __construct() {
        parent::__construct();
    }

    public function index() {
        $settings = $this->settings();
        $this->template->assign('settings', $settings);
        $this->display_tpl('admin');
    }
    
    public function settings($action = 'get') {
        $this->load->library('form_validation');
        switch ($action) {
            case 'get':
                $this->db->limit(1);
                $this->db->where('name', 'rating');
                $query = $this->db->get('components');

                if ($query->num_rows() == 1) {
                    $query = $query->row_array();
                    return unserialize($query['settings']);
                }
                break;
            case 'update':
                if (count($_POST) > 0) {
                        $data = array(
                            'style' => $this->input->post('style'),
                        );
                        $this->db->where('name', 'rating');
                        $this->db->update('components', array('settings' => serialize($data)));

                        showMessage('Успешно сохранено');
                        pjax('/admin/components/cp/rating');
                    
                }
                break;
            case 'form':
                $this->template->assign('settings', $this->settings());
                $this->display_tpl('settings');
                break;
        }
    }
    
    private function display_tpl($file = '') {
        $file = realpath(dirname(__FILE__)) . '/templates/' . $file;
        $this->template->show('file:' . $file, FALSE);
    }

}
