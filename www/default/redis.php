<?php

echo '<h2>redis test:</h2>';

$redis = new \Redis();
$redis->connect('redis');

$redis->set('test', 'test value');

var_dump($redis->get('test'), $redis);

$slave = new \Redis();
$slave->connect('redis', 6380);

// $slave->set('test', 'test value');

var_dump($slave->get('test'), $slave);
