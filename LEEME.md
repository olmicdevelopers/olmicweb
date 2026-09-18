# Olmic Web — sitio de venta

## Publicar en GitHub Pages

1. Crea un repositorio público llamado `olmic-web`.
2. Sube `index.html` y la carpeta `img/`.
3. Settings → Pages → Source: `main` / carpeta raíz → Save.
4. En 1-2 minutos queda en `https://TUUSUARIO.github.io/olmic-web`.

Para dominio propio: compra el dominio y en Settings → Pages → Custom domain lo conectas. GitHub te da HTTPS gratis.

---

## Añadir un producto nuevo

Abre `index.html`, busca `const PRODUCTOS`. Copia un bloque y cámbialo:

```js
{
  nombre: 'Plantilla Restaurante',
  etiqueta: 'Disponible',
  descripcion: 'Una línea que explique qué resuelve.',
  caracteristicas: ['Parallax', 'Responsiva'],
  precio: '$59.900',
  nota: 'Pago único · COP',
  imagen: 'img/restaurante.jpg',
  checkout: 'https://pay.hotmart.com/CODIGO',
  demo: 'https://demo-restaurante.netlify.app',
  disponible: true
}
```

- `disponible: false` → la tarjeta se ve atenuada y dice "Pronto".
- `demo: ''` → no aparece el botón de demo.
- Las imágenes van en `img/`, a 800x500 px.

## Tu WhatsApp

Al inicio del bloque de configuración:

```js
const WHATSAPP = '573000000000';
```

Indicativo de país, sin `+` ni espacios.

## El enlace de compra

En Hotmart: Productos → tu producto → Enlaces de venta. Copia el enlace de pago (`https://pay.hotmart.com/...`) y pégalo en `checkout`.

---

## Seguridad

Este sitio es HTML estático. No tiene servidor, base de datos, ni formularios que guarden información. Los pagos los procesa Hotmart en su propio dominio, así que ningún dato de tarjeta pasa por tu página. No hay superficie que atacar.

Los textos de los productos se escapan antes de insertarse en el HTML, así que aunque copies una descripción de cualquier lado no puede inyectar código.

Recomendaciones:
- No agregues scripts de terceros que no conozcas.
- Si algún día pones formularios, usa un servicio externo (Formspree, Netlify Forms). No montes backend propio si no lo necesitas.
