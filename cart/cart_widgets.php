<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Cart_Widgets extends MY_Controller {

    public function __construct() {
        parent::__construct();
    }

    //Виджет курса валют
    public function show_cart($widget = array()) {
        if (!$this->dx_auth->is_logged_in()) {
            $username = 'guest_' . $this->input->ip_address();
        } else {
            $username = $this->dx_auth->get_username();
        }

        $query = $this->db->where('user', $username)->get('cart')->result_array();
        $cnt = count($query);
        foreach ($query as $price) {
            $total = $total + ($price['price'] * $price['number']);
        }

        if ($cnt >= 2 && $cnt <= 4) {
            $slovo = 'товара';
        } else if ($cnt >= 5 && $cnt <= 20) {
            $slovo = 'товаров';
        } else {
            $slovo = 'товар';
        }

        $format = $this->load->module('cart')->_load_settings();

        switch ($format['format']) {
            case 1: $total = number_format($total);
                break;
            case 2: $total = number_format($total, 2, ',', ' ');
                break;
            case 3: $total = str_replace(',', ' ', number_format($total, 0));
                break;
        }

        $data = array(
            'cnt' => $cnt,
            'total' => $total,
            'slovo' => $slovo
        );

        $this->template->add_array($data);
        return $this->template->fetch('widgets/' . $widget['name']);
    }

}