<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Admin extends BaseAdminController {

    public $admin_mail = 'admin@localhost';

    public function __construct() {
        parent::__construct();
        $this->load_settings();
    }

    public function index() {
        $query = $this->db->get('cart_order')->result_array();
        $this->template->assign('orders', $query);
        $this->display_tpl('admin');
       
    }

    public function edit_status($id = '') {

        if (count($_POST) > 0) {

            $data = array(
                'status' => $_POST['status'],
            );

            $this->db->where('id',$id)->update('cart_order', $data);
            
            $query = $this->db->where('id',$id)->get('cart_order')->row_array();
            preg_match_all('#<b>E-mail:</b> (.*)<br />\\r\\n#', $query['user_info'], $email, PREG_SET_ORDER);
            
            $this->load->library('email');
            $this->email->from($this->admin_mail);
            $this->email->to($email[0][1]);
            $this->email->subject('Изменён статус заказа');
            $this->email->message('Статус заказа №'.$query['id'].' от '.date('d-m-Y H:i',$query['date']).' - '.$query['status'].'\r\n Администрация - '.site_url());
            $this->email->send();
        }
    }

    public function delete_order() {
        foreach ($this->input->post('id') as $id) {
            $this->db->where('id', $id)->delete('cart_order');
        }
    }

    public function about() {
        $this->display_tpl('about');
    }

    public function settings($action = 'get') {
        $this->load->library('form_validation');
        switch ($action) {
            case 'get':
                $this->db->limit(1);
                $this->db->where('name', 'cart');
                $query = $this->db->get('components');

                if ($query->num_rows() == 1) {
                    $query = $query->row_array();
                    return unserialize($query['settings']);
                }
                break;

            case 'update':
                if (count($_POST) > 0) {

                    $this->form_validation->set_rules('email', 'E-mail', 'trim|valid_email|required|xss_clean');

                    if ($this->form_validation->run($this) == FALSE) {
                        showMessage(validation_errors(), false, 'r');
                    } else {
                        $data = array(
                            'email' => $this->input->post('email'),
                            'format' => $this->input->post('format'),
                        );
                        $this->db->where('name', 'cart');
                        $this->db->update('components', array('settings' => serialize($data)));

                        showMessage(lang('amt_settings_saved'));
                        pjax('/admin/components/cp/cart');
                    }
                }
                break;
            case 'form':
                $this->template->assign('settings', $this->settings());
                $this->display_tpl('settings');
                break;
        }
    }

    private function load_settings() {
        $settings = $this->settings();
        if($settings['email'])
        {
            $this->admin_mail = $settings['email'];
        }
    }


    private function display_tpl($file = '') {
        $file = realpath(dirname(__FILE__)) . '/templates/admin/' . $file;
        $this->template->show('file:' . $file, FALSE);
    }

}

/* End of file admin.php */
