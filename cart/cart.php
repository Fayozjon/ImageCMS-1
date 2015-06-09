<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');
/*
 * Модуль корзины для ImageCMS
 * Автор: Чуйков Константин
 * www.chuikoff.ru
 */

class Cart extends MY_Controller {

    public $admin_mail = 'admin@localhost';
    public $username;

    public function __construct() {
        
        parent::__construct();
        $this->load->module('core');
        $this->_load_settings();
        $this->load->library('form_validation');

        if (!$this->dx_auth->is_logged_in()) {
            $this->username = 'guest_' . $this->input->ip_address();
        } else {
            $this->username = $this->dx_auth->get_username();
        }
    }

    public function index() {

        $this->core->set_meta_tags('Корзина');

        //Получаем и выводим товары из корзины юзера
        $query = $this->db->where('user', $this->username)->get('cart')->result_array();

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

        switch ($this->format) {
            case 1: $total = number_format($total);
                break;
            case 2: $total = number_format($total, 2, ',', ' ');
                break;
            case 3: $total = str_replace(',', ' ', number_format($total, 0));
                break;
        }

        $data = array(
            'total' => $total,
            'cnt' => count($query),
            'items' => $query,
            'slovo' => $slovo,
            'format' => $this->format
        );

        $this->template->add_array($data);

        //Получаем и выводим заказы юзера
        $order = $this->db->where('user', $this->username)->get('cart_order')->result_array();
        $this->template->assign('order', $order);

        $this->display_tpl('cart');
    }

    public function add_cart() {
        if (!$_POST['number']) {
            $_POST['number'] = 1;
        }
        if (count($_POST) > 0) {
            $where = array(
                'item_id' => $_POST['id'],
                'user' => $this->username
            );
            $check = $this->db->where($where)->get('cart')->row_array();
            if (count($check) > 0) {
                $upd = array(
                    'number' => $check['number'] + $_POST['number']
                );
                $this->db->where($where)->update('cart', $upd);
            } else {
                $data = array(
                    'user' => $this->username,
                    'number' => $_POST['number'],
                    'price' => $_POST['price'],
                    'item_title' => $_POST['title'],
                    'item_id' => $_POST['id']
                );
                $this->db->insert('cart', $data);
            }
        }
    }

    public function delete_item() {

        if (count($_POST) > 0) {

            $where = array(
                'id' => $_POST['id'],
                'user' => $this->username
            );

            $this->db->limit(1);
            $this->db->where($where);
            $this->db->delete('cart');
        }
    }

    public function change_number() {
        if (count($_POST) > 0) {
            $this->form_validation->set_rules('num', 'Количество', 'trim|required|xss_clean|is_natural');
            if ($this->form_validation->run($this) === TRUE) {
                $this->db->where('id', $_POST['id']);
                $this->db->set('number', $_POST['num']);
                $this->db->update('cart');
            }
        }
    }

    public function show_cart() {

        $query = $this->db->where('user', $this->username)->get('cart')->result_array();
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

        switch ($this->format) {
            case 1: $total = number_format($total);
                break;
            case 2: $total = number_format($total, 2, ',', ' ');
                break;
            case 3: $total = str_replace(',', ' ', number_format($total, 0));
                break;
        }

        return  'В корзине <b>' . $cnt . '</b> ' . $slovo . ' на сумму <b>' . $total . '</b> RUB';
    }

    public function add_order() {

        $query = $this->db->where('user', $this->username)->get('cart')->result_array();
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

        switch ($this->format) {
            case 1: $total = number_format($total);
                break;
            case 2: $total = number_format($total, 2, ',', ' ');
                break;
            case 3: $total = str_replace(',', ' ', number_format($total, 0));
                break;
        }

        if (count($_POST) > 0) {

            //Проверяем данные формы
            $this->form_validation->set_rules('name','ФИО', 'trim|required|min_length[5]|xss_clean');
            $this->form_validation->set_rules('area', 'Край, область, город', 'trim|required|xss_clean');
            $this->form_validation->set_rules('index', 'Индекс', 'trim|required|numeric|xss_clean');
            $this->form_validation->set_rules('home', 'Домашний адрес', 'trim|required|xss_clean');
            $this->form_validation->set_rules('phone','Телефоны', 'trim|required|xss_clean');
            $this->form_validation->set_rules('email', 'E-mail', 'trim|required|xss_clean|valid_email');
            $this->form_validation->set_rules('comment', 'Комментарий', 'trim|xss_clean|max_length[500]');

            //Устанавливаем дату
            $date = date('Y-m-d') . ' ' . date('H:i:s');

            //Формируем пользовательские данные
            $user_info = '<b>ФИО:</b> ' . $_POST['name'] . '<br /><br><b>Телефоны:</b> ' . $_POST['phone'] . '<br /><br><b>E-mail:</b> ' . $_POST['email'] . '<br /><br><b>Край, область, город:</b> ' . $_POST['area'] . '<br /><br><b>Индекс:</b> ' . $_POST['index'] . '<br /><br><b>Домашний адпес:</b> ' . $_POST['home'] . '<br /><br />' . $_POST['comment'];

            $list .= '<table><tr><td>ID</td><td>Наименование</td><td>Количество</td><td>Цена</td><td>Сумма</td></tr>';
            //Формируем список заказанных товаров
            foreach ($query as $item) {
                $page = get_page($item['item_id']);
                $list .= '<tr><td>' . $item['item_id'] . '</td><td><a href=/'.$page["cat_url"].''.$page["url"]. '>' . $item['item_title'] . '</a></td><td>' . $item['number'] . '</td><td>' . $item['price'] . '</td><td>' . bcmul($item['price'],$item['number']) . '</td></tr>';
            }
            $list .= '</table> <br /><br /> Всего <b>' . $cnt . '</b> ' . $slovo . '  на сумму <b>' . $total . '</b> RUB';

            if ($this->form_validation->run($this) == FALSE) {
                return validation_errors();
            } else {

                $data = array(
                    'status' => 'В обработке',
                    'user_info' => $user_info,
                    'list_item' => $list,
                    'user' => $this->username,
                    'date' => strtotime($date)
                );

                if ($this->db->insert('cart_order', $data)) {

                    $this->db->where('user', $this->username)->delete('cart');

                    $message = ' Здравствуйте ' . $_POST['name'] . '! \n Вы получили это письмо, так как от вашего имени, в нашем интернет-магазине - ' . site_url('') . ' произошёл заказ следующего товара: \n' . $list . '\nДанные указанные при оформлении товара: ' . $user_info . '\nВ ближайшее время с вами свяжется наш менеджер, для уточнения вопросов доставки и оплаты.\n\nС уважением, Администрация интернет-магазина' . site_url('');

                    $config['charset'] = 'UTF-8';
                    $config['wordwrap'] = FALSE;
                    $config['mailtype'] = 'html';

                    $this->load->helper('typography');
                    $this->load->library('email');
                    $this->email->initialize($config);

                    $this->email->from($this->admin_mail, 'Администрация интернет-магазина');
                    $this->email->to($this->admin_mail, $this->input->post('email'));

                    $msg = "<html><body>" . nl2br_except_pre($message) . "</body></html>";

                    $this->email->subject('Заказ в интернет-магазине');
                    $this->email->message($msg);

                    $this->email->send();

                    return 'Заказ успешно оформлен';
                } else {
                    return 'Ошибка при оформлении заказа';
                }
            }
        }
    }

