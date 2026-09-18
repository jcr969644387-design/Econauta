# Changelog

Todas las versiones relevantes de Econauta se documentan en este archivo.

## [1.0.2] - 2026-09-18

### Agregado

- Pantalla independiente de Configuracion con sonido, vibracion, tema e
  informacion del proyecto, accesible desde el engranaje de la pantalla
  principal.
- Efectos de sonido cortos para pulsar, confirmar, completar, desbloquear un
  logro y acertar o fallar una respuesta.
- Vibracion nativa con cuatro intensidades: suave, exito, advertencia y error.
- Tema oscuro y opcion de seguir el tema del sistema.
- Persistencia de las preferencias mediante un repositorio dedicado.

### Cambiado

- Todas las pantallas usan un contenedor comun que respeta el notch, la
  Dynamic Island, la barra de navegacion y la zona de gestos.
- Transiciones entre pantallas mas suaves, con desvanecido y desplazamiento.
- Microinteracciones en botones, tarjetas de indicadores y graficos.

## [1.0.0] - 2026-09-17

### Agregado

- Version inicial del MVP educativo Econauta.
- Modulo de inflacion con meta, brecha y explicacion educativa.
- Modulo de PIB y crecimiento con consumo, inversion y gasto publico.
- Modulo de mercado laboral con empleo, desempleo y variacion.
- Modulo de politica fiscal con impuestos y gasto publico ajustables.
- Modulo de politica monetaria con tasa de interes y meta de inflacion.
- Modulo de simulacion de 1 a 5 periodos con comparacion de resultados.
- Modulo de evaluacion con preguntas cortas y retroalimentacion.
- Analista economico local basado en reglas, sin Internet ni claves.
- Pruebas unitarias de calculadoras y prueba de widget de la pantalla principal.
- Flujos de trabajo de GitHub Actions para integracion continua y APK.
