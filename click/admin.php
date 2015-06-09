<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Admin extends BaseAdminController {
    

    public function __construct() {
        parent::__construct();
        $this->load->library('form_validation');
    }
    
    public function about() {
        $this->display_tpl('about');
    }

    public function index() {
        $link = $this->db->get('click')->result_array();
        $this->template->assign('links', $link);
        $this->display_tpl('admin');
        
    }

    public function links($id = '') {
        
        if($id!=='new')
        {
            $link = $this->db->where('id', $id)->get('click')->row_array();
            $this->template->assign('link', $link);
        }
        
        if (count($_POST) > 0) {

            $this->form_validation->set_rules('title', 'Заголовок', 'trim|required|min_length[1]|max_length[255]|xss_clean');
            $this->form_validation->set_rules('link', 'Ссылка', 'trim|required|xss_clean');

            if ($this->form_validation->run($this) == FALSE) {
                showMessage(validation_errors());
            } else {
                $data = array(
                    'type' => $this->input->post('type'),
                    'title' => $this->input->post('title'),
                    'desc' => $this->input->post('desc'),
                    'category' => $this->input->post('category'),
                    'image' => $this->input->post('image'),
                    'link' => $this->input->post('link')
                );
                
                if($id=='new')
                {
                    $this->db->insert('click', $data);
                    showMessage('Ссылка успешно создана','Готово!');
                }
                else
                {
                    $this->db->where('id', $id);
                    $this->db->update('click', $data);
                    showMessage('Ссылка успешно сохранена','Готово!');
                }
                pjax('/admin/components/cp/click');
            }
        }
        else 
        {
            $this->display_tpl('links');
        }
        
    }


    public function delete_link() {
        foreach ($this->input->post('id') as $id) {
            $this->db->where('id', $id)->delete('click');
        }
    }

    private function display_tpl($file = '') {
        $file = realpath(dirname(__FILE__)) . '/templates/admin/' . $file;
        $this->template->show('file:' . $file, FALSE);
    }

}
