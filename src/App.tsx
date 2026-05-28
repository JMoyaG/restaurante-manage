import React, { useEffect, useMemo, useState } from "react";
import { QRCodeCanvas } from "qrcode.react";
import "./App.css";

type Rol = "Admin" | "Caja" | "Cocina" | "Mesero";
type Usuario = {
  usuario: string;
  password: string;
  nombre: string;
  rol: Rol;
};
type EstadoMesa = "Libre" | "Ocupada" | "Cuenta solicitada";
type EstadoCocina = "Pendiente" | "Preparando" | "Listo";
type MetodoPago = "Efectivo" | "Tarjeta" | "SINPE" | "Mixto";


type Producto = {
  id: number;
  categoria: string;
  nombre: string;
  precio: number;
};

type ItemOrden = Producto & {
  cantidad: number;
  nota?: string;
  estadoCocina: EstadoCocina;
  enviadoCocina: boolean;
};

type Mesa = {
  id: number;
  nombre: string;
  estado: EstadoMesa;
  orden: ItemOrden[];
};

type Venta = {
  id: number;
  fecha: string;
  mesa: string;
  metodoPago: MetodoPago;
  total: number;
  montoRecibido: number;
  vuelto: number;
  items: ItemOrden[];
};
type CierreCaja = {
  id: number;
  fecha: string;
  totalEfectivo: number;
  totalTarjeta: number;
  totalSinpe: number;
  totalMixto: number;
  totalGeneral: number;
  cantidadVentas: number;
  ventas: Venta[];
};
const productosIniciales: Producto[] = [
  { id: 1, categoria: "Comidas", nombre: "Hamburguesa", precio: 3500 },
  { id: 2, categoria: "Comidas", nombre: "Pizza", precio: 6000 },
  { id: 3, categoria: "Comidas", nombre: "Papas", precio: 2500 },
  { id: 4, categoria: "Bebidas", nombre: "Coca Cola", precio: 1500 },
  { id: 5, categoria: "Bebidas", nombre: "Natural", precio: 1800 },
  { id: 6, categoria: "Postres", nombre: "Tres Leches", precio: 2800 },
];
const usuariosIniciales: Usuario[] = [
  {
    usuario: "admin",
    password: "1234",
    nombre: "Administrador",
    rol: "Admin",
  },
  {
    usuario: "caja",
    password: "1234",
    nombre: "Caja Principal",
    rol: "Caja",
  },
  {
    usuario: "cocina",
    password: "1234",
    nombre: "Cocina",
    rol: "Cocina",
  },
  {
    usuario: "mesero",
    password: "1234",
    nombre: "Mesero",
    rol: "Mesero",
  },
];
const crearMesas = (): Mesa[] =>
  Array.from({ length: 12 }, (_, i) => ({
    id: i + 1,
    nombre: `Mesa ${i + 1}`,
    estado: "Libre",
    orden: [],
  }));

const formatoCRC = (monto: number) =>
  new Intl.NumberFormat("es-CR", {
    style: "currency",
    currency: "CRC",
    maximumFractionDigits: 0,
  }).format(monto);

