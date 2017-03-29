<?php

$egn = new Egn\Validate('5906136763');

echo "Валидиране на: ".$egn->getEgn().PHP_EOL;
echo $egn->isValid()?"Валидно":"Невалидно";
echo PHP_EOL;
echo $egn->getIsMale()?"Мъж":"";
echo $egn->getIsFemale()?"Жена":"";
echo PHP_EOL;
echo $egn->getRegion().PHP_EOL;
echo "Роден на:".PHP_EOL;
echo $egn->getBirthDay()." ".$egn->getBirthMonth()." ".$egn->getBirthYear()."година";
echo PHP_EOL;



?>
