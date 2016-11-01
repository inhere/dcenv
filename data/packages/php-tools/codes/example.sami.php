<?php
/**
 * config for sami
 * `vendor/bin/sami.phar`
 * use to generate api doc.
 */

define('PROJECT_PATH', dirname(__DIR__));

// var_dump(getcwd());
$iterator = Symfony\Component\Finder\Finder::create()
    ->files()
    ->name('*.php')
    ->in( $dir = PROJECT_PATH . '/vendor/ugirls/ugirls/' )
;

//$versions = Sami\Version\GitVersionCollection::create(PROJECT_PATH . '/docs/git-cache/')
$versions = Sami\Version\GitVersionCollection::create($dir)
    ->add('master')
;

return new Sami\Sami($iterator, array(
//    'theme'                => 'enhanced',
    'versions'             => $versions,
    'title'                => 'Ugirls API Documentation',
    'build_dir'            => PROJECT_PATH.'/docs/sami/output/%version%',
    'cache_dir'            => PROJECT_PATH.'/app/runtime/cache/%version%',
    'default_opened_level' => 2,
    // 'store'                => new MyArrayStore,
));