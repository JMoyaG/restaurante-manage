POS Restaurante - Gato Calavera Pacayas

Cambios incluidos:
- Roles multirol reales con checkboxes: Jefe, Admin, Caja y Mesero.
- Cocina eliminado del sistema.
- Un usuario puede tener Caja + Mesero marcado al mismo tiempo.
- Caja puede tomar pedidos, crear pedidos para llevar, cobrar, abrir caja y cerrar caja.
- Caja NO ve usuarios, QR, productos, movimientos delicados, detalle del turno ni historial detallado de cierres.
- Caja solo ve el último cierre resumido del día cuando la caja está cerrada.
- Cuando Caja abre caja, el último cierre se oculta.
- Admin y Jefe mantienen acceso completo al detalle de turno, movimientos, salidas, historial de cierres, QR y productos.
- Solo Jefe puede crear/modificar usuarios.
- Menú QR público con diseño oscuro SPECIAL MENU, ajustable automáticamente a celular, tablet, laptop y POS.

QR público:
- Si imprimís QR desde Vercel, el link queda público automáticamente.
- Si imprimís QR desde localhost, el celular no podrá abrirlo porque localhost apunta al propio celular.
- Para forzar un dominio público en los QR, podés crear un archivo .env con:
  VITE_MENU_PUBLIC_URL=https://tu-dominio.vercel.app

Usuarios iniciales:
jefe / 1234
admin / 1234
caja / 1234
caja_mesero / 1234
mesero / 1234

Ejecutar:
npm install
npm run dev
