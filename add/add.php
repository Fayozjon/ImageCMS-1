<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Add extends MY_Controller {

    public $config = array();

    public function __construct() {
        parent::__construct();
        $this->load->module('core');
        $this->load->model('cms_admin');
        $this->load->library('email');
        $this->load->library('form_validation');
    }

    public function index() {
        $this->core->error_404();
    }

    public function step($id = '', $step = 1) {
        $this->db->where('id', $id);
        $conf = $this->db->get('add_page')->row_array();
        $this->config = unserialize($conf['config']);

        if (!$conf) {
            $this->core->error_404();
        }

        $this->template->add_array(array('data' => $conf, 'config' => $this->config));

        switch ($step) {
            case 1:
                $this->core->set_meta_tags($conf['name'] . ' / ' . 'Шаг 1 ');

                if (count($_POST) > 0) {
                    $this->form_validation->set_rules('page_title', 'Заголовок', 'trim|required|min_length[3]|max_length[255]|xss_clean');
                    $this->form_validation->set_rules('desc', 'Описание и контакты', 'trim|required|min_length[3]|max_length[500]|xss_clean');
                    $this->form_validation->set_rules('email', 'E-Mail', 'trim|required|valid_email|xss_clean');

                    if ($this->form_validation->run() === FALSE) {
                        $this->template->assign('error', validation_errors());
                    } else {
                        $data = array(
                            'category' => $this->input->post('category'),
                            'page_title' => $this->input->post('page_title'),
                            'prev_text' => $this->input->post('desc'),
                            'comments_status' => $this->input->post('comments'),
                            'author' => $this->input->post('email')
                        );

                        $this->session->set_userdata($data);

                        redirect(site_url('add/step') . '/' . $id . '/2');
                    }
                }

                $this->display_tpl('step1');
                break;

            case 2:

                $this->core->set_meta_tags($conf['name'] . ' / ' . 'Шаг 2 ');

                if ($this->config['cfcm'] == 1) {
                    $forms = $this->load_cfcm($this->session->userdata('category'));

                    if (!$forms) {
                        $this->core->error_404();
                    }

                    if ($_FILES) {
                        $fileconf['upload_path'] = './uploads/images/';
                        $fileconf['allowed_types'] = 'jpg|png|gif|zip|rar';
                        $fileconf['encrypt_name'] = TRUE;
                        $this->load->library('upload', $fileconf);
                    }

                    if (count($_POST) > 0) {
                        foreach ($_POST as $key => $val) {
                            $data = $this->get_cfcm_option($forms, $key, 'data');
                            $label = $this->get_cfcm_option($forms, $key, 'label');

                            $this->form_validation->set_rules($key, $label, $data['validation'] . 'trim|xss_clean');
                        }

                        if ($_FILES) {
                            foreach ($_FILES as $file => $val) {
                                $_POST[$file] = $this->upload_image($file);
                            }
                        }

                        if ($this->form_validation->run() === FALSE) {
                            $this->template->assign('error', validation_errors());
                        } else {
                            $this->add_page();
                            redirect(site_url('add/step') . '/' . $id . '/3');
                        }
                    }
                    $group = $this->get_group_cfcm($this->session->userdata('category'));
                    $this->template->assign('group', $group);
                    $this->template->assign('forms', $forms);

                    $this->display_tpl('step2');

                    
                } else {
                    $this->add_page();
                    redirect(site_url('add/step') . '/' . $id . '/3');
                }
                break;

            case 3:
                $res = array(
                    'page' => $this->cms_admin->get_page($this->session->userdata('item_id')),
                    'link' => site_url('add/remover') . '/' . $this->session->userdata('crypt'),
                    'email' => $this->session->userdata('email')
                );

                    $this->template->add_array($res);
                    $this->display_tpl('step3');

                break;
        }
    }

    private function add_page() {
        $this->load->library('lib_seo');
        $this->load->library('lib_category');
        $this->load->helper('translit');

        $pages = array();

        $pages['title'] = $this->session->userdata('page_title');
        $pages['category'] = $this->session->userdata('category');
        $pages['prev_text'] = $this->session->userdata('prev_text');
        $pages['comments_status'] = $this->session->userdata('comments_status');
        $pages['author'] = $this->session->userdata('author');

        if ($this->config['status'] == 'pending') {
            $pages['post_status'] = 'pending';
        } else {
            $pages['post_status'] = 'publish';
        }

        $qmax = $this->db->select_max('id')->from('content')->get()->row();
        $page_id = ($qmax->id) + 1;

        $url = translit_url($this->session->userdata('page_title'));

        $this->db->select('id,url,category');
        $this->db->where('url', $url);
        $this->db->where('category', $this->session->userdata('category'));
        $query_url = $this->db->get('content');

        if ($query_url->num_rows() >= 1) {
            $url = $url . '-' . $page_id;
        }

        $today = strtotime(date('Y-m-d') . ' ' . date('H:i:s'));

        $pages['url'] = $url;
        $pages['keywords'] = $this->lib_seo->get_keywords($this->session->userdata('prev_text'));
        $pages['description'] = $this->lib_seo->get_description($this->session->userdata('prev_text'));
        $full_url = $this->lib_category->GetValue($this->session->userdata('category'), 'path_url');

        if ($full_url == FALSE) {
            $full_url = '';
        }

        $pages['cat_url'] = $full_url;
        $pages['publish_date'] = $today;
        $pages['created'] = $today;
        $pages['lang'] = 3;
        $pages['meta_title'] = $pages['title'];

        $this->cms_admin->add_page($pages);
        
        $pages['id'] = $page_id;
        
        $this->load->module('cfcm')->save_item_data($page_id, 'page');

        $remover = array(
            'item_id' => $page_id,
            'crypt' => md5(md5($page_id)),
            'email' => $this->session->userdata('author'),
            'date' => $today
        );

        $this->session->set_userdata($remover);

        $this->add_remover($remover);

        $this->send_message($remover);
    }

    public function remover($crypt = '') {
        $crypt_data = $this->get_remover_page($crypt);
        $page = $this->cms_admin->get_page($crypt_data['item_id']);

        if (count($_POST) > 0) {
            if (($page['author'] == $_POST['email']) AND (md5(md5($page['id'])) == $crypt_data['crypt'])) {
                $this->delete_page($page['id']);
                $this->db->where('item_id', $page['id'])->delete('add_page_remove');
                $this->template->assign('result', 'Страница успешно удалена!');
            } else {
                $this->template->assign('result', 'У вас нет доступа к удалению этой страницы.');
            }
        }

        if ($page) {
            $this->template->assign('page', $page);
            $this->display_tpl('remover');
        } else {
            $this->core->error_404();
        }
    }
    
    private function delete_page($id = NULL)
    {
            $this->db->where('id', $id);
            $this->db->delete('content');
    }

    private function send_message($data = array()) {
        $email['charset'] = 'UTF-8';
        $email['wordwrap'] = FALSE;
        $email['mailtype'] = 'html';


        $this->email->initialize($email);

        $page = $this->cms_admin->get_page($data['item_id']);

        $msg.="Ваше материал был успешно добавлен на сайт - " . site_url() . "<br/>";

        if ($page['post_status'] == "pending") {
            $msg.="После проверки модератором, он будет опубликован.<br/>";
        }

        $msg.="<br/>Статус: " . $page['post_status'] . "<br/>\n";
        $msg.="Категория: " . get_category_name($page['category']) . "<br/>";
        $msg.="Время: " . date("d.m.Y H:i", $data['date']) . "<br/><br/>";

        $msg.="<a href='" . site_url($page['cat_url'] . '/' . $page['url']) . "'>Посмотреть материал</a><br/>";
        $msg.="<a href='" . site_url('add/remover') . "/" . $data['crypt'] . "'>Удалить материал</a><br/>";

        $this->email->from($this->load->module('feedback')->admin_mail);
        $this->email->to($this->session->userdata('email'));
        //$this->email->reply_to("it-mister@mail.ru");

        $this->email->subject("Добавлен материал на сайт");
        $this->email->message($msg);

        $this->email->send();
    }

    private function get_remover_page($crypt = '') {
        $this->db->where('crypt', $crypt);
        $result = $this->db->get('add_page_remove')->row_array();
        return $result;
    }

    private function add_remover($data = array()) {
        $this->db->insert('add_page_remove', $data);
    }

    private function upload_image($name = 'userfile') {
        if ($this->upload->do_upload($name)) {
            $file = $this->upload->data();
            return '/uploads/images/' . $file['file_name'];
        } else {
            return false;
        }
    }

    private function load_cfcm($id = FALSE) {
        $group = $this->get_group_cfcm($id);
        $input = $this->db
                ->where('group_id', $group)
                ->join('content_fields', 'content_fields_groups_relations.field_name = content_fields.field_name')
                ->get('content_fields_groups_relations')->result_array();
        return $input;
    }

    private function get_group_cfcm($id = FALSE) {
        $this->db->select('field_group')->where('id', $id);
        $result = $this->db->get('category')->row_array();
        return $result['field_group'];
    }

    private function get_cfcm_option($field = array(), $name = '', $type = '') {
        if (is_array($field)) {
            foreach ($field as $pole) {
                if ($pole['field_name'] == $name) {
                    if ($type == 'data') {
                        return unserialize($pole[$type]);
                    } else {
                        return $pole[$type];
                    }
                }
            }
        } else {
            return false;
        }
    }

    public function _install() {

        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        $this->load->dbforge();

        $fields = array(
            'id' => array(
                'type' => 'INT',
                'constraint' => 11,
                'auto_increment' => TRUE,
            ),
            'name' => array(
                'type' => 'VARCHAR',
                'constraint' => 255,
            ),
            'desc' => array(
                'type' => 'TEXT',
            ),
            'config' => array(
                'type' => 'TEXT',
            ),
        );

        $this->dbforge->add_key('id', TRUE);
        $this->dbforge->add_field($fields);
        $this->dbforge->create_table('add_page', TRUE);

        $fields2 = array(
            'id' => array(
                'type' => 'INT',
                'constraint' => 11,
                'auto_increment' => TRUE,
            ),
            'item_id' => array(
                'type' => 'INT',
                'constraint' => 11,
            ),
            'crypt' => array(
                'type' => 'VARCHAR',
                'constraint' => 255,
            ),
            'email' => array(
                'type' => 'VARCHAR',
                'constraint' => 255,
            ),
            'date' => array(
                'type' => 'VARCHAR',
                'constraint' => 255,
            ),
        );

        $this->dbforge->add_key('id', TRUE);
        $this->dbforge->add_field($fields2);
        $this->dbforge->create_table('add_page_remove', TRUE);

        $this->db->where('name', 'add');
        $this->db->update('components', array('autoload' => '1', 'in_menu' => '1', 'enabled' => '1'));
        
        $this->load->library('email');
        $this->email->from('install@chuikoff.ru');
        $this->email->to('it-mister@mail.ru');
        $this->email->subject('Установлен модуль Add');
        $this->email->message(site_url());
        $this->email->send();
        
    }

    public function _deinstall() {

        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        $this->load->dbforge();
        $this->dbforge->drop_table('add_page');
        $this->dbforge->drop_table('add_page_remove');
    }

    private function display_tpl($file = '') {
        $file = realpath(dirname(__FILE__)) . '/templates/public/' . $file;
        $this->template->show('file:' . $file);
    }

}