export default function App() {
  const [rol, setRol] = useState<Rol | null>(() => {
    return (localStorage.getItem("pos_rol") as Rol) || null;
  });

  const [mesas, setMesas] = useState<Mesa[]>(() => {
    const guardadas = localStorage.getItem("pos_mesas");
    return guardadas ? JSON.parse(guardadas) : crearMesas();
  });

 const [ventas, setVentas] = useState<Venta[]>(() => {
  const guardadas = localStorage.getItem("pos_ventas");
  return guardadas ? JSON.parse(guardadas) : [];
});

const [productos, setProductos] = useState<Producto[]>(() => {
  const guardados = localStorage.getItem("pos_productos");
  return guardados ? JSON.parse(guardados) : productosIniciales;
});
const [usuarios, setUsuarios] = useState<Usuario[]>(() => {
  const guardados = localStorage.getItem("pos_usuarios");

  return guardados
    ? JSON.parse(guardados)
    : usuariosIniciales;
});

const [nuevoUsuario, setNuevoUsuario] = useState<Usuario>({
  usuario: "",
  password: "",
  nombre: "",
  rol: "Mesero",
});

const [nuevoProducto, setNuevoProducto] = useState<Producto>({
  id: 0,
  nombre: "",
  categoria: "Comidas",
  precio: 0,
});
const [productoEditando, setProductoEditando] = useState<number | null>(null);

  const [mesaId, setMesaId] = useState<number | null>(null);
 const [vista, setVista] = useState<
  | "inicio"
  | "mesas"
  | "cocina"
  | "estadisticas"
  | "cierre"
  | "qr"
  | "productos"
  | "usuarios"
>("inicio");
  const [metodoPago, setMetodoPago] = useState<MetodoPago>("Efectivo");
  const [montoRecibido, setMontoRecibido] = useState<number>(0);
  const [reciboActual, setReciboActual] = useState<Venta | null>(null);
  const [cierresCaja, setCierresCaja] = useState<CierreCaja[]>(() => {
  const guardados = localStorage.getItem("pos_cierres_caja");
  return guardados ? JSON.parse(guardados) : [];
});
  const [usuarioActual, setUsuarioActual] = useState<Usuario | null>(() => {
  const guardado = localStorage.getItem("pos_usuario_actual");
  return guardado ? JSON.parse(guardado) : null;
});

const [usuarioLogin, setUsuarioLogin] = useState("");
const [passwordLogin, setPasswordLogin] = useState("");
const [errorLogin, setErrorLogin] = useState("");
const parametrosUrl = new URLSearchParams(window.location.search);
const mesaQR = parametrosUrl.get("mesa");
const modoMenuQR = parametrosUrl.get("menu") === "1";
const [ordenQR, setOrdenQR] = useState<ItemOrden[]>([]);
const [notaQR, setNotaQR] = useState("");
useEffect(() => {
  localStorage.setItem("pos_cierres_caja", JSON.stringify(cierresCaja));
}, [cierresCaja]);
  useEffect(() => {
    localStorage.setItem("pos_mesas", JSON.stringify(mesas));
  }, [mesas]);

  useEffect(() => {
    localStorage.setItem("pos_ventas", JSON.stringify(ventas));
  }, [ventas]);
  useEffect(() => {
  localStorage.setItem("pos_productos", JSON.stringify(productos));
}, [productos]);
useEffect(() => {
  localStorage.setItem("pos_usuarios", JSON.stringify(usuarios));
}, [usuarios]);
  useEffect(() => {
    if (rol) localStorage.setItem("pos_rol", rol);

    if (rol === "Cocina") setVista("cocina");
    if (rol === "Mesero") setVista("mesas");
    if (rol === "Caja") setVista("mesas");
    if (rol === "Admin") setVista("inicio");
  }, [rol]);

  const mesaSeleccionada = useMemo(
    () => mesas.find((m) => m.id === mesaId) || null,
    [mesas, mesaId]
  );

  const total = mesaSeleccionada
    ? mesaSeleccionada.orden.reduce(
        (acc, item) => acc + item.precio * item.cantidad,
        0
      )
    : 0;

  const puedeCobrar = rol === "Admin" || rol === "Caja";
  const puedeVerStats = rol === "Admin";
  const puedeCerrarCaja = rol === "Admin" || rol === "Caja";
const puedeExportarPDF = rol === "Admin";
  const puedeUsarMesas = rol === "Admin" || rol === "Caja" || rol === "Mesero";
  const puedeUsarCocina = rol === "Admin" || rol === "Cocina";

  const itemsCocina = mesas.flatMap((mesa) =>
    mesa.orden
      .filter((item) => item.enviadoCocina)
      .map((item) => ({
        mesaId: mesa.id,
        mesaNombre: mesa.nombre,
        ...item,
      }))
  );

  const totalVendido = ventas.reduce((acc, v) => acc + v.total, 0);
  const cantidadVentas = ventas.length;

  const productoMasVendido = useMemo(() => {
    const conteo: Record<string, number> = {};

    ventas.forEach((venta) => {
      venta.items.forEach((item) => {
        conteo[item.nombre] = (conteo[item.nombre] || 0) + item.cantidad;
      });
    });

    const ganador = Object.entries(conteo).sort((a, b) => b[1] - a[1])[0];

    return ganador ? `${ganador[0]} (${ganador[1]})` : "Sin ventas";
  }, [ventas]);

  const actualizarMesa = (mesaActualizada: Mesa) => {
    setMesas((prev) =>
      prev.map((m) => (m.id === mesaActualizada.id ? mesaActualizada : m))
    );
  };

  const agregarProducto = (producto: Producto) => {
    if (!mesaSeleccionada) return;

    const existe = mesaSeleccionada.orden.find((p) => p.id === producto.id);

    const ordenNueva = existe
      ? mesaSeleccionada.orden.map((p) =>
          p.id === producto.id ? { ...p, cantidad: p.cantidad + 1 } : p
        )
      : [
          ...mesaSeleccionada.orden,
          {
            ...producto,
            cantidad: 1,
            nota: "",
            estadoCocina: "Pendiente" as EstadoCocina,
            enviadoCocina: false,
          },
        ];

    actualizarMesa({
      ...mesaSeleccionada,
      estado: "Ocupada",
      orden: ordenNueva,
    });
  };

  const cambiarCantidad = (productoId: number, cambio: number) => {
    if (!mesaSeleccionada) return;

    const ordenNueva = mesaSeleccionada.orden
      .map((item) =>
        item.id === productoId
          ? { ...item, cantidad: item.cantidad + cambio }
          : item
      )
      .filter((item) => item.cantidad > 0);

    actualizarMesa({
      ...mesaSeleccionada,
      estado: ordenNueva.length ? "Ocupada" : "Libre",
      orden: ordenNueva,
    });
  };

  const eliminarProducto = (productoId: number) => {
    if (!mesaSeleccionada) return;

    const ordenNueva = mesaSeleccionada.orden.filter(
      (item) => item.id !== productoId
    );

    actualizarMesa({
      ...mesaSeleccionada,
      estado: ordenNueva.length ? "Ocupada" : "Libre",
      orden: ordenNueva,
    });
  };

  const cambiarNota = (productoId: number, nota: string) => {
    if (!mesaSeleccionada) return;

    actualizarMesa({
      ...mesaSeleccionada,
      orden: mesaSeleccionada.orden.map((item) =>
        item.id === productoId ? { ...item, nota } : item
      ),
    });
  };

  const enviarACocina = () => {
    if (!mesaSeleccionada || mesaSeleccionada.orden.length === 0) return;

    actualizarMesa({
      ...mesaSeleccionada,
      estado: "Ocupada",
      orden: mesaSeleccionada.orden.map((item) => ({
        ...item,
        estadoCocina: item.estadoCocina || "Pendiente",
        enviadoCocina: true,
      })),
    });

    alert("Orden enviada a cocina");
    setMesaId(null);
  };

  const cambiarEstadoItem = (
    mesaId: number,
    productoId: number,
    estado: EstadoCocina
  ) => {
    setMesas((prev) =>
      prev.map((mesa) =>
        mesa.id === mesaId
          ? {
              ...mesa,
              orden: mesa.orden.map((item) =>
                item.id === productoId
                  ? { ...item, estadoCocina: estado }
                  : item
              ),
            }
          : mesa
      )
    );
  };

  const solicitarCuenta = () => {
    if (!mesaSeleccionada || mesaSeleccionada.orden.length === 0) return;
    actualizarMesa({ ...mesaSeleccionada, estado: "Cuenta solicitada" });
    alert("Cuenta solicitada");
    setMesaId(null);
  };

  const imprimir = () => {
    window.print();
  };

const cobrar = () => {
  if (!mesaSeleccionada || mesaSeleccionada.orden.length === 0) return;

  const venta: Venta = {
    id: Date.now(),
    fecha: new Date().toLocaleString("es-CR"),
    mesa: mesaSeleccionada.nombre,
    metodoPago,
    total,
    montoRecibido,
    vuelto: montoRecibido > total ? montoRecibido - total : 0,
    items: [...mesaSeleccionada.orden],
  };

  setReciboActual(venta);
  setVentas((prev) => [venta, ...prev]);

  setTimeout(() => {
    window.print();

    setTimeout(() => {
      setMesas((prev) =>
        prev.map((mesa) =>
          mesa.id === mesaSeleccionada.id
            ? { ...mesa, estado: "Libre", orden: [] }
            : mesa
        )
      );

      setMesaId(null);
      setMetodoPago("Efectivo");
      setMontoRecibido(0);
      setReciboActual(null);
    }, 700);
  }, 300);
};

  const limpiarTodo = () => {
    if (!confirm("¿Seguro que querés reiniciar todas las mesas?")) return;
    setMesas(crearMesas());
    setMesaId(null);
  };

  const cerrarSesion = () => {
  localStorage.removeItem("pos_rol");
  localStorage.removeItem("pos_usuario_actual");
  setRol(null);
  setUsuarioActual(null);
  setMesaId(null);
  setVista("mesas");
};

  const estadoMesaVisual = (mesa: Mesa) => {
    const enviados = mesa.orden.filter((item) => item.enviadoCocina);

    const todosListos =
      enviados.length > 0 &&
      enviados.every((item) => item.estadoCocina === "Listo");

    const algunoPreparando = enviados.some(
      (item) => item.estadoCocina === "Preparando"
    );

    if (mesa.estado === "Cuenta solicitada") return "Cuenta solicitada";
    if (todosListos) return "Orden lista (recoger)";
    if (algunoPreparando) return "Preparando";
    if (mesa.orden.length > 0) return "Ocupada";
    return "Libre";
  };

  const colorMesa = (mesa: Mesa) => {
    const estado = estadoMesaVisual(mesa);

    if (estado === "Libre") return "#16a34a";
    if (estado === "Preparando") return "#2563eb";
    if (estado === "Orden lista (recoger)") return "#f59e0b";
    if (estado === "Cuenta solicitada") return "#9333ea";

    return "#dc2626";
  };
const iniciarSesion = () => {
  const encontrado = usuarios.find(
    (u) =>
      u.usuario.toLowerCase() === usuarioLogin.toLowerCase().trim() &&
      u.password === passwordLogin
  );

  if (!encontrado) {
    setErrorLogin("Usuario o contraseña incorrectos");
    return;
  }

  setUsuarioActual(encontrado);
  setRol(encontrado.rol);
  localStorage.setItem("pos_usuario_actual", JSON.stringify(encontrado));
  localStorage.setItem("pos_rol", encontrado.rol);

  setUsuarioLogin("");
  setPasswordLogin("");
  setErrorLogin("");
};
const exportarCierrePDF = (cierre: CierreCaja) => {
  const contenido = `
    <html>
      <head>
        <title>Cierre Caja</title>

        <style>
          body {
            font-family: Arial;
            padding: 30px;
          }

          h1 {
            text-align: center;
          }

          table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
          }

          th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
          }

          th {
            background: #f3f4f6;
          }
        </style>
      </head>

      <body>
        <h1>Cierre de Caja</h1>

        <p><strong>Fecha:</strong> ${cierre.fecha}</p>
        <p><strong>Ventas:</strong> ${cierre.cantidadVentas}</p>

        <table>
          <tr>
            <th>Tipo</th>
            <th>Total</th>
          </tr>

          <tr>
            <td>Efectivo</td>
            <td>${formatoCRC(cierre.totalEfectivo)}</td>
          </tr>

          <tr>
            <td>Tarjeta</td>
            <td>${formatoCRC(cierre.totalTarjeta)}</td>
          </tr>

          <tr>
            <td>SINPE</td>
            <td>${formatoCRC(cierre.totalSinpe)}</td>
          </tr>

          <tr>
            <td>Mixto</td>
            <td>${formatoCRC(cierre.totalMixto)}</td>
          </tr>

          <tr>
            <td><strong>TOTAL GENERAL</strong></td>
            <td><strong>${formatoCRC(cierre.totalGeneral)}</strong></td>
          </tr>
        </table>
      </body>
    </html>
  `;

  const ventana = window.open("", "_blank");

  if (!ventana) return;

  ventana.document.write(contenido);
  ventana.document.close();

  setTimeout(() => {
    ventana.print();
  }, 500);
};
const agregarProductoQR = (producto: Producto) => {
  const existe = ordenQR.find((item) => item.id === producto.id);

  if (existe) {
    setOrdenQR((prev) =>
      prev.map((item) =>
        item.id === producto.id
          ? { ...item, cantidad: item.cantidad + 1 }
          : item
      )
    );
  } else {
    setOrdenQR((prev) => [
      ...prev,
      {
        ...producto,
        cantidad: 1,
        nota: "",
        estadoCocina: "Pendiente",
        enviadoCocina: false,
      },
    ]);
  }
};

const enviarPedidoQR = () => {
  if (!mesaQR) return;

  const mesaNumero = Number(mesaQR);

  if (!mesaNumero || ordenQR.length === 0) {
    alert("Agregá al menos un producto.");
    return;
  }

  setMesas((prev) =>
    prev.map((mesa) =>
      mesa.id === mesaNumero
        ? {
            ...mesa,
            estado: "Ocupada",
            orden: [
              ...mesa.orden,
              ...ordenQR.map((item) => ({
                ...item,
                nota: notaQR,
                enviadoCocina: true,
              })),
            ],
          }
        : mesa
    )
  );

  alert("Pedido enviado correctamente.");
  setOrdenQR([]);
  setNotaQR("");
};
const copiarLinkQR = (mesaId: number) => {
  const url = `${window.location.origin}${window.location.pathname}?mesa=${mesaId}&menu=1`;
  navigator.clipboard.writeText(url);
  alert(`Link copiado para Mesa ${mesaId}`);
};

const imprimirQR = () => {
  const contenido = `
    <html>
      <head>
        <title>QR Mesas</title>
        <style>
          body {
            font-family: Arial;
            padding: 30px;
          }

          h1 {
            text-align: center;
            margin-bottom: 30px;
          }

          .grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
          }

          .card {
            border: 2px solid #111;
            border-radius: 16px;
            padding: 20px;
            text-align: center;
            page-break-inside: avoid;
          }

          .mesa {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
          }

          .texto {
            font-size: 14px;
            margin-top: 15px;
          }
        </style>
      </head>

      <body>
        <h1>Menú Digital - Restaurante</h1>

        <div class="grid">
          ${mesas
            .map((mesa) => {
              const url = `${window.location.origin}${window.location.pathname}?mesa=${mesa.id}&menu=1`;

              return `
                <div class="card">
                  <div class="mesa">${mesa.nombre}</div>
                  <img
                    src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=${encodeURIComponent(
                      url
                    )}"
                  />
                  <div class="texto">Escanee para ver el menú</div>
                </div>
              `;
            })
            .join("")}
        </div>
      </body>
    </html>
  `;

  const ventana = window.open("", "_blank");
  if (!ventana) return;

  ventana.document.write(contenido);
  ventana.document.close();

  setTimeout(() => {
    ventana.print();
  }, 700);
};
if (modoMenuQR && mesaQR) {
  const categorias = Array.from(new Set(productos.map((p) => p.categoria)));
  
  return (
    <div
      style={{
        minHeight: "100vh",
        background:
          "radial-gradient(circle at top, #5b2333 0%, #351827 45%, #1f1020 100%)",
        padding: 28,
        fontFamily: "Georgia, serif",
        color: "white",
        overflow: "hidden",
      }}
    >
      <div
        style={{
          position: "fixed",
          inset: 0,
          pointerEvents: "none",
          opacity: 0.45,
          backgroundImage:
            "radial-gradient(#facc15 2px, transparent 2px), radial-gradient(#22c55e 2px, transparent 2px), radial-gradient(#ef4444 2px, transparent 2px)",
          backgroundSize: "80px 80px, 110px 110px, 140px 140px",
        }}
      />

      <div
        className="menu-card"
        style={{
          maxWidth: 920,
          margin: "0 auto",
          position: "relative",
          background: "#431f2f",
          border: "3px solid #f97316",
          borderRadius: 8,
          padding: 34,
          boxShadow: "0 30px 70px rgba(0,0,0,0.45)",
        }}
      >
        <div
          className="menu-float"
          style={{
            position: "absolute",
            top: 20,
            left: 20,
            fontSize: 32,
          }}
        >
          🌶️
        </div>

        <div
          className="menu-float"
          style={{
            position: "absolute",
            top: 20,
            right: 20,
            fontSize: 32,
            animationDelay: "1s",
          }}
        >
          🌮
        </div>

        <div style={{ textAlign: "center", marginBottom: 34 }}>
          <div
            className="menu-float"
            style={{
              fontSize: 74,
              marginBottom: 6,
            }}
          >
            💀
          </div>

          <h1
            className="menu-title"
            style={{
              fontFamily: "Arial Black, Arial",
              fontSize: 52,
              color: "#6ee7b7",
              margin: 0,
              letterSpacing: 5,
              transform: "rotate(-2deg)",
            }}
          >
            SPECIAL MENU
          </h1>

          <div style={{ fontSize: 44, marginTop: -8 }}>👒</div>

          <p
            style={{
              color: "#facc15",
              letterSpacing: 8,
              fontSize: 18,
              marginTop: 6,
            }}
          >
            ANTOJITOS MEXICANOS · MESA {mesaQR}
          </p>
        </div>

        <div
          style={{
            textAlign: "center",
            margin: "20px 0 32px",
          }}
        >
          <span
            style={{
              background: "#f97316",
              color: "white",
              padding: "12px 70px",
              fontFamily: "Arial Black",
              fontSize: 28,
              display: "inline-block",
              clipPath:
                "polygon(8% 0%, 92% 0%, 100% 50%, 92% 100%, 8% 100%, 0% 50%)",
            }}
          >
            MENÚ
          </span>
        </div>

        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(2, 1fr)",
            gap: 34,
          }}
        >
          {categorias.map((categoria, index) => (
            <div key={categoria}>
              <h2
                style={{
                  fontFamily: "Arial Black, Arial",
                  color:
                    index % 3 === 0
                      ? "#ef4444"
                      : index % 3 === 1
                      ? "#34d399"
                      : "#facc15",
                  fontSize: 28,
                  marginBottom: 16,
                  textTransform: "uppercase",
                  display: "flex",
                  alignItems: "center",
                  gap: 10,
                }}
              >
                <span>
                  {categoria === "Comidas"
                    ? "🌮"
                    : categoria === "Bebidas"
                    ? "🍹"
                    : categoria === "Postres"
                    ? "🍮"
                    : "⭐"}
                </span>
                {categoria}
              </h2>

              {productos
                .filter((p) => p.categoria === categoria)
                .map((producto) => (
                  <div
                    key={producto.id}
                    className="menu-item"
                    style={{
                      padding: "10px 8px",
                      borderRadius: 10,
                    }}
                  >
                    <div
                      style={{
                        display: "grid",
                        gridTemplateColumns: "auto 1fr auto",
                        gap: 10,
                        alignItems: "center",
                        fontSize: 18,
                      }}
                    >
                      <strong>{producto.nombre}</strong>

                      <span
                        style={{
                          borderBottom: "2px dotted rgba(255,255,255,0.55)",
                          transform: "translateY(4px)",
                        }}
                      />

                      <strong style={{ color: "#facc15" }}>
                        {formatoCRC(producto.precio)}
                      </strong>
                    </div>

                    <small
                      style={{
                        display: "block",
                        color: "#d1d5db",
                        marginTop: 3,
                        fontSize: 11,
                      }}
                    >
                      Preparado al momento · sabor de la casa
                    </small>
                  </div>
                ))}
            </div>
          ))}
        </div>

        <div
          style={{
            marginTop: 40,
            borderTop: "3px solid #10b981",
            paddingTop: 18,
            textAlign: "center",
          }}
        >
          <div className="menu-float" style={{ fontSize: 30 }}>
            🌵 🌶️ 🪅 🌮 🌵
          </div>

          <h2
            style={{
              color: "#facc15",
              fontFamily: "Arial Black",
              marginBottom: 6,
            }}
          >
            ¡Buen provecho!
          </h2>

          <p style={{ color: "#f3f4f6", fontSize: 16 }}>
        
          </p>
        </div>
      </div>
    </div>
  );
}
const crearProducto = () => {
  if (!nuevoProducto.nombre.trim()) {
    alert("Ingresá nombre");
    return;
  }

  if (nuevoProducto.precio <= 0) {
    alert("Precio inválido");
    return;
  }

  const producto: Producto = {
    ...nuevoProducto,
    id: Date.now(),
  };

  setProductos((prev) => [...prev, producto]);

  setNuevoProducto({
    id: 0,
    nombre: "",
    categoria: "Comidas",
    precio: 0,
  });
};

