<?php

echo '<h2>use Memcache:</h2>';

$mem = new \Memcache();
$mem->addserver('memcached');

$value = ['key' => 'test 2222'];
$mem->set('test', $value, MEMCACHE_COMPRESSED, 60);

var_dump($mem->get('test'), $mem);

echo '<h2>use Memcached:</h2>';

$m1 = new \Memcached();
$m1->addserver('memcached', 11211);

$m1->set('test1', $value, 60);
// $m1->set('test1', serialize($value), 60);

var_dump($m1->get('test1'), $m1);