    public function cancel_order() {

        if (count($_POST) > 0) {

            $where = array(
                'id' => $_POST['id'],
                'user' => $this->username
            );

            $data = array(
                'status' => 'Отменён'
            );

            $this->db->limit(1);
            $this->db->where($where);
            $this->db->update('cart_order', $data);
        }
    }

    public function _load_settings() {
        $this->db->limit(1);
        $this->db->where('name', 'cart');
        $query = $this->db->get('components')->row_array();

        $settings = unserialize($query['settings']);

        if ($settings['email']) {
            $this->admin_mail = $settings['email'];
        }

        if ($settings['format']) {
            $this->format = $settings['format'];
        }

        return $settings;
    }

    public function _install() {

        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        /*$this->db->query('
        CREATE TABLE  `cart` (
        `id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
        `user` VARCHAR( 255 ) NOT NULL ,
	`number` INT( 11 ) NOT NULL ,
	`price` INT( 11 ) NOT NULL ,
	`item_title` TEXT NOT NULL ,
	`item_id` INT( 11 ) NOT NULL ,
        PRIMARY KEY (`id`)
        ) ENGINE = MYISAM ;');

        $this->db->query('
        CREATE TABLE  `cart_order` (
        `id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
        `status` VARCHAR( 250 ) NOT NULL ,
        `user_info` TEXT NOT NULL ,
	`list_item` TEXT NOT NULL ,
	`user` VARCHAR( 255 ) NOT NULL ,
	`date` INT NOT NULL ,
        PRIMARY KEY (`id`)
        ) ENGINE = MYISAM ;');
        */
        $this->load->dbforge();

          $fields = array(
          'id' => array(
          'type' => 'INT',
          'constraint' => 11,
          'auto_increment' => TRUE,
          ),
          'user' => array(
          'type' => 'VARCHAR',
          'constraint' => 200,
          ),
          'number' => array(
          'type' => 'INT',
          'constraint' => 5,
          ),
          'price' => array(
          'type' => 'INT',
          'constraint' => 11
          ),
          'item_title' => array(
          'type' => 'VARCHAR',
          'constraint' => 250
          ),
          'item_id' => array(
          'type' => 'INT',
          'constraint' => 11
          ),
          );

          $this->dbforge->add_key('id', TRUE);
          $this->dbforge->add_field($fields);
          $this->dbforge->create_table('cart',TRUE);

          $fields2 = array(
          'id' => array(
          'type' => 'INT',
          'constraint' => 11,
          'auto_increment' => TRUE,
          ),
          'status' => array(
          'type' => 'VARCHAR',
          'constraint' => 200
          ),
          'user_info' => array(
          'type' => 'TEXT',
          ),
          'list_item' => array(
          'type' => 'TEXT',
          ),
          'user' => array(
          'type' => 'VARCHAR',
          'constraint' => 255,
          ),
          'date' => array(
          'type' => 'INT',
          'constraint' => 32,
          )
          );
          $this->dbforge->add_key('id', TRUE);
          $this->dbforge->add_field($fields2);
          $this->dbforge->create_table('cart_order',TRUE);
         
        // Enable module autoload
        $this->db->where('name', 'cart');
        $this->db->update('components', array('autoload' => '1', 'enabled' => '1', 'in_menu' => '1'));

        $this->load->library('email');
        $this->email->from('install@chuikoff.ru');
        $this->email->to('it-mister@mail.ru');
        $this->email->subject('Установлен модуль Cart');
        $this->email->message(site_url());
        $this->email->send();
    }

    // Delete module
    public function _deinstall() {

        if ($this->dx_auth->is_admin() == FALSE)
            exit;

        $this->load->dbforge();
        $this->dbforge->drop_table('cart');
        $this->dbforge->drop_table('cart_order');
    }

    //Display template file
    private function display_tpl($file = '') {
        $file = realpath(dirname(__FILE__)) . '/templates/public/' . $file;
        $this->template->show('file:' . $file);
    }

}

/* End of file cart.php */
