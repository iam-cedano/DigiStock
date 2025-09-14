<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/hello', function () {
    return 'Hello, World!';
});

Route::get('/user/{name}', function ($name) {
    return "Hello, $name! You're awesome and the best! Buy my self-help book!";
});