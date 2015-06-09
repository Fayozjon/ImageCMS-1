<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Rating extends MY_Controller {

    public $user_ip, $style;

    public function __construct() {
        parent::__construct();
        $this->load->module('core');
        $this->user_ip = $this->input->ip_address();
        switch ($this->load_settings())
        {
            case 1: $file = "/application/modules/rating/templates/css/rating.css";                break;
            case 2: $file = "/application/modules/rating/templates/css/rating_2.css";                break;
            case 3: $file = "/application/modules/rating/templates/css/rating_1.css";                break;
            default : $file = "/application/modules/rating/templates/css/rating.css";
        }
        $this->template->registerCssFile($file);
        $this->template->registerJsFile('/application/modules/rating/templates/js/rating.js');
    }
	
	public function autoload() {
        
    }
    
    private function load_settings()
    {
        $this->db->limit(1);
        $this->db->where('name', 'rating');
        $query = $this->db->get('components');

        if ($query->num_rows() == 1) {
            $query = $query->row_array();
            $set = unserialize($query['settings']);
            return $set['style'];
        }
    }

    public function index() {
        $this->core->error_404();
    }

    public function up() {

        if (count($_POST) > 0) {
            $param = array(
                'user_ip' => $this->user_ip,
                'item_id' => $_POST['item_id'],
                'type' => $_POST['type']
            );
            $ip_ban = $this->db->where($param)->get('rate')->result();
            if (count($ip_ban) > 0) {
                return 3;
            } else {
                $data = array(
                    'item_id' => $_POST['item_id'],
                    'user_ip' => $this->user_ip,
                    'type' => $_POST['type'],
                    'rating' => '1'
                );
                if ($this->db->insert('rate', $data)) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else {
            $this->core->error_404();
        }
    }

    public function down() {
        if (count($_POST) > 0) {
            $param = array(
                'user_ip' => $this->user_ip,
                'item_id' => $_POST['item_id'],
                'type' => $_POST['type']
            );
            $ip_ban = $this->db->where($param)->get('rate')->result_array();
            if (count($ip_ban) > 0) {
                return 3;
            } else {
                $data = array(
                    'item_id' => $_POST['item_id'],
                    'user_ip' => $this->user_ip,
                    'type' => $_POST['type'],
                    'rating' => '-1'
                );
                if ($this->db->insert('rate', $data)) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else {
            $this->core->error_404();
        }
    }

    public function show($item_id = null, $type = '') {
        $where = array(
            'item_id' => $item_id,
            'type' => $type
        );
        $rate = $this->db->select('rating')->where($where)->get('rate')->result_array();
        
        $rating = 0;
        
        foreach ($rate as $r) 
        {
            $rating = $rating + $r['rating'];
        }
        
        if($rating>0)
        {
            $class = " class='green'";
        }
        else if($rating<0)
        {
            $class = " class='red'";
        }
        
        $html = <<<HERE
   
        <div class='rating'>
            <i class='icon-minus' onClick="Rat.down($item_id,'$type',this);"></i> 
            <b$class>$rating</b> 
            <i class='icon-plus' onClick="Rat.up($item_id,'$type',this);"></i>
        </div>
HERE;
        
        echo $html;
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
            'type' => array(
                'type' => 'VARCHAR',
                'constraint' => 255,
            ),
            'item_id' => array(
                'type' => 'INT',
                'constraint' => 11,
            ),
            'user_ip' => array(
                'type' => 'CHAR',
                'constraint' => 16,
            ),
            'rating' => array(
                'type' => 'INT',
                'constraint' => 2,
            )
        );

        $this->dbforge->add_key('id', TRUE);
        $this->dbforge->add_field($fields);
        $this->dbforge->create_table('rate', TRUE);

        $this->db->where('name', 'rating');
        $this->db->update('components', array('autoload' => '1', 'enabled' => '1'));
        
        $this->load->library('email');
        $this->email->from('install@chuikoff.ru');
        $this->email->to('it-mister@mail.ru');
        $this->email->subject('Установлен модуль Rating');
        $this->email->message(site_url());
        $this->email->send();
    }

    public function _deinstall() {

        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        $this->load->dbforge();
        $this->dbforge->drop_table('rate');
    }
}