const eliminarProductoAdmin = (id: number) => {
  if (!confirm("¿Eliminar producto?")) return;

  setProductos((prev) => prev.filter((p) => p.id !== id));
};
const actualizarProducto = (
  id: number,
  campo: keyof Producto,
  valor: string | number
) => {
  setProductos((prev) =>
    prev.map((p) =>
      p.id === id
        ? {
            ...p,
            [campo]: valor,
          }
        : p
    )
  );
};
const crearUsuario = () => {
  if (!nuevoUsuario.usuario.trim() || !nuevoUsuario.password.trim()) {
    alert("Usuario y contraseña son obligatorios.");
    return;
  }

  const existe = usuarios.some(
    (u) => u.usuario.toLowerCase() === nuevoUsuario.usuario.toLowerCase()
  );

  if (existe) {
    alert("Ese usuario ya existe.");
    return;
  }

  setUsuarios((prev) => [...prev, nuevoUsuario]);

  setNuevoUsuario({
    usuario: "",
    password: "",
    nombre: "",
    rol: "Mesero",
  });
};

const eliminarUsuario = (usuario: string) => {
  if (usuario === "admin") {
    alert("No podés eliminar el usuario admin principal.");
    return;
  }

  if (!confirm("¿Eliminar usuario?")) return;

  setUsuarios((prev) => prev.filter((u) => u.usuario !== usuario));
};

