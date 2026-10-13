<?php
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
$db = new mysqli('db', getenv('DB_USER'), getenv('DB_PASSWORD'), getenv('DB_NAME'), 3306);
if ($db->query('SHOW TABLES')->num_rows !== 0) {
    fwrite(STDERR, "Refusing to reinstall OpenCart into a nonempty database. Restore the application volume together with the database.\n");
    exit(1);
}
