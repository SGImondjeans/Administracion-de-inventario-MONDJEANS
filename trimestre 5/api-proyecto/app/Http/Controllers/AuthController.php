<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;

class AuthController extends Controller
{
    // Registro de usuario
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'NumeroDocumento' => 'required|integer|unique:usuarios,NumeroDocumento',
            'Nombre1' => 'required|string|max:45',
            'Nombre2' => 'nullable|string|max:45',
            'Apellido1' => 'required|string|max:100',
            'Apellido2' => 'nullable|string|max:45',
            'Email' => 'required|string|email|max:100|unique:usuarios,Email',
            'Contrasena' => 'required|string|min:6|max:255',
            'password_confirmation' => 'required|string|min:6|same:Contrasena',
            'FechaNacimiento' => 'required|date',
            'Direccion' => 'required|string|max:255',
            'Telefono' => 'required|string|max:15',
            'Edad' => 'required|integer|min:0|max:120',
            'Role' => 'sometimes|in:user,admin',
            'IdTipoDocumento' => 'required|integer|exists:TipoDocumento,IdTipoDocumento'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Error de validación de los datos',
                'errors' => $validator->errors(),
            ], 400);
        }

        try {
            $usuario = Usuario::create([
                'NumeroDocumento' => $request->NumeroDocumento,
                'Nombre1' => $request->Nombre1,
                'Nombre2' => $request->Nombre2,
                'Apellido1' => $request->Apellido1,
                'Apellido2' => $request->Apellido2,
                'Email' => $request->Email,
                'Contrasena' => Hash::make($request->Contrasena),
                'FechaNacimiento' => $request->FechaNacimiento,
                'Direccion' => $request->Direccion,
                'Telefono' => $request->Telefono,
                'Edad' => $request->Edad,
                'Role' => $request->Role ?? 'user',
                'IdTipoDocumento' => $request->IdTipoDocumento
            ]);

            $usuario->load('tipoDocumento');
            $usuario->makeHidden(['Contrasena']);

            return response()->json([
                'success' => true,
                'message' => 'Usuario registrado exitosamente',
                'data' => $usuario,
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al registrar el usuario',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔐 Login con JWT
// dentro de App\Http\Controllers\AuthController (reemplaza solo el método login)
public function login(Request $request)
{
    // Recolectar datos
    $emailLower = $request->input('email');
    $emailUpper = $request->input('Email');
    $numeroDoc = $request->input('NumeroDocumento');
    $passwordField = $request->input('password');
    $contrasenaField = $request->input('Contrasena');

    // Validación flexible
    $validator = Validator::make($request->all(), [
        'email' => 'nullable|email',
        'Email' => 'nullable|email',
        'NumeroDocumento' => 'nullable|integer',
        'password' => 'nullable|string',
        'Contrasena' => 'nullable|string',
    ], [
        'email.email' => 'Datos inválidos. Verifica el formato de tu email.',
        'Email.email' => 'Datos inválidos. Verifica el formato de tu email.',
    ]);

    // Debe venir al menos (email o Email o NumeroDocumento) y la contraseña
    $password = $contrasenaField ?? $passwordField;
    $identifierProvided = $emailLower || $emailUpper || $numeroDoc;

    if (!$identifierProvided || empty($password)) {
        return response()->json([
            'success' => false,
            'message' => 'Debes enviar email (o Email) o NumeroDocumento, junto con la contraseña.'
        ], 422);
    }

    if ($validator->fails()) {
        return response()->json([
            'success' => false,
            'message' => 'Datos inválidos.',
            'errors' => $validator->errors()
        ], 422);
    }

    // Buscar usuario: priorizar NumeroDocumento -> Email -> email
    if (!empty($numeroDoc)) {
        $usuario = Usuario::where('NumeroDocumento', $numeroDoc)->first();
    } else {
        $emailToSearch = $emailUpper ?? $emailLower;
        $usuario = Usuario::where('Email', $emailToSearch)->first();
    }

    if (!$usuario || !Hash::check($password, $usuario->Contrasena)) {
        return response()->json([
            'success' => false,
            'message' => 'Credenciales inválidas'
        ], 401);
    }

    try {
        $token = JWTAuth::fromUser($usuario);
    } catch (JWTException $e) {
        return response()->json([
            'success' => false,
            'message' => 'No se pudo crear el token',
            'error' => $e->getMessage()
        ], 500);
    }

    // Ocultar campos sensibles antes de retornar
    $usuario->makeHidden(['Contrasena']);

    return response()->json([
        'success' => true,
        'message' => 'Inicio de sesión exitoso',
        'user' => $usuario,
        'token' => $token
    ], 200);
}



    // 🔐 Obtener usuario autenticado
    public function getUser(Request $request)
    {
        try {
            $usuario = JWTAuth::parseToken()->authenticate();

            return response()->json([
                'success' => true,
                'user' => $usuario,
            ]);
        } catch (JWTException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Token inválido o expirado',
            ], 401);
        }
    }

    // 🔐 Cerrar sesión
    public function logout(Request $request)
    {
        try {
            JWTAuth::invalidate(JWTAuth::getToken());

            return response()->json([
                'success' => true,
                'message' => 'Sesión cerrada correctamente',
            ]);
        } catch (JWTException $e) {
            return response()->json([
                'success' => false,
                'message' => 'No se pudo cerrar la sesión',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}