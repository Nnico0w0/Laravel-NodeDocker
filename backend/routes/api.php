<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

Route::get('/test', function () {
    try {
        // Test database connection
        DB::connection()->getPdo();
        $dbStatus = 'Conectado a PostgreSQL ✓';
    } catch (\Exception $e) {
        $dbStatus = 'Error de conexión a la base de datos: ' . $e->getMessage();
    }
    
    return response()->json([
        'message' => '¡Backend Laravel funcionando correctamente!',
        'database' => $dbStatus,
        'timestamp' => now()->toDateTimeString(),
        'environment' => config('app.env')
    ]);
});

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');
