<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Click extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->module('core');
        $this->load->helper('download');
    }

    public function to($id = null) 
    {
        $this->db->where('id', $id);
        $link = $this->db->get('click')->row_array();
        if($link)
        {
            $count = $link['count'] + 1;
            $this->db->where('id', $link['id'])->set('count', $count)->update('click');
            if(preg_match("#http://#", $link['link']))
            {
                redirect($link['link']);
            }
            else
            {
                $data = file_get_contents(site_url().$link['link']);
                $name = str_replace("\\","",strrchr($link['link'],"\\"));
                force_download($name, $data);
            }
        }
        else
        {
            $this->core->error_404();
        }
    }

    public function get_count($identif,$type = 'link') {
        $this->db->select('count');
        if($type=='id')
        {
            $this->db->where('id', $identif);
        }
        else
        {
            $this->db->where('link', $identif);
        }
        $count = $this->db->get('click')->row_array();
        return $count['count'];
    }

    public function link($identif = null) {
        $this->db->where('link', $identif);
        $result = $this->db->get('click')->row_array();
        
        if(count($result)==0)
        {
            $data = array(
                'link' => $identif,
                'type' => 'link',
                'title' => 'Скачать'
            );
            
            $this->db->insert('click',$data);
            $this->link($identif);
        }
        
        return $result;
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
                'type' => 'varchar',
                'constraint' => 11,
            ),
            'category' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'title' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'image' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'link' => array(
                'type' => 'varchar',
                'constraint' => 255,
            ),
            'count' => array(
                'type' => 'INT',
                'constraint' => 11,
                'default' => 0
            ),
        );

        $this->dbforge->add_key('id', TRUE);
        $this->dbforge->add_field($fields);
        $this->dbforge->create_table('click', TRUE);

        $this->db->where('name', 'click');
        $this->db->update('components', array('autoload' => '1', 'enabled' => '1', 'in_menu' => '1'));
        
        $this->load->library('email');
        $this->email->from('install@chuikoff.ru');
        $this->email->to('it-mister@mail.ru');
        $this->email->subject('Установлен модуль Click');
        $this->email->message(site_url());
        $this->email->send();
    }

    public function _deinstall() {
        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        $this->load->dbforge();
        $this->dbforge->drop_table('click');
    }

    private function display_tpl($file = '') {
        $file = realpath(dirname(__FILE__)) . '/templates/public/' . $file . '.tpl';
        $this->template->display('file:' . $file);
    }

}