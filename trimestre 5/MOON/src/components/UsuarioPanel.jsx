import React, { useState, useEffect } from "react";
import Navbar from "./NavbarUsuario";
import Modulo from "./Modulo";
import AuthService from "../services/authService";
import "../css/UsuarioPanel.css";

// Configuración de la API
const API_BASE_URL = 'http://127.0.0.1:8000/api';

export default function UsuarioPanel({ userData }) {
  // Estados
  const [modulos, setModulos] = useState([]);
  const [permisos, setPermisos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Obtener información del usuario
  const user = userData || AuthService.getUserData();
  const userName = user?.name || user?.username || user?.email || 'Usuario';

  // Función para obtener el token
  const getToken = () => {
    return localStorage.getItem('authToken') || sessionStorage.getItem('authToken');
  };

  // Fetch de módulos y permisos
  useEffect(() => {
    const fetchModulosYPermisos = async () => {
      setLoading(true);
      setError(null);
      
      try {
        const token = getToken();
        
        if (!token) {
          throw new Error('No hay token de autenticación');
        }

        const headers = {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        };

        // Llamadas paralelas a la API
        const [modulosResponse, permisosResponse] = await Promise.all([
          fetch(`${API_BASE_URL}/modulos`, { headers }),
          fetch(`${API_BASE_URL}/permisos/mis-permisos`, { headers })
        ]);

        // Verificar errores de autenticación
        if (modulosResponse.status === 401 || permisosResponse.status === 401) {
          localStorage.removeItem('authToken');
          sessionStorage.removeItem('authToken');
          window.location.href = '/';
          return;
        }

        if (!modulosResponse.ok || !permisosResponse.ok) {
          throw new Error('Error al cargar los datos');
        }

        const modulosData = await modulosResponse.json();
        const permisosData = await permisosResponse.json();

        // Extraer los arrays de datos
        const modulosArray = modulosData.data || modulosData || [];
        const permisosArray = permisosData.data || permisosData || [];

        setModulos(modulosArray);
        setPermisos(permisosArray);
      } catch (err) {
        console.error('Error al cargar módulos y permisos:', err);
        setError(err.message || 'Error al cargar los datos');
      } finally {
        setLoading(false);
      }
    };

    fetchModulosYPermisos();
  }, []);

  // Filtrar módulos permitidos
  const modulosPermitidos = modulos.filter(modulo => 
    permisos.some(p => p.IdModulo === modulo.IdModulo && p.TieneAcceso)
  );

  // Módulos predeterminados (siempre visibles)
  const modulosPredeterminados = [
    {
      id: 'cuenta',
      imgSrc: "img/usuario.png",
      alt: "Cuenta",
      title: "Mi Cuenta",
      description: "Edita tu información personal.",
      link: "/cuenta",
      imgWidth: "100"
    },
    {
      id: 'permisos',
      imgSrc: "img/permisos.jpeg",
      alt: "Permisos",
      title: "Pedir Permiso",
      description: "Solicita acceso a nuevos módulos o funciones del sistema.",
      link: "/mis-permisos",
      imgWidth: "105"
    }
  ];

  return (
    <>
      <Navbar usuario userData={user} />
      <main className="bienvenida">
        <h1>Bienvenido al Panel de Usuario</h1>
        <p>
          Hola <strong>{userName}</strong>, has iniciado sesión como <strong>Usuario</strong>. 
          {" "}Si necesitas más acceso, puedes solicitar permisos al administrador.
        </p>

        {/* Mensaje de error si hay problemas */}
        {error && (
          <div style={{
            backgroundColor: '#fee',
            border: '1px solid #fcc',
            borderRadius: '8px',
            padding: '12px 16px',
            marginBottom: '20px',
            color: '#c33'
          }}>
            <strong>⚠️ Error:</strong> {error}
          </div>
        )}

        {/* Indicador de carga */}
        {loading && (
          <div style={{
            textAlign: 'center',
            padding: '40px',
            color: '#666'
          }}>
            <div style={{
              border: '4px solid #f3f3f3',
              borderTop: '4px solid #3498db',
              borderRadius: '50%',
              width: '40px',
              height: '40px',
              animation: 'spin 1s linear infinite',
              margin: '0 auto 16px'
            }}></div>
            <p>Cargando tus módulos...</p>
          </div>
        )}

        {/* Módulos */}
        {!loading && (
          <>
            {/* Módulos predeterminados */}
            <div className="modulos">
              {modulosPredeterminados.map(modulo => (
                <Modulo
                  key={modulo.id}
                  imgSrc={modulo.imgSrc}
                  alt={modulo.alt}
                  title={modulo.title}
                  description={modulo.description}
                  link={modulo.link}
                  imgWidth={modulo.imgWidth}
                />
              ))}
            </div>

            {/* Módulos permitidos por permisos */}
            {modulosPermitidos.length > 0 && (
              <>
                <h2 style={{ 
                  marginTop: '40px', 
                  marginBottom: '20px',
                  color: '#333',
                  borderBottom: '2px solid #10B981',
                  paddingBottom: '10px'
                }}>
                  🔓 Módulos Disponibles ({modulosPermitidos.length})
                </h2>
                <div className="modulos">
                  {modulosPermitidos.map(modulo => (
                    <Modulo
                      key={modulo.IdModulo}
                      imgSrc={modulo.UrlImagen || "img/modulo-default.png"}
                      alt={modulo.NombreModulo}
                      title={modulo.NombreModulo}
                      description={modulo.Descripcion}
                      link={modulo.RutaAcceso || `/modulo/${modulo.IdModulo}`}
                      imgWidth="100"
                    />
                  ))}
                </div>
              </>
            )}

            {/* Mensaje cuando no hay módulos permitidos */}
            {!loading && modulosPermitidos.length === 0 && (
              <div style={{
                backgroundColor: '#f8f9fa',
                border: '2px dashed #dee2e6',
                borderRadius: '12px',
                padding: '40px',
                textAlign: 'center',
                marginTop: '40px',
                color: '#6c757d'
              }}>
                <div style={{ fontSize: '48px', marginBottom: '16px' }}>🔒</div>
                <h3 style={{ color: '#495057', marginBottom: '12px' }}>
                  No tienes módulos adicionales disponibles
                </h3>
                <p style={{ marginBottom: '20px' }}>
                  Solicita permisos al administrador para acceder a más funcionalidades
                </p>
                <a 
                  href="/mis-permisos" 
                  style={{
                    display: 'inline-block',
                    backgroundColor: '#10B981',
                    color: 'white',
                    padding: '12px 24px',
                    borderRadius: '8px',
                    textDecoration: 'none',
                    fontWeight: 'bold',
                    transition: 'background-color 0.3s'
                  }}
                  onMouseOver={(e) => e.target.style.backgroundColor = '#059669'}
                  onMouseOut={(e) => e.target.style.backgroundColor = '#10B981'}
                >
                  Solicitar Permisos
                </a>
              </div>
            )}
          </>
        )}
      </main>

      {/* CSS para la animación de carga */}
      <style>{`
        @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }
      `}</style>
    </>
  );
}