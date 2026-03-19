<?php

namespace App\Http\Controllers;

use App\Models\Compra;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CompraController extends Controller
{
    /**
     * Verificar si el usuario es admin o empleado
     */
    private function checkEmployeeAccess()
    {
        $user = auth('api')->user();

        if (!$user || !in_array($user->Role, ['admin', 'usuario','user'])) {
            return response()->json([
                'success' => false,
                'message' => 'Acceso denegado. Solo empleados y administradores.',
            ], 403);
        }

        return null;
    }

    /**
     * Obtener compras
     */
    public function getCompras(Request $request)
    {
        $employeeCheck = $this->checkEmployeeAccess();
        if ($employeeCheck) return $employeeCheck;

        try {
            $query = Compra::with([
                'proveedor:IdProveedor,NombreProveedor',
                'usuario:NumeroDocumento,Nombre1,Apellido1'
            ]);

            if ($request->has('fecha_desde')) {
                $query->whereDate('FechaCompra', '>=', $request->fecha_desde);
            }
            if ($request->has('fecha_hasta')) {
                $query->whereDate('FechaCompra', '<=', $request->fecha_hasta);
            }
            if ($request->has('estado')) {
                $query->where('Estado', $request->estado);
            }
            if ($request->has('proveedor')) {
                $query->where('IdProveedor', $request->proveedor);
            }

            $compras = $query->orderBy('FechaCreacion', 'desc')->get();

            return response()->json([
                'success' => true,
                'message' => 'Compras obtenidas exitosamente',
                'data' => $compras
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener las compras',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear compra
     */
    public function addCompra(Request $request)
    {
        $employeeCheck = $this->checkEmployeeAccess();
        if ($employeeCheck) return $employeeCheck;

        $estadoMap = [
            'Pendiente' => 'pendiente',
            'En Proceso' => 'recibida',
            'Completada' => 'recibida',
            'Cancelada' => 'cancelada'
        ];

        $validator = Validator::make($request->all(), [
            'IdProveedor' => 'required|exists:proveedores,IdProveedor',
            'FechaCompra' => 'required|date',
            'Total' => 'required|numeric|min:0',
            'Estado' => 'required|string',
            'NumeroDocumentoUsuario' => 'required|string|exists:usuarios,NumeroDocumento'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Error de validación',
                'errors' => $validator->errors()
            ], 400);
        }

        try {
            $estadoDB = $estadoMap[$request->Estado] ?? 'pendiente';

            $compra = Compra::create([
                'IdProveedor' => $request->IdProveedor,
                'NumeroDocumentoUsuario' => $request->NumeroDocumentoUsuario,
                'FechaCompra' => $request->FechaCompra,
                'Total' => $request->Total,
                'Estado' => $estadoDB
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Compra creada exitosamente',
                'data' => $compra
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al crear la compra',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Actualizar compra
     */
    public function updateCompra(Request $request, $id)
    {
        $employeeCheck = $this->checkEmployeeAccess();
        if ($employeeCheck) return $employeeCheck;

        $estadoMap = [
            'Pendiente' => 'pendiente',
            'En Proceso' => 'recibida',
            'Completada' => 'recibida',
            'Cancelada' => 'cancelada'
        ];

        $validator = Validator::make($request->all(), [
            'IdProveedor' => 'required|exists:proveedores,IdProveedor',
            'FechaCompra' => 'required|date',
            'Total' => 'required|numeric|min:0',
            'Estado' => 'required|string',
            'NumeroDocumentoUsuario' => 'required|string|exists:usuarios,NumeroDocumento'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Error de validación',
                'errors' => $validator->errors()
            ], 400);
        }

        try {
            $compra = Compra::find($id);

            if (!$compra) {
                return response()->json([
                    'success' => false,
                    'message' => 'Compra no encontrada'
                ], 404);
            }

            $estadoDB = $estadoMap[$request->Estado] ?? 'pendiente';

            $compra->update([
                'IdProveedor' => $request->IdProveedor,
                'NumeroDocumentoUsuario' => $request->NumeroDocumentoUsuario,
                'FechaCompra' => $request->FechaCompra,
                'Total' => $request->Total,
                'Estado' => $estadoDB
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Compra actualizada exitosamente',
                'data' => $compra
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar la compra',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Eliminar compra
     */
    public function deleteCompra($id)
    {
        $employeeCheck = $this->checkEmployeeAccess();
        if ($employeeCheck) return $employeeCheck;

        try {
            $compra = Compra::find($id);

            if (!$compra) {
                return response()->json([
                    'success' => false,
                    'message' => 'Compra no encontrada'
                ], 404);
            }

            if ($compra->Estado !== 'pendiente') {
                return response()->json([
                    'success' => false,
                    'message' => 'Solo se pueden eliminar compras en estado pendiente'
                ], 400);
            }

            $compra->delete();

            return response()->json([
                'success' => true,
                'message' => 'Compra eliminada exitosamente'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al eliminar la compra',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener compra por ID
     */
    public function getCompraById($id)
    {
        $employeeCheck = $this->checkEmployeeAccess();
        if ($employeeCheck) return $employeeCheck;

        try {
            $compra = Compra::with([
                'proveedor:IdProveedor,NombreProveedor,Contacto,Telefono,Email',
                'usuario:NumeroDocumento,Nombre1,Apellido1'
            ])->find($id);

            if (!$compra) {
                return response()->json([
                    'success' => false,
                    'message' => 'Compra no encontrada'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Compra encontrada',
                'data' => $compra
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener la compra',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
