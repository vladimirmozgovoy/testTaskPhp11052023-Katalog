<?php
/**Задача №2
 * Проведите рефакторинг, исправьте баги и продокументируйте в стиле PHPDoc код, приведённый ниже (таблица users здесь аналогична таблице users из задачи №1).
 * Примечание: код написан исключительно в тестовых целях, это не "жизненный пример" :)
 * Плюсом будет, если укажете, какие именно уязвимости присутствуют в исходном варианте (если таковые, на ваш взгляд, имеются), и приведёте примеры их проявления.
 */
function load_users_data(string $userIds)
{
    $userIds = explode(',', $userIds);
    foreach ($userIds as $user_id) {
        $db = mysqli_connect("localhost", "root", "123123", "database");
        $sql = mysqli_query($db, "SELECT * FROM users WHERE id=$user_id");
        while ($obj = $sql->fetch_object()) {
            $data[$user_id] = $obj->name;
        }
        mysqli_close($db);
    }
    return $data;
}

// Как правило, в $_GET['user_ids'] должна приходить строка
// с номерами пользователей через запятую, например: 1,2,17,48
$data = load_users_data($_GET['user_ids']);
foreach ($data as $user_id => $name) {
    echo "<a href=\"/show_user.php?id=$user_id\">$name</a>";
}

/** Ошибки
 *
 */


/**
 * Ошибки в данной задаче
 * 1.Через цикл производится подключение к БД ,а также выборка пользователей , выборку пользователей нужно использоваться через WHERE IN
 * 2.Не правильно выполнена конкатенация в формировании ссылок пользователей
 * 3.Нарушение единной ответсвенности в методе.
 * 4.Наименование методов не по PSR
 * 5.Выполняется в цикле вывод строки , а нужно выводить один раз.
 * Уязвимости в коде
 * 1.Любые манипуляции с БД нужно выполнять через PDO
 * 2.Данные к подключению к БД нужно хранить в отдельном файле
 */


/** Решение  */
/**
 * @return PDO
 */
function connectToDB(): PDO
{
    try {
        return new PDO('mysql:host=localhost;dbname=database', 'root', '123123');
    } catch (PDOException $e) {
        print "Error!: " . $e->getMessage();
        die();
    }
}

/**
 * @param PDO $pdo
 * @return void
 */
function closeConnection(PDO $pdo)
{
    //Kill the connection with a KILL Statement.
    $pdo->query('KILL CONNECTION_ID()');

//Set the PDO object to NULL.
    $pdo = null;
}

/**
 * @param PDO $pdo
 * @param string $userIds
 * @return array|null
 */
function getUsers(PDO $pdo, string $userIds): ?array
{
    try {
        $userIds = explode(',', $userIds);
        $in = str_repeat('?,', count($userIds) - 1) . '?';
        $sql = "SELECT * FROM categories WHERE `id` IN ($in)";
        $stm = $pdo->prepare($sql);
        $stm->execute($userIds);
        return $stm->fetchAll();
    } catch (PDOException $e) {
        print "Error!: " . $e->getMessage();
        die();
    }
}

$pdo = connectToDb();
$users = getUsers($pdo, (string)$_GET['user_ids']);
closeConnection($pdo);
$result = "";
foreach ($users as $user) {
    $userId = $user['id'];
    $name = $user['name'];
    $result = '<a href="/show_user.php?id=' . $userId . '\'>' . $name . '</a></br>' . $result;
}
echo $result;