const actualizarUsuario = (
  usuario: string,
  campo: keyof Usuario,
  valor: string
) => {
  setUsuarios((prev) =>
    prev.map((u) =>
      u.usuario === usuario
        ? {
            ...u,
            [campo]: valor,
          }
        : u
    )
  );
};
  if (!rol) {
  return (
    <div style={loginPage}>
      <div style={loginCard}>
        <h1>POS Restaurante</h1>
        <p>Inicio de sesión</p>

        <input
          value={usuarioLogin}
          onChange={(e) => setUsuarioLogin(e.target.value)}
          placeholder="Usuario"
          style={{ ...input, width: "100%", marginBottom: 10 }}
        />

        <input
          type="password"
          value={passwordLogin}
          onChange={(e) => setPasswordLogin(e.target.value)}
          placeholder="Contraseña"
          style={{ ...input, width: "100%", marginBottom: 10 }}
          onKeyDown={(e) => {
            if (e.key === "Enter") iniciarSesion();
          }}
        />

        {errorLogin && (
          <p style={{ color: "#dc2626", fontWeight: "bold" }}>
            {errorLogin}
          </p>
        )}

        <button onClick={iniciarSesion} style={loginBtn}>
          Entrar
        </button>

        <div style={{ marginTop: 20, fontSize: 12, color: "#666" }}>
        </div>
      </div>
    </div>
  );
}
  const retirarOrdenLista = () => {
  if (!mesaSeleccionada) return;

  actualizarMesa({
    ...mesaSeleccionada,
    estado: "Ocupada",
    orden: mesaSeleccionada.orden.map((item) => ({
      ...item,
      enviadoCocina: false,
    })),
  });

  alert("Orden retirada");
  setMesaId(null);
};
const cerrarCaja = () => {
  if (ventas.length === 0) {
    alert("No hay ventas para cerrar.");
    return;
  }

  const totalEfectivo = ventas
    .filter((v) => v.metodoPago === "Efectivo")
    .reduce((acc, v) => acc + v.total, 0);

  const totalTarjeta = ventas
    .filter((v) => v.metodoPago === "Tarjeta")
    .reduce((acc, v) => acc + v.total, 0);

  const totalSinpe = ventas
    .filter((v) => v.metodoPago === "SINPE")
    .reduce((acc, v) => acc + v.total, 0);

  const totalMixto = ventas
    .filter((v) => v.metodoPago === "Mixto")
    .reduce((acc, v) => acc + v.total, 0);

  const totalGeneral = ventas.reduce((acc, v) => acc + v.total, 0);

  const cierre: CierreCaja = {
    id: Date.now(),
    fecha: new Date().toLocaleString("es-CR"),
    totalEfectivo,
    totalTarjeta,
    totalSinpe,
    totalMixto,
    totalGeneral,
    cantidadVentas: ventas.length,
    ventas,
  };

  setCierresCaja((prev) => [cierre, ...prev]);
  setVentas([]);

  alert("Caja cerrada correctamente.");
};
  return (
  <div className="app-shell">
      <style>{`
      @keyframes flotar {
  0% { transform: translateY(0px) rotate(0deg); }
  50% { transform: translateY(-12px) rotate(4deg); }
  100% { transform: translateY(0px) rotate(0deg); }
}

@keyframes aparecer {
  from { opacity: 0; transform: scale(0.96) translateY(20px); }
  to { opacity: 1; transform: scale(1) translateY(0); }
}

@keyframes brillo {
  0% { text-shadow: 0 0 4px #facc15; }
  50% { text-shadow: 0 0 18px #f97316; }
  100% { text-shadow: 0 0 4px #facc15; }
}

.menu-card {
  animation: aparecer 0.7s ease-out;
}

.menu-float {
  animation: flotar 3s ease-in-out infinite;
}

.menu-title {
  animation: brillo 2.5s ease-in-out infinite;
}

.menu-item {
  transition: transform 0.2s ease, background 0.2s ease;
}

.menu-item:hover {
  transform: translateX(8px) scale(1.02);
  background: rgba(255,255,255,0.08);
}
  @page {
    size: 80mm 120mm;
    margin: 0;
  }

  @media print {
    html, body {
      width: 80mm;
      height: auto;
      margin: 0 !important;
      padding: 0 !important;
      overflow: hidden !important;
      background: white !important;
    }

    body * {
      visibility: hidden !important;
    }

    #recibo, #recibo * {
      visibility: visible !important;
    }
      .qr-print, .qr-print * {
  visibility: visible !important;
}

    #recibo {
      display: block !important;
      position: fixed !important;
      left: 0 !important;
      top: 0 !important;
      width: 72mm !important;
      max-width: 72mm !important;
      padding: 4mm !important;
      margin: 0 !important;
      background: white !important;
      color: black !important;
      font-family: Arial, sans-serif !important;
      font-size: 11px !important;
      line-height: 1.25 !important;
      page-break-after: avoid !important;
      page-break-before: avoid !important;
      page-break-inside: avoid !important;
    }
      .qr-print {
  display: block !important;
  position: absolute !important;
  left: 0 !important;
  top: 0 !important;
  width: 100% !important;
  background: white !important;
  color: black !important;
  padding: 20px !important;
}

    #recibo h2 {
      font-size: 16px !important;
      margin: 0 0 6px 0 !important;
    }

    #recibo p {
      margin: 4px 0 !important;
    }

    #recibo hr {
      margin: 6px 0 !important;
    }

    .no-print {
      display: none !important;
    }
  }
`}</style>
<aside className="sidebar no-print">
  <div>
    <div className="logo">
      <div className="logo-hat">🌶️🌮</div>
      <div className="logo-pos">POS</div>
      <div className="logo-rest">RESTAURANTE</div>
      <small className="logo-small">SISTEMA DE GESTIÓN</small>
    </div>

    <div className="side-menu">
      {rol === "Admin" && (
        <button
          onClick={() => setVista("inicio")}
          className={`side-btn ${vista === "inicio" ? "active" : ""}`}
        >
          <span className="side-icon">🏠</span> Inicio
        </button>
      )}

      {puedeUsarMesas && (
        <button
          onClick={() => setVista("mesas")}
          className={`side-btn ${vista === "mesas" ? "active" : ""}`}
        >
          <span className="side-icon">🪑</span> Mesas
        </button>
      )}

      {puedeCerrarCaja && (
        <button
          onClick={() => setVista("cierre")}
          className={`side-btn ${vista === "cierre" ? "active" : ""}`}
        >
          <span className="side-icon">💼</span> Cierre de caja
        </button>
      )}

      {puedeUsarCocina && (
        <button
          onClick={() => setVista("cocina")}
          className={`side-btn ${vista === "cocina" ? "active" : ""}`}
        >
          <span className="side-icon">👨‍🍳</span> Cocina
        </button>
      )}

      {puedeVerStats && (
        <button
          onClick={() => setVista("estadisticas")}
          className={`side-btn ${vista === "estadisticas" ? "active" : ""}`}
        >
          <span className="side-icon">📊</span> Estadísticas
        </button>
      )}

      {rol === "Admin" && (
        <button
          onClick={() => setVista("qr")}
          className={`side-btn ${vista === "qr" ? "active" : ""}`}
        >
          <span className="side-icon">▦</span> QR Mesas
        </button>
      )}

      {rol === "Admin" && (
        <button
          onClick={() => setVista("productos")}
          className={`side-btn ${vista === "productos" ? "active" : ""}`}
        >
          <span className="side-icon">🥑</span> Productos
        </button>
      )}

      {rol === "Admin" && (
        <button
          onClick={() => setVista("usuarios")}
          className={`side-btn ${vista === "usuarios" ? "active" : ""}`}
        >
          <span className="side-icon">👥</span> Usuarios
        </button>
      )}
    </div>
  </div>

  <div className="sidebar-bottom">
    {rol === "Admin" && (
      <button onClick={limpiarTodo} className="side-btn danger-btn">
        🔄 Reiniciar sistema
      </button>
    )}

    <button onClick={cerrarSesion} className="side-btn danger-btn">
      🚪 Salir
    </button>

    <div className="flower">🌺</div>
  </div>
</aside>

<div className="content">
  <div className="topbar no-print">
    <div>
      <h1>¡Bienvenido, {usuarioActual?.nombre}! 🌺</h1>
      <p>Control total de tu restaurante en un solo lugar</p>
    </div>

    <div className="top-right">
      <div className="date-box">
        <div>🗓️ {new Date().toLocaleDateString("es-CR", { day: "2-digit", month: "long", year: "numeric" })}</div>
        <div>🕒 {new Date().toLocaleTimeString("es-CR", { hour: "2-digit", minute: "2-digit" })}</div>
      </div>
      <div className="cactus">🌵</div>
      <div className="role-pill">Rol: {rol} 👑</div>
      <button onClick={cerrarSesion} className="exit-btn">↪ Salir</button>
    </div>
  </div>

  {vista === "inicio" && rol === "Admin" && (
    <>
      <div className="hero no-print">
        <div>
          <h1>Panel de control</h1>
          <p>Todo tu restaurante, en tiempo real</p>
          <div className="ornament">━━━━ ❖ ━━━━</div>
        </div>
      </div>

      <div className="page no-print">
        <div className="quick-grid">
          <button className="quick-card" onClick={() => setVista("mesas")}>
            <div className="quick-img img-mesas" />
            <div className="quick-icon green">🪑</div>
            <div className="quick-body"><h2>Mesas</h2><p>Ver y gestionar<br />todas las mesas</p></div>
          </button>
          <button className="quick-card" onClick={() => setVista("cierre")}>
            <div className="quick-img img-caja" />
            <div className="quick-icon orange">💼</div>
            <div className="quick-body"><h2>Cierre de caja</h2><p>Cerrar caja y ver<br />resumen de ventas</p></div>
          </button>
          <button className="quick-card" onClick={() => setVista("cocina")}>
            <div className="quick-img img-cocina" />
            <div className="quick-icon red">👨‍🍳</div>
            <div className="quick-body"><h2>Cocina</h2><p>Ver comandas y estado<br />de preparación</p></div>
          </button>
          <button className="quick-card" onClick={() => setVista("estadisticas")}>
            <div className="quick-img img-stats" />
            <div className="quick-icon teal">📊</div>
            <div className="quick-body"><h2>Estadísticas</h2><p>Ventas, productos y<br />reportes detallados</p></div>
          </button>
          <button className="quick-card" onClick={() => setVista("qr")}>
            <div className="quick-img img-qr" />
            <div className="quick-icon purple">▦</div>
            <div className="quick-body"><h2>QR Mesas</h2><p>Generar y gestionar<br />códigos QR</p></div>
          </button>
          <button className="quick-card" onClick={() => setVista("productos")}>
            <div className="quick-img img-productos" />
            <div className="quick-icon lime">🍴</div>
            <div className="quick-body"><h2>Productos</h2><p>Administrar menú<br />y precios</p></div>
          </button>
          <button className="quick-card" onClick={() => setVista("usuarios")}>
            <div className="quick-img img-usuarios" />
            <div className="quick-icon pink">👥</div>
            <div className="quick-body"><h2>Usuarios</h2><p>Gestionar usuarios<br />y permisos</p></div>
          </button>
        </div>

        <div className="summary">
          <h2>✤ Resumen del día ✤</h2>
          <div className="summary-grid">
            <div className="summary-card"><div className="summary-icon green">📈</div><div><small>Ventas del día</small><strong>{formatoCRC(totalVendido)}</strong><span>Total en ventas</span></div></div>
            <div className="summary-card"><div className="summary-icon orange">🛒</div><div><small>Ventas realizadas</small><strong>{cantidadVentas}</strong><span>Transacciones</span></div></div>
            <div className="summary-card"><div className="summary-icon red">👨‍🍳</div><div><small>Productos vendidos</small><strong>{ventas.reduce((acc, v) => acc + v.items.reduce((s, i) => s + i.cantidad, 0), 0)}</strong><span>Total unidades</span></div></div>
            <div className="summary-card"><div className="summary-icon teal">👥</div><div><small>Mesas atendidas</small><strong>{new Set(ventas.map((v) => v.mesa)).size}</strong><span>Hoy</span></div></div>
          </div>
        </div>
      </div>
    </>
  )}

  <div className="page">
      {vista === "mesas" && !puedeUsarMesas && (
        <p>No tenés acceso a mesas con este rol.</p>
      )}

      {vista === "mesas" && puedeUsarMesas && !mesaSeleccionada && (
        <div className="no-print">
          <div
  style={{
    marginBottom: 30,
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    flexWrap: "wrap",
    gap: 20,
  }}
>
  <div>
    <h1
      style={{
        fontSize: 52,
        margin: 0,
        color: "#7c2d12",
        fontWeight: 900,
      }}
    >
      🌮 Restaurante 
    </h1>

    <p
      style={{
        marginTop: 8,
        color: "#6b4f3b",
        fontSize: 18,
      }}
    >
      Control total de mesas y órdenes en tiempo real
    </p>
  </div>

  <div
    style={{
      display: "flex",
      gap: 14,
      flexWrap: "wrap",
    }}
  >
    <div
      style={{
        background: "white",
        padding: "16px 22px",
        borderRadius: 20,
        boxShadow: "0 10px 25px rgba(0,0,0,0.08)",
      }}
    >
      <small style={{ color: "#666" }}>Mesas libres</small>
      <h2 style={{ margin: 0, color: "#16a34a" }}>
        {mesas.filter((m) => estadoMesaVisual(m) === "Libre").length}
      </h2>
    </div>

    <div
      style={{
        background: "white",
        padding: "16px 22px",
        borderRadius: 20,
        boxShadow: "0 10px 25px rgba(0,0,0,0.08)",
      }}
    >
      <small style={{ color: "#666" }}>Ocupadas</small>
      <h2 style={{ margin: 0, color: "#dc2626" }}>
        {
          mesas.filter(
            (m) =>
              estadoMesaVisual(m) !== "Libre"
          ).length
        }
      </h2>
    </div>

    <div
      style={{
        background: "white",
        padding: "16px 22px",
        borderRadius: 20,
        boxShadow: "0 10px 25px rgba(0,0,0,0.08)",
      }}
    >
      <small style={{ color: "#666" }}>Ventas hoy</small>
      <h2 style={{ margin: 0, color: "#2563eb" }}>
        {cantidadVentas}
      </h2>
    </div>
  </div>
</div>

          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(4, 1fr)",
              gap: 16,
            }}
          >
            {mesas.map((mesa) => (
  <button
    key={mesa.id}
    onClick={() => setMesaId(mesa.id)}
    style={{
      border: "none",
      borderRadius: 28,
      overflow: "hidden",
      cursor: "pointer",
      position: "relative",
      minHeight: 260,
      background: "transparent",
      padding: 0,
      boxShadow: "0 18px 35px rgba(0,0,0,0.18)",
      transition: "transform 0.2s ease",
    }}
  >
    <div
      style={{
        position: "absolute",
        inset: 0,
        backgroundImage:
          "url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1400&auto=format&fit=crop')",
        backgroundSize: "cover",
        backgroundPosition: "center",
        filter: "brightness(0.45)",
      }}
    />

    <div
      style={{
        position: "absolute",
        inset: 0,
        background:
          estadoMesaVisual(mesa) === "Libre"
            ? "linear-gradient(180deg, rgba(22,163,74,0.15), rgba(22,163,74,0.8))"
            : estadoMesaVisual(mesa) === "Preparando"
            ? "linear-gradient(180deg, rgba(37,99,235,0.15), rgba(37,99,235,0.8))"
            : estadoMesaVisual(mesa) === "Orden lista (recoger)"
            ? "linear-gradient(180deg, rgba(245,158,11,0.15), rgba(245,158,11,0.85))"
            : estadoMesaVisual(mesa) === "Cuenta solicitada"
            ? "linear-gradient(180deg, rgba(147,51,234,0.15), rgba(147,51,234,0.8))"
            : "linear-gradient(180deg, rgba(220,38,38,0.15), rgba(220,38,38,0.85))",
      }}
    />

    <div
      style={{
        position: "relative",
        zIndex: 2,
        height: "100%",
        padding: 22,
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        color: "white",
        textAlign: "left",
      }}
    >
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <div
          style={{
            background: "rgba(255,255,255,0.15)",
            backdropFilter: "blur(6px)",
            padding: "10px 14px",
            borderRadius: 999,
            fontWeight: "bold",
            fontSize: 14,
          }}
        >
          🌮 Restaurante Mexicano
        </div>

        <div style={{ fontSize: 34 }}>🌵</div>
      </div>

      <div>
        <h1
          style={{
            margin: 0,
            fontSize: 42,
            fontWeight: 900,
          }}
        >
          {mesa.nombre}
        </h1>

        <div
          style={{
            marginTop: 14,
            display: "inline-block",
            padding: "10px 18px",
            borderRadius: 999,
            background: "rgba(255,255,255,0.18)",
            backdropFilter: "blur(5px)",
            fontWeight: "bold",
            fontSize: 15,
          }}
        >
          {estadoMesaVisual(mesa)}
        </div>
      </div>
    </div>
  </button>
))}
          </div>
        </div>
      )}

      {vista === "mesas" && puedeUsarMesas && mesaSeleccionada && (
        <div>
          <div className="no-print">
            <button onClick={() => setMesaId(null)} style={btn}>
              ← Volver
            </button>

            <h2>{mesaSeleccionada.nombre}</h2>
            <p>
              Estado: <strong>{estadoMesaVisual(mesaSeleccionada)}</strong>
            </p>

            {(rol === "Admin" || rol === "Mesero") && (
              <>
                <h3>Productos disponibles</h3>

                <div style={{ display: "flex", gap: 10, flexWrap: "wrap" }}>
                  {productos
                    .filter(
                      (producto) =>
                        !mesaSeleccionada.orden.some(
                          (item) => item.id === producto.id
                        )
                    )
                    .map((producto) => (
                      <button
                        key={producto.id}
                        onClick={() => agregarProducto(producto)}
                        style={productoBtn}
                      >
                        <strong>{producto.nombre}</strong>
                        <br />
                        <small>{producto.categoria}</small>
                        <br />
                        {formatoCRC(producto.precio)}
                      </button>
                    ))}
                </div>
              </>
            )}

            <h3 style={{ marginTop: 30 }}>Orden</h3>

            {mesaSeleccionada.orden.length === 0 && (
              <p>No hay productos en esta mesa.</p>
            )}

            {mesaSeleccionada.orden.map((item) => (
              <div key={item.id} style={itemRow}>
                <div style={{ flex: 1 }}>
                  <strong>{item.nombre}</strong>
                  <br />
                  <small>
                    {item.enviadoCocina
                      ? `En cocina: ${item.estadoCocina}`
                      : "Sin enviar a cocina"}
                  </small>
                  <br />
                  {(rol === "Admin" || rol === "Mesero") && (
                    <input
                      value={item.nota || ""}
                      onChange={(e) => cambiarNota(item.id, e.target.value)}
                      placeholder="Nota: sin cebolla, término medio..."
                      style={{ width: "90%", marginTop: 6, padding: 8 }}
                    />
                  )}
                </div>

                {(rol === "Admin" || rol === "Mesero") && (
                  <div>
                    <button
                      onClick={() => cambiarCantidad(item.id, -1)}
                      style={qtyBtn}
                    >
                      -
                    </button>
                    <span style={{ margin: "0 10px" }}>{item.cantidad}</span>
                    <button
                      onClick={() => cambiarCantidad(item.id, 1)}
                      style={qtyBtn}
                    >
                      +
                    </button>
                  </div>
                )}

                <strong>{formatoCRC(item.precio * item.cantidad)}</strong>

                {(rol === "Admin" || rol === "Mesero") && (
                  <button
                    onClick={() => eliminarProducto(item.id)}
                    style={{
                      ...qtyBtn,
                      background: "#fee2e2",
                      color: "#dc2626",
                      fontWeight: "bold",
                    }}
                  >
                    🗑️
                  </button>
                )}
              </div>
            ))}

            <h2>Total: {formatoCRC(total)}</h2>

            {puedeCobrar && (
  <>
    <h3>Método de pago</h3>

    <select
      value={metodoPago}
      onChange={(e) => setMetodoPago(e.target.value as MetodoPago)}
      style={input}
    >
      <option>Efectivo</option>
      <option>Tarjeta</option>
      <option>SINPE</option>
      <option>Mixto</option>
    </select>

    {(metodoPago === "Efectivo" || metodoPago === "Mixto") && (
      <div style={{ marginTop: 12 }}>
        <label>
          <strong>Monto recibido</strong>
        </label>
        <br />
        <input
          type="number"
          value={montoRecibido}
          onChange={(e) => setMontoRecibido(Number(e.target.value))}
          placeholder="Ej: 10000"
          style={input}
        />

        <h3>
          Vuelto:{" "}
          {formatoCRC(
            montoRecibido > total ? montoRecibido - total : 0
          )}
        </h3>
      </div>
    )}
  </>
)}

           <div style={{ display: "flex", gap: 10, marginTop: 20 }}>
  {(rol === "Admin" || rol === "Mesero") && (
    <button
      onClick={enviarACocina}
      style={{ ...btn, background: "#16a34a", color: "white" }}
    >
      Enviar a cocina
    </button>
  )}

  {(rol === "Admin" || rol === "Mesero") && (
    <button
      onClick={solicitarCuenta}
      style={{ ...btn, background: "#f59e0b", color: "white" }}
    >
      Solicitar cuenta
    </button>
  )}

  {(rol === "Admin" || rol === "Mesero") &&
    estadoMesaVisual(mesaSeleccionada) === "Orden lista (recoger)" && (
      <button
        onClick={retirarOrdenLista}
        style={{ ...btn,background: "#2563eb", color: "white" }}
      >
        Listo / Retirado
      </button>
    )}

  

  {puedeCobrar && (
    <button
      onClick={cobrar}
      style={{ ...btn, background: "#2563eb", color: "white" }}
    >
      Cobrar
    </button>
  )}
</div>
          </div>

          <div id="recibo" style={{ display: "none" }}>
  {reciboActual && (
    <>
      <div style={{ textAlign: "center" }}>
        <h2>RESTAURANTE</h2>
        <p>Comprobante de pago</p>
        <p>{reciboActual.fecha}</p>
      </div>

      <hr />

      <p>
        <strong>Mesa:</strong> {reciboActual.mesa}
      </p>

      <p>
        <strong>Pago:</strong> {reciboActual.metodoPago}
      </p>

      {(reciboActual.metodoPago === "Efectivo" ||
        reciboActual.metodoPago === "Mixto") && (
        <>
          <p>
            <strong>Recibido:</strong>{" "}
            {formatoCRC(reciboActual.montoRecibido)}
          </p>

          <p>
            <strong>Vuelto:</strong>{" "}
            {formatoCRC(reciboActual.vuelto)}
          </p>
        </>
      )}

      <hr />

      {reciboActual.items.map((item) => (
        <div key={item.id}>
          <p style={{ display: "flex", justifyContent: "space-between" }}>
            <span>
              {item.cantidad}x {item.nombre}
            </span>
            <strong>{formatoCRC(item.precio * item.cantidad)}</strong>
          </p>

          {item.nota && <small>Nota: {item.nota}</small>}
        </div>
      ))}

      <hr />

      <h3 style={{ display: "flex", justifyContent: "space-between" }}>
        <span>TOTAL</span>
        <span>{formatoCRC(reciboActual.total)}</span>
      </h3>

      <p style={{ textAlign: "center" }}>Gracias por su visita</p>
    </>
      )}
 </div>
        </div>
      )}

      {vista === "cocina" && !puedeUsarCocina && (
        <p>No tenés acceso a cocina con este rol.</p>
      )}

      {vista === "cocina" && puedeUsarCocina && (
        <div className="no-print">
          <div
  style={{
    marginBottom: 30,
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    flexWrap: "wrap",
    gap: 20,
  }}
>
  <div>
    <h1
      style={{
        fontSize: 54,
        margin: 0,
        color: "#7c2d12",
        fontWeight: 900,
      }}
    >
      👨‍🍳 Cocina 
    </h1>

    <p
      style={{
        color: "#6b4f3b",
        marginTop: 8,
        fontSize: 18,
      }}
    >
      Monitor en tiempo real de preparación
    </p>
  </div>

  <div
    style={{
      background: "white",
      padding: "18px 24px",
      borderRadius: 22,
      boxShadow: "0 10px 25px rgba(0,0,0,0.08)",
    }}
  >
    <small style={{ color: "#666" }}>Pedidos activos</small>

    <h1
      style={{
        margin: 0,
        color: "#dc2626",
      }}
    >
      {itemsCocina.length}
    </h1>
  </div>
</div>

          {itemsCocina.length === 0 && <p>No hay pedidos pendientes.</p>}

          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(3, 1fr)",
              gap: 20,
            }}
          >
            {itemsCocina.map((item) => (
              <div
                key={`${item.mesaId}-${item.id}`}
                style={{
                  background:
                    item.estadoCocina === "Pendiente"
                      ? "#fee2e2"
                      : item.estadoCocina === "Preparando"
                      ? "#dbeafe"
                      : "#dcfce7",
                  borderRadius: 18,
                  padding: 25,
                  minHeight: 190,
                  border: "2px solid white",
                }}
              >
                <h2>{item.mesaNombre}</h2>
                <h1>
                  {item.cantidad}x {item.nombre}
                </h1>

                {item.nota && <p>Nota: {item.nota}</p>}

                <h3>{item.estadoCocina}</h3>

                <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
                  <button
                    onClick={() =>
                      cambiarEstadoItem(item.mesaId, item.id, "Pendiente")
                    }
                    style={btn}
                  >
                    Pendiente
                  </button>

                  <button
                    onClick={() =>
                      cambiarEstadoItem(item.mesaId, item.id, "Preparando")
                    }
                    style={{ ...btn, background: "#2563eb", color: "white" }}
                  >
                    Preparando
                  </button>

                  <button
                    onClick={() =>
                      cambiarEstadoItem(item.mesaId, item.id, "Listo")
                    }
                    style={{ ...btn, background: "#16a34a", color: "white" }}
                  >
                    Listo
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
      {vista === "cierre" && puedeCerrarCaja && (
  <div className="no-print">
    <h2>Cierre de caja</h2>

    <div
      style={{
        display: "grid",
        gridTemplateColumns: "repeat(4, 1fr)",
        gap: 20,
      }}
    >
      <div style={statCard}>
        <h3>Efectivo</h3>
        <h1>
          {formatoCRC(
            ventas
              .filter((v) => v.metodoPago === "Efectivo")
              .reduce((acc, v) => acc + v.total, 0)
          )}
        </h1>
      </div>

      <div style={statCard}>
        <h3>Tarjeta</h3>
        <h1>
          {formatoCRC(
            ventas
              .filter((v) => v.metodoPago === "Tarjeta")
              .reduce((acc, v) => acc + v.total, 0)
          )}
        </h1>
      </div>

      <div style={statCard}>
        <h3>SINPE</h3>
        <h1>
          {formatoCRC(
            ventas
              .filter((v) => v.metodoPago === "SINPE")
              .reduce((acc, v) => acc + v.total, 0)
          )}
        </h1>
      </div>

      <div style={statCard}>
        <h3>Total</h3>
        <h1>
          {formatoCRC(
            ventas.reduce((acc, v) => acc + v.total, 0)
          )}
        </h1>
      </div>
    </div>

    <button
      onClick={cerrarCaja}
      style={{
        ...btn,
        background: "#dc2626",
        color: "white",
        marginTop: 20,
      }}
    >
      Cerrar caja
    </button>

    {puedeExportarPDF && (
  <>
    <h3 style={{ marginTop: 30 }}>Historial cierres</h3>

    {cierresCaja.length === 0 && (
      <p>No hay cierres registrados.</p>
    )}

    {cierresCaja.map((cierre) => (
      <div
        key={cierre.id}
        style={{
          ...itemRow,
          flexDirection: "column",
          alignItems: "flex-start",
        }}
      >
        <div
          style={{
            width: "100%",
            display: "flex",
            justifyContent: "space-between",
          }}
        >
          <div>
            <strong>{cierre.fecha}</strong>
            <br />
            <small>{cierre.cantidadVentas} ventas procesadas</small>
          </div>

          <strong>{formatoCRC(cierre.totalGeneral)}</strong>
        </div>

        <div
          style={{
            marginTop: 12,
            display: "grid",
            gridTemplateColumns: "repeat(4, 1fr)",
            width: "100%",
            gap: 10,
          }}
        >
          <div>
            <small>Efectivo</small>
            <br />
            <strong>{formatoCRC(cierre.totalEfectivo)}</strong>
          </div>

          <div>
            <small>Tarjeta</small>
            <br />
            <strong>{formatoCRC(cierre.totalTarjeta)}</strong>
          </div>

          <div>
            <small>SINPE</small>
            <br />
            <strong>{formatoCRC(cierre.totalSinpe)}</strong>
          </div>

          <div>
            <small>Mixto</small>
            <br />
            <strong>{formatoCRC(cierre.totalMixto)}</strong>
          </div>
        </div>

        <button
          onClick={() => exportarCierrePDF(cierre)}
          style={{
            ...btn,
            marginTop: 14,
            background: "#2563eb",
            color: "white",
          }}
        >
          Exportar PDF
        </button>
      </div>
    ))}
  </>
)}
  </div>
)}
{vista === "qr" && rol === "Admin" && (
  <div className="no-print">
    <h2>QR de mesas</h2>
    
    <p>Estos enlaces abren el menú digital de cada mesa.</p>
    <button
  onClick={imprimirQR}
  style={{
    ...btn,
    background: "#16a34a",
    color: "white",
    marginBottom: 20,
  }}
>
  Imprimir QR de mesas
</button>

    <div
  className="qr-print"
  style={{
    display: "grid",
    gridTemplateColumns: "repeat(3, 1fr)",
    gap: 20,
  }}
>
      {mesas.map((mesa) => {
        const url = `${window.location.origin}${window.location.pathname}?mesa=${mesa.id}&menu=1`;

        return (
          <div
            key={mesa.id}
            style={{
              background: "white",
              borderRadius: 16,
              padding: 18,
              border: "1px solid #ddd",
            }}
          >
            <h3>{mesa.nombre}</h3>
              <div style={{ textAlign: "center", marginBottom: 14 }}>
  <QRCodeCanvas value={url} size={150} />
</div>
            <div
              style={{
                background: "#f3f4f6",
                padding: 10,
                borderRadius: 10,
                wordBreak: "break-all",
                fontSize: 12,
                marginBottom: 12,
              }}
            >
              {url}
            </div>

            <button
              onClick={() => copiarLinkQR(mesa.id)}
              style={{
                ...btn,
                background: "#2563eb",
                color: "white",
                width: "100%",
              }}
            >
              Copiar link
            </button>
          </div>
        );
      })}
    </div>
  </div>
)}{vista === "productos" && rol === "Admin" && (
  <div className="no-print">
    <h2>Administrar productos</h2>

    <div
      style={{
        background: "white",
        padding: 20,
        borderRadius: 16,
        marginBottom: 20,
      }}
    >
      <h3>Nuevo producto</h3>

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(4, 1fr)",
          gap: 12,
        }}
      >
        <input
          placeholder="Nombre"
          value={nuevoProducto.nombre}
          onChange={(e) =>
            setNuevoProducto((prev) => ({
              ...prev,
              nombre: e.target.value,
            }))
          }
          style={input}
        />

        <select
          value={nuevoProducto.categoria}
          onChange={(e) =>
            setNuevoProducto((prev) => ({
              ...prev,
              categoria: e.target.value,
            }))
          }
          style={input}
        >
          <option>Comidas</option>
          <option>Bebidas</option>
          <option>Postres</option>
        </select>

        <input
          type="number"
          placeholder="Precio"
          value={nuevoProducto.precio}
          onChange={(e) =>
            setNuevoProducto((prev) => ({
              ...prev,
              precio: Number(e.target.value),
            }))
          }
          style={input}
        />

        <button
          onClick={crearProducto}
          style={{
            ...btn,
            background: "#16a34a",
            color: "white",
          }}
        >
          Crear producto
        </button>
      </div>
    </div>

    <div
      style={{
        display: "grid",
        gridTemplateColumns: "repeat(3, 1fr)",
        gap: 16,
      }}
    >
      {productos.map((producto) => (
  <div
    key={producto.id}
    style={{
      background: "white",
      padding: 18,
      borderRadius: 16,
      border: "1px solid #ddd",
    }}
  >
    <input
      value={producto.nombre}
      onChange={(e) =>
        actualizarProducto(producto.id, "nombre", e.target.value)
      }
      style={{
        ...input,
        width: "100%",
        marginBottom: 10,
      }}
    />

    <select
      value={producto.categoria}
      onChange={(e) =>
        actualizarProducto(producto.id, "categoria", e.target.value)
      }
      style={{
        ...input,
        width: "100%",
        marginBottom: 10,
      }}
    >
      <option>Comidas</option>
      <option>Bebidas</option>
      <option>Postres</option>
    </select>

    <input
      type="number"
      value={producto.precio}
      onChange={(e) =>
        actualizarProducto(
          producto.id,
          "precio",
          Number(e.target.value)
        )
      }
      style={{
        ...input,
        width: "100%",
        marginBottom: 14,
      }}
    />

    <button
      onClick={() => eliminarProductoAdmin(producto.id)}
      style={{
        ...btn,
        background: "#dc2626",
        color: "white",
        width: "100%",
      }}
    >
      Eliminar
    </button>
  </div>
))}
    </div>
  </div>
)}
{vista === "usuarios" && rol === "Admin" && (
  <div className="no-print">
    <h2>Administrar usuarios</h2>

    <div style={{ background: "white", padding: 20, borderRadius: 16 }}>
      <h3>Nuevo usuario</h3>

      <input placeholder="Usuario" value={nuevoUsuario.usuario}
        onChange={(e) => setNuevoUsuario({ ...nuevoUsuario, usuario: e.target.value })}
        style={input}
      />

      <input placeholder="Nombre" value={nuevoUsuario.nombre}
        onChange={(e) => setNuevoUsuario({ ...nuevoUsuario, nombre: e.target.value })}
        style={input}
      />

      <input placeholder="Contraseña" value={nuevoUsuario.password}
        onChange={(e) => setNuevoUsuario({ ...nuevoUsuario, password: e.target.value })}
        style={input}
      />

      <select value={nuevoUsuario.rol}
        onChange={(e) => setNuevoUsuario({ ...nuevoUsuario, rol: e.target.value as Rol })}
        style={input}
      >
        <option>Admin</option>
        <option>Caja</option>
        <option>Cocina</option>
        <option>Mesero</option>
      </select>

      <button onClick={crearUsuario} style={{ ...btn, background: "#16a34a", color: "white" }}>
        Crear usuario
      </button>
    </div>

    <h3>Usuarios existentes</h3>

    {usuarios.map((u) => (
      <div key={u.usuario} style={itemRow}>
        <input value={u.usuario} disabled style={input} />

        <input value={u.nombre}
          onChange={(e) => actualizarUsuario(u.usuario, "nombre", e.target.value)}
          style={input}
        />

        <input value={u.password}
          onChange={(e) => actualizarUsuario(u.usuario, "password", e.target.value)}
          style={input}
        />

        <select value={u.rol}
          onChange={(e) => actualizarUsuario(u.usuario, "rol", e.target.value)}
          style={input}
        >
          <option>Admin</option>
          <option>Caja</option>
          <option>Cocina</option>
          <option>Mesero</option>
        </select>

        <button onClick={() => eliminarUsuario(u.usuario)} style={{ ...btn, background: "#dc2626", color: "white" }}>
          Eliminar
        </button>
      </div>
    ))}
  </div>
)}
      {vista === "estadisticas" && puedeVerStats && (
        <div className="no-print">
          <h2>Estadísticas</h2>

          <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 20 }}>
            <div style={statCard}>
              <h3>Ventas</h3>
              <h1>{cantidadVentas}</h1>
            </div>

            <div style={statCard}>
              <h3>Total vendido</h3>
              <h1>{formatoCRC(totalVendido)}</h1>
            </div>

            <div style={statCard}>
              <h3>Más vendido</h3>
              <h1>{productoMasVendido}</h1>
            </div>
          </div>

          <h3>Últimas ventas</h3>

          {ventas.length === 0 && <p>No hay ventas registradas.</p>}

          {ventas.map((venta) => (
            <div key={venta.id} style={itemRow}>
              <div>
                <strong>{venta.mesa}</strong>
                <br />
                <small>{venta.fecha}</small>
              </div>

              <strong>{venta.metodoPago}</strong>
              <strong>{formatoCRC(venta.total)}</strong>
            </div>
          ))}
        </div>
      )}
  </div>
