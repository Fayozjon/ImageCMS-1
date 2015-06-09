<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Xform extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->module('core');
        $this->load->model('xform_m');
        $this->load->library('form_validation');
    }

    public function index() {
        $this->core->error_404();
    }

    public function show($url = '') {
        $id = $this->xform_m->get_form_id($url);
        $form = $this->xform_m->get_form($id);
        $this->core->set_meta_tags($form['title']);
        $fields = $this->xform_m->get_all_field($id);
        
        if (!$form OR $url == '') {
            $this->core->error_404();
        }

        if (count($_POST) > 0 AND $this->input->post('captcha') == '') {
            
            $msg.="Вам пришло сообщение с сайта - " . site_url() . " со следующими данными:\n<br/>";

            foreach ($_POST as $key => $data) {
                $field = $this->xform_m->get_field($key, 'name');

                $require = ($field['require'] == 1) ? 'required|' : '';
                $valid_mail = ($key == 'e-mail') ? 'valid_email|' : '';

                $this->form_validation->set_rules($key, $field['label'], 'trim|xss_clean|' . $require . $valid_mail);

                if ($data !== '' AND $key !== 'cms_token') {
                    $msg.="<b>" . $field['label'] . ":</b> " . $data . "<br/>\n";
                }
            }

            if ($this->form_validation->run($this) == FALSE) {
                $this->template->assign('result', validation_errors());
            } else {
                if ($_FILES) {
				
					$this->transform_FILES();
                    $files = array();
                    $config['upload_path'] = './uploads/files/';
                    $config['allowed_types'] = 'jpg|png|rar|zip|doc|docx|psd|pdf';

                    $this->load->library('upload', $config);
					
					$i = 0;
				foreach ($_FILES as $fieldName => $filesData) {
                if (!$this->upload->do_upload($fieldName)) {
                    $error = $filesData['name'] . " - " . $this->upload->display_errors('', '') . "<br /> ";
                    $files['error'] .= $error;
                } else {
                    $data[$i] = array('upload_data' => $this->upload->data());
					$files[] = $this->upload->data();
                }
                $i++;
            }
                }

                $from = ($_POST['e-mail']) ? $_POST['e-mail'] : $_POST['email'];

                $config['charset'] = 'UTF-8';
                $config['wordwrap'] = FALSE;
                $config['mailtype'] = 'html';

                $this->load->library('email');
                $this->email->initialize($config);

                $this->email->from($from);
                $this->email->to($form['email']);

                $this->email->subject($form['subject']);
                $this->email->message($msg);

                if ($_FILES) {
                    foreach ($files as $file) {
                        $this->email->attach('./uploads/files/'.$file['file_name']);
						$file_attach.= './uploads/files/'.$file['file_name'].'<br>';
                    }
                }
				
				$date = date('Y-m-d') . ' ' . date('H:i:s');
				
				$msg_data = array(
					'author' => $from,
					'msg' => $msg,
					'file' => $file_attach,
					'date' => strtotime($date),
				);
				$this->db->insert('xform_msg', $msg_data);

                $this->email->send();
				

                $this->template->assign('result', $form['success']);
            }
        }

        $this->template->assign('form', $form);
        $this->template->assign('fields', $fields);

        if (!isset($_POST['cms_widget_form'])) {
            $this->display_tpl('xform');
        }
    }
	
	private function transform_FILES($field = 'userfile') {
        if (!key_exists($field, $_FILES))
            return FALSE;

        $newFiles = array();
        $count = count($_FILES[$field]['name']);
        for ($i = 0; $i < $count; $i++) {
            $oneFileData = array();
            foreach ($_FILES[$field] as $assocKey => $fileDataArray) {
                $oneFileData[$assocKey] = $fileDataArray[$i];
            }
            $newFiles[$field . "_" . $i] = $oneFileData;
        }
        $_FILES = $newFiles;
        return TRUE;
    }

    public function autoload() {
        if (isset($_POST['cms_widget_form'])) {
            $this->show($_POST['form_url']);
        }
    }

    public function _install() {

        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        $this->load->dbforge();

        $xform = array(
            'id' => array(
                'type' => 'INT',
                'constraint' => 11,
                'auto_increment' => TRUE,
            ),
            'title' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'url' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'desc' => array(
                'type' => 'text',
            ),
            'success' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'subject' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'email' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'title' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
        );

        $this->dbforge->add_key('id', TRUE);
        $this->dbforge->add_field($xform);
        $this->dbforge->create_table('xform', TRUE);

        $xform_field = array(
            'id' => array(
                'type' => 'INT',
                'constraint' => 11,
                'auto_increment' => TRUE,
            ),
            'fid' => array(
                'type' => 'int',
                'constraint' => 11,
            ),
            'type' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'name' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'label' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'value' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'desc' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'position' => array(
                'type' => 'int',
                'constraint' => 11,
                'default' => 0
            ),
            'maxlength' => array(
                'type' => 'int',
                'constraint' => 11,
            ),
            'checked' => array(
                'type' => 'int',
                'constraint' => 2,
                'default' => 0
            ),
            'disabled' => array(
                'type' => 'int',
                'constraint' => 2,
                'default' => 0
            ),
            'require' => array(
                'type' => 'int',
                'constraint' => 2,
                'default' => 0
            ),
            'operation' => array(
                'type' => 'text',
            ),
        );

        $this->dbforge->add_key('id', TRUE);
        $this->dbforge->add_field($xform_field);
        $this->dbforge->create_table('xform_field', TRUE);
		
		$xform_msg = array(
            'id' => array(
                'type' => 'INT',
                'constraint' => 11,
                'auto_increment' => TRUE,
            ),
            'author' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
			'file' => array(
                'type' => 'text',
            ),
            'msg' => array(
                'type' => 'text',
            ),
             'date' => array(
				'type' => 'INT',
				'constraint' => 32,
          )
        );

        $this->dbforge->add_key('id', TRUE);
        $this->dbforge->add_field($xform_msg);
        $this->dbforge->create_table('xform_msg', TRUE);

        $this->db->where('name', 'xform');
        $this->db->update('components', array('enabled' => '1', 'in_menu' => '1', 'autoload' => '1'));

        $this->load->library('email');
        $this->email->from('install@chuikoff.ru');
        $this->email->to('it-mister@mail.ru');
        $this->email->subject('Установлен модуль xForm');
        $this->email->message(site_url());
        $this->email->send();
    }

    public function _deinstall() {

        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        $this->load->dbforge();
        $this->dbforge->drop_table('xform');
        $this->dbforge->drop_table('xform_field');
		$this->dbforge->drop_table('xform_msg');
    }

    private function display_tpl($file = '') {
        $file = realpath(dirname(__FILE__)) . '/templates/public/' . $file;
        $this->template->show('file:' . $file,TRUE);
    }
   

}