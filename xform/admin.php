<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Admin extends BaseAdminController {


    public function __construct() {
        parent::__construct();

        $this->load->model('xform_m');
        $this->load->library('form_validation');

    }

    public function index() {
        
        $form = $this->xform_m->get_all_form();
        $this->template->assign('forms', $form);
        $this->display_tpl('admin');
    }

    /* РАБОТА с ФОРМАМИ */

    public function create_form() {
        if ($this->input->post('page_title')) {
            //Проверяем данные
            $this->form_validation->set_rules('page_title', 'Заголовок', 'trim|required|max_length[255]|min_length[1]');
            $this->form_validation->set_rules('page_url', 'URL формы', 'max_length[255]|trim|xss_clean|required');
            $this->form_validation->set_rules('subject', 'Тема', 'max_length[255]|trim|xss_clean|required');
            $this->form_validation->set_rules('email', 'E-mail', 'max_length[255]|trim|valid_email|xss_clean|required');
            $this->form_validation->set_rules('good', 'Сообщение', 'trim|xss_clean|max_length[255]|required');

            if ($this->form_validation->run($this) == FALSE) {
                showMessage(validation_errors(), false, 'r');
            } else {
                //Формируем массив данных
                $data = array(
                    'title' => $_POST['page_title'],
                    'url' => $_POST['page_url'],
                    'desc' => $_POST['desc'],
                    'success' => $_POST['good'],
                    'subject' => $_POST['subject'],
                    'email' => $_POST['email'],
                );
                //Добавляем в БД
                if ($this->db->insert('xform', $data)) {
                    showMessage('Готово', 'Форма успешно добавлена');
                    pjax('/admin/components/cp/xform/');
                }
            }
        } else {
             $this->display_tpl('create_form');
        }
    }

    public function edit_form($id) {
        //Собираем данные формы
        $this->db->where('id', $id);
        $form = $this->db->get('xform')->row_array();
        $this->template->assign('form', $form);

        if ($this->input->post('page_title')) {
            //Обрабатываем введённые данные
            $this->form_validation->set_rules('page_title', 'Заголовок', 'trim|required|max_length[255]|min_length[1]');
            $this->form_validation->set_rules('page_url', 'URL формы', 'max_length[255]|trim|xss_clean|required');
            $this->form_validation->set_rules('subject', 'Тема', 'max_length[255]|trim|xss_clean|required');
            $this->form_validation->set_rules('good', 'Сообщение', 'trim|xss_clean|max_length[255]|required');

            if ($this->form_validation->run($this) == FALSE) {
                showMessage(validation_errors(), false, 'r');
            } else {
                //Собираем массив данных
                $data = array(
                    'title' => $_POST['page_title'],
                    'url' => $_POST['page_url'],
                    'desc' => $_POST['desc'],
                    'success' => $_POST['good'],
                    'subject' => $_POST['subject'],
                    'email' => $_POST['email'],
                );

                $this->db->where('id', $id);

                //Обновляем данные
                if ($this->db->update('xform', $data)) {
                    showMessage('Готово', 'Форма успешно обновлена');
                    pjax('/admin/components/cp/xform/');
                }
            }
        } else {
            $this->display_tpl('edit_form');
        }
    }

    public function delete_form() {
        if (count($_POST) > 0) {
            $this->db->where('id', $_POST['id'])->delete('xform');
            $this->db->where('fid', $_POST['id'])->delete('xform_field');
        }
    }

    /* РАБОТА С ПОЛЯМИ */

    public function fields($id) {
        $fields = $this->xform_m->get_all_field($id);

        $form_name = $this->xform_m->get_form_name($id);

        $this->template->assign('fields', $fields);
        $this->template->assign('form_name', $form_name);
        $this->template->assign('form_id', $id);

        $this->display_tpl('admin_field');
    }

    public function mix_field($fid = null, $field = null) {
        if ($field) {
            $field = $this->xform_m->get_field($field);
            $this->template->assign('field', $field);
        }

        $this->template->assign('fid', $fid);

        if ($this->input->post('type')) {
            $this->load->helper('translit');
            //Обрабатываем введённые данные

            $this->form_validation->set_rules('name', 'Имя', 'trim|required|max_length[255]|min_length[1]');
            $this->form_validation->set_rules('value', 'Значение', 'trim|xss_clean');
            $this->form_validation->set_rules('desc', 'Описание', 'trim|xss_clean');
            $this->form_validation->set_rules('oper', 'Операции', 'trim');
            $this->form_validation->set_rules('position', 'Описание', 'trim|xss_clean|numeric');
            $this->form_validation->set_rules('max', 'Максимальное значение', 'trim|xss_clean|numeric');

            if ($this->form_validation->run($this) == FALSE) {
                showMessage(validation_errors(), false, 'r');
            } else {
                $data = array(
                    'fid' => $fid,
                    'name' => translit_url($_POST['name']),
                    'type' => $this->input->post('type'),
                    'label' => $this->input->post('name'),
                    'value' => $this->input->post('value'),
                    'desc' => $this->input->post('desc'),
                    'operation' => $this->input->post('oper'),
                    'position' => $this->input->post('position'),
                    'maxlength' => $this->input->post('max'),
                    'checked' => $this->input->post('check'),
                    'disabled' => $this->input->post('disable'),
                    'require' => $this->input->post('required'),
                );

                if (!$field) {
                    $this->db->insert('xform_field', $data);
                    showMessage('Поле успешно добавлено!', 'Готово');
                } else {
                    $this->db->where('id', $field['id']);
                    $this->db->set($data);
                    $this->db->update('xform_field');
                    showMessage('Готово', 'Поле успешно сохранено!');
                }

                pjax('/admin/components/cp/xform/fields/' . $fid);
            }
        } else {
            $this->display_tpl('mix_field');
        }
    }
	
	public function msg()
	{
		$msg = $this->db->get('xform_msg')->result_array();
		$this->template->assign('message',$msg);
		$this->display_tpl('message');
	}

    public function delete_fields() {
        foreach ($this->input->post('id') as $id) {
            $this->db->where('id', $id)->delete('xform_field');
        }
    }

    public function update_positions() {
        $positions = $this->input->post('positions');
        foreach ($positions as $key => $value) {
            $this->db->where('id', (int) $value)->set('position', $key)->update('xform_field');
        }
        showMessage('Позиция обновлена');
    }

    private function display_tpl($file = '')
	{
        $file = realpath(dirname(__FILE__)).'/templates/admin/'.$file;
		$this->template->show('file:'.$file, FALSE);
	}

}