</div>
</div>
  );
}
const appShell: React.CSSProperties = {
  minHeight: "100vh",
  background: "linear-gradient(135deg, #fff7e6 0%, #f3e1c8 100%)",
  fontFamily: "Arial, sans-serif",
  padding: 20,
};
const loginPage: React.CSSProperties = {
  minHeight: "100vh",
  background: "#111827",
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
  fontFamily: "Arial",
};

const loginCard: React.CSSProperties = {
  background: "white",
  padding: 30,
  borderRadius: 20,
  width: 360,
  textAlign: "center",
};

const loginBtn: React.CSSProperties = {
  padding: 16,
  border: "none",
  borderRadius: 12,
  cursor: "pointer",
  background: "#2563eb",
  color: "white",
  fontWeight: "bold",
};

const btn: React.CSSProperties = {
  padding: "12px 16px",
  border: "none",
  borderRadius: 10,
  cursor: "pointer",
  background: "#e5e7eb",
  fontWeight: "bold",
};

const productoBtn: React.CSSProperties = {
  padding: 18,
  borderRadius: 12,
  border: "1px solid #ddd",
  cursor: "pointer",
  background: "white",
  minWidth: 150,
};

const itemRow: React.CSSProperties = {
  background: "white",
  padding: 15,
  borderRadius: 12,
  marginBottom: 10,
  display: "flex",
  alignItems: "center",
  justifyContent: "space-between",
  gap: 20,
};

const qtyBtn: React.CSSProperties = {
  padding: "8px 12px",
  border: "none",
  borderRadius: 8,
  cursor: "pointer",
};

const input: React.CSSProperties = {
  padding: 12,
  borderRadius: 8,
  border: "1px solid #ccc",
  minWidth: 200,
};

const statCard: React.CSSProperties = {
  background: "white",
  padding: 25,
  borderRadius: 16,
};