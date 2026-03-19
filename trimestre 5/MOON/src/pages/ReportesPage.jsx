import React, { useState, useEffect } from 'react';
import { AlertCircle, TrendingUp, Package, DollarSign, ShoppingCart, BarChart3, Calendar, RefreshCw } from 'lucide-react';
import axios from 'axios';

const API_BASE_URL = 'http://localhost:8000/api';

// Configurar interceptor para Axios
axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('authToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Navbar Component
const NavbarAdmin = ({ userData }) => {
  const user = userData || { name: 'Administrador' };
  const userName = user?.name || user?.username || user?.email || 'Administrador';

  const handleLogout = () => {
    const confirmLogout = window.confirm('¿Estás seguro de que quieres cerrar sesión?');
    if (confirmLogout) {
      console.log('🚪 Cerrando sesión del administrador...');
    }
  };

  return (
    <nav className="navbar navbar-expand-lg navbar-light bg-white shadow-sm border-bottom">
      <div className="container-fluid">
        <a className="navbar-brand fw-bold d-flex align-items-center text-dark" href="/admin">
          <div 
            style={{
              width: '40px',
              height: '40px',
              backgroundColor: '#3B82F6',
              borderRadius: '8px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              marginRight: '12px'
            }}
          >
            <span style={{ color: 'white', fontWeight: 'bold', fontSize: '16px' }}>A</span>
          </div>
          Panel Administrador
        </a>

        <button
          className="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navAdmin"
        >
          <span className="navbar-toggler-icon"></span>
        </button>

        <div className="collapse navbar-collapse" id="navAdmin">
          <ul className="navbar-nav me-auto mb-2 mb-lg-0">
            <li className="nav-item">
              <a className="nav-link text-dark" href="/admin">
                <i className="bi bi-speedometer2 me-1"></i>
                Dashboard
              </a>
            </li>
            <li className="nav-item">
              <a className="nav-link text-dark" href="/inventario">
                <i className="bi bi-boxes me-1"></i>
                Inventario
              </a>
            </li>
            <li className="nav-item">
              <a className="nav-link text-dark" href="/ventas">
                <i className="bi bi-cart-check me-1"></i>
                Ventas
              </a>
            </li>
            <li className="nav-item">
              <a className="nav-link active text-primary fw-bold" href="/reportes">
                <i className="bi bi-graph-up me-1"></i>
                Reportes
              </a>
            </li>
            <li className="nav-item">
              <a className="nav-link text-dark" href="/proveedores">
                <i className="bi bi-truck me-1"></i>
                Proveedores
              </a>
            </li>
          </ul>

          <div className="d-flex align-items-center">
            <span className="navbar-text me-3 d-none d-md-inline text-muted">
              <i className="bi bi-shield-check me-1 text-secondary"></i>
              Admin: <strong className="text-secondary">{userName}</strong>
            </span>
            <button
              className="btn btn-outline-danger"
              onClick={handleLogout}
            >
              <i className="bi bi-box-arrow-right me-1"></i>
              Cerrar Sesión
            </button>
          </div>
        </div>
      </div>
    </nav>
  );
};

// Stat Card Component
const StatCard = ({ title, value, icon: Icon, color, subtitle }) => (
  <div className="card shadow-sm border-0 h-100">
    <div className="card-body">
      <div className="d-flex align-items-center justify-content-between mb-3">
        <div className={`bg-${color} bg-opacity-10 rounded-3 p-3`}>
          <Icon className={`text-${color}`} size={24} />
        </div>
      </div>
      <h6 className="text-muted mb-2">{title}</h6>
      <h3 className="fw-bold mb-0">{value}</h3>
      {subtitle && <small className="text-muted">{subtitle}</small>}
    </div>
  </div>
);

// Products Table Component
const ProductosPopulares = ({ productos }) => (
  <div className="card shadow-sm">
    <div className="card-header bg-light">
      <div className="d-flex align-items-center">
        <div className="bg-primary bg-opacity-10 rounded-3 p-2 me-3">
          <TrendingUp className="text-primary" size={20} />
        </div>
        <div>
          <h5 className="card-title mb-0">Productos Más Vendidos</h5>
          <small className="text-muted">Top 5 productos del período</small>
        </div>
      </div>
    </div>
    <div className="card-body p-0">
      {productos && productos.length > 0 ? (
        <div className="table-responsive">
          <table className="table table-hover mb-0">
            <thead className="table-light">
              <tr>
                <th className="px-4 py-3">Producto</th>
                <th className="px-4 py-3">Detalles</th>
                <th className="px-4 py-3 text-center">Stock</th>
                <th className="px-4 py-3 text-center">Cantidad Vendida</th>
                <th className="px-4 py-3 text-end">Ingresos</th>
              </tr>
            </thead>
            <tbody>
              {productos.map((item, index) => (
                <tr key={index}>
                  <td className="px-4 py-3">
                    <div className="d-flex align-items-center">
                      <div className="bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-2" 
                           style={{width: '32px', height: '32px'}}>
                        <span className="text-primary fw-bold small">{index + 1}</span>
                      </div>
                      <div>
                        <div className="fw-bold">{item.producto?.Nombre || 'N/A'}</div>
                        <small className="text-muted">
                          {new Intl.NumberFormat('es-CO', {
                            style: 'currency',
                            currency: 'COP',
                            minimumFractionDigits: 0
                          }).format(item.producto?.PrecioBase || 0)}
                        </small>
                      </div>
                    </div>
                  </td>
                  <td className="px-4 py-3">
                    <div className="d-flex flex-wrap gap-1">
                      {item.producto?.Marca && (
                        <span className="badge bg-secondary">{item.producto.Marca}</span>
                      )}
                      {item.producto?.Talla && (
                        <span className="badge bg-warning text-dark">{item.producto.Talla}</span>
                      )}
                      {item.producto?.Color && (
                        <span className="badge bg-dark">{item.producto.Color}</span>
                      )}
                    </div>
                  </td>
                  <td className="px-4 py-3 text-center">
                    <span className={`badge ${
                      item.producto?.Stock === 0 ? 'bg-danger' : 
                      item.producto?.Stock <= 5 ? 'bg-warning text-dark' : 
                      'bg-success'
                    }`}>
                      {item.producto?.Stock || 0}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-center">
                    <span className="badge bg-primary fs-6">{item.total_vendido}</span>
                  </td>
                  <td className="px-4 py-3 text-end">
                    <span className="fw-bold text-success">
                      {new Intl.NumberFormat('es-CO', {
                        style: 'currency',
                        currency: 'COP',
                        minimumFractionDigits: 0
                      }).format(item.ingresos_totales || 0)}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <div className="text-center py-5">
          <Package className="text-muted mb-3" size={48} />
          <p className="text-muted">No hay datos disponibles</p>
        </div>
      )}
    </div>
  </div>
);

// Sales Chart Component
const VentasPorDia = ({ ventas }) => (
  <div className="card shadow-sm">
    <div className="card-header bg-light">
      <div className="d-flex align-items-center">
        <div className="bg-success bg-opacity-10 rounded-3 p-2 me-3">
          <BarChart3 className="text-success" size={20} />
        </div>
        <div>
          <h5 className="card-title mb-0">Ventas Últimos 7 Días</h5>
          <small className="text-muted">Resumen de ventas diarias</small>
        </div>
      </div>
    </div>
    <div className="card-body">
      {ventas && ventas.length > 0 ? (
        <div className="table-responsive">
          <table className="table table-sm">
            <thead>
              <tr>
                <th>Fecha</th>
                <th className="text-center">Cantidad</th>
                <th className="text-end">Total</th>
              </tr>
            </thead>
            <tbody>
              {ventas.map((venta, index) => (
                <tr key={index}>
                  <td>
                    <i className="bi bi-calendar me-2 text-muted"></i>
                    {new Date(venta.fecha).toLocaleDateString('es-CO', {
                      year: 'numeric',
                      month: 'short',
                      day: 'numeric'
                    })}
                  </td>
                  <td className="text-center">
                    <span className="badge bg-info">{venta.cantidad}</span>
                  </td>
                  <td className="text-end fw-bold text-success">
                    {new Intl.NumberFormat('es-CO', {
                      style: 'currency',
                      currency: 'COP',
                      minimumFractionDigits: 0
                    }).format(venta.total)}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <div className="text-center py-4">
          <ShoppingCart className="text-muted mb-2" size={40} />
          <p className="text-muted mb-0">No hay ventas registradas</p>
        </div>
      )}
    </div>
  </div>
);

// Main Component
const ReportesSystem = () => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [fechaDesde, setFechaDesde] = useState(() => {
    const date = new Date();
    date.setDate(1);
    return date.toISOString().split('T')[0];
  });
  const [fechaHasta, setFechaHasta] = useState(() => {
    return new Date().toISOString().split('T')[0];
  });

  const fetchDashboard = async () => {
    setLoading(true);
    setError(null);

    try {
      const response = await axios.get(`${API_BASE_URL}/reportes/dashboard`, {
        params: {
          fecha_desde: fechaDesde,
          fecha_hasta: fechaHasta
        }
      });
      
      console.log('Respuesta del servidor:', response.data);
      
      if (response.data.success) {
        setData(response.data.data);
      } else {
        throw new Error(response.data.message || 'Error al cargar datos');
      }
    } catch (error) {
      console.error('Error completo:', error);
      console.error('Respuesta del error:', error.response?.data);
      
      let errorMessage = 'Error al cargar el dashboard';

      if (error.response) {
        const status = error.response.status;
        const data = error.response.data;

        if (status === 401) {
          errorMessage = 'No autorizado. Por favor, inicia sesión nuevamente.';
        } else if (status === 403) {
          errorMessage = 'No tienes permisos para ver los reportes.';
        } else if (status === 500) {
          errorMessage = `Error interno del servidor: ${data?.error || data?.message || 'Error desconocido'}`;
          console.error('Detalles del error 500:', data);
        } else {
          errorMessage = data?.message || error.message;
        }
      } else if (error.request) {
        errorMessage = 'Error de conexión. Verifica que el servidor esté funcionando.';
      }

      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchDashboard();
  }, []);

  const handleFiltrar = () => {
    fetchDashboard();
  };

  const formatCurrency = (value) => {
    return new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP',
      minimumFractionDigits: 0
    }).format(value || 0);
  };

  return (
    <>
      <NavbarAdmin />

      <div className="container-fluid py-4" style={{backgroundColor: '#f8f9fa', minHeight: 'calc(100vh - 76px)'}}>
        <div className="container">
          {/* Header */}
          <div className="mb-4">
            <div className="row align-items-center">
              <div className="col">
                <h1 className="display-6 fw-bold text-dark mb-2">
                  Dashboard de Reportes
                </h1>
                <p className="lead text-muted">
                  Análisis y estadísticas de tu negocio
                </p>
              </div>
            </div>
          </div>

          {/* Filtros de fecha */}
          <div className="card shadow-sm mb-4">
            <div className="card-body">
              <div className="row align-items-end">
                <div className="col-md-4">
                  <label className="form-label fw-semibold">
                    <Calendar size={16} className="me-2" />
                    Fecha Desde
                  </label>
                  <input
                    type="date"
                    className="form-control"
                    value={fechaDesde}
                    onChange={(e) => setFechaDesde(e.target.value)}
                  />
                </div>
                <div className="col-md-4">
                  <label className="form-label fw-semibold">
                    <Calendar size={16} className="me-2" />
                    Fecha Hasta
                  </label>
                  <input
                    type="date"
                    className="form-control"
                    value={fechaHasta}
                    onChange={(e) => setFechaHasta(e.target.value)}
                  />
                </div>
                <div className="col-md-4">
                  <button
                    className="btn btn-primary w-100"
                    onClick={handleFiltrar}
                    disabled={loading}
                  >
                    {loading ? (
                      <>
                        <span className="spinner-border spinner-border-sm me-2"></span>
                        Cargando...
                      </>
                    ) : (
                      <>
                        <RefreshCw size={16} className="me-2" />
                        Actualizar
                      </>
                    )}
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Error Alert */}
          {error && (
            <div className="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
              <AlertCircle className="me-2" size={20} />
              <div>{error}</div>
              <button 
                type="button" 
                className="btn-close" 
                onClick={() => setError(null)}
              ></button>
            </div>
          )}

          {/* Loading State */}
          {loading && (
            <div className="text-center py-5">
              <div className="spinner-border text-primary" role="status">
                <span className="visually-hidden">Cargando...</span>
              </div>
            </div>
          )}

          {/* Dashboard Content */}
          {!loading && data && (
            <>
              {/* Stats Cards */}
              <div className="row g-4 mb-4">
                <div className="col-md-3">
                  <StatCard
                    title="Total Ventas"
                    value={data.ventas?.total_ventas || 0}
                    icon={ShoppingCart}
                    color="primary"
                    subtitle="Ventas completadas"
                  />
                </div>
                <div className="col-md-3">
                  <StatCard
                    title="Ingresos Totales"
                    value={formatCurrency(data.ventas?.ingresos_totales)}
                    icon={DollarSign}
                    color="success"
                    subtitle="Período seleccionado"
                  />
                </div>
                <div className="col-md-3">
                  <StatCard
                    title="Ticket Promedio"
                    value={formatCurrency(data.ventas?.ticket_promedio)}
                    icon={TrendingUp}
                    color="info"
                    subtitle="Promedio por venta"
                  />
                </div>
                <div className="col-md-3">
                  <StatCard
                    title="Productos Activos"
                    value={data.inventario?.total_productos || 0}
                    icon={Package}
                    color="warning"
                    subtitle={`${data.inventario?.sin_stock || 0} sin stock`}
                  />
                </div>
              </div>

              {/* Inventory Stats */}
              <div className="row g-4 mb-4">
                <div className="col-md-12">
                  <div className="card shadow-sm">
                    <div className="card-header bg-light">
                      <h5 className="card-title mb-0">
                        <Package className="me-2" size={20} />
                        Estadísticas de Inventario
                      </h5>
                    </div>
                    <div className="card-body">
                      <div className="row text-center">
                        <div className="col-md-4">
                          <div className="p-3">
                            <h2 className="fw-bold text-primary">{data.inventario?.total_productos || 0}</h2>
                            <p className="text-muted mb-0">Total Productos</p>
                          </div>
                        </div>
                        <div className="col-md-4 border-start">
                          <div className="p-3">
                            <h2 className="fw-bold text-danger">{data.inventario?.sin_stock || 0}</h2>
                            <p className="text-muted mb-0">Sin Stock</p>
                          </div>
                        </div>
                        <div className="col-md-4 border-start">
                          <div className="p-3">
                            <h2 className="fw-bold text-warning">{data.inventario?.stock_bajo || 0}</h2>
                            <p className="text-muted mb-0">Stock Bajo (≤ 5)</p>
                          </div>
                        </div>
                      </div>
                      <hr />
                      <div className="text-center">
                        <h4 className="fw-bold text-success">
                          Valor Total: {formatCurrency(data.inventario?.valor_inventario)}
                        </h4>
                        <p className="text-muted mb-0">Valor del inventario actual (basado en precio base)</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Charts Row */}
              <div className="row g-4">
                <div className="col-md-7">
                  <ProductosPopulares productos={data.productos_populares} />
                </div>
                <div className="col-md-5">
                  <VentasPorDia ventas={data.ventas_por_dia} />
                </div>
              </div>
            </>
          )}
        </div>
      </div>
    </>
  );
};

export default ReportesSystem;