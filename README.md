# Econauta

Simulador educativo de política económica para estudiantes universitarios.

Econauta permite administrar una economía ficticia, aplicar decisiones de
política fiscal y monetaria, y observar sus consecuencias sobre el crecimiento,
la inflación, el empleo, el déficit y la deuda pública.

---

## Descripción

La aplicación convierte los modelos macroeconómicos que se estudian en clase en
una experiencia práctica: el estudiante decide, ejecuta periodos y recibe
explicaciones sobre por qué cambiaron los indicadores. Todo el cálculo ocurre en
el dispositivo, sin conexión a Internet.

## Objetivo

Enseñar economía aplicada mediante la simulación de decisiones públicas y la
observación de sus consecuencias, cerrando la distancia entre la teoría
macroeconómica y la evaluación real de políticas.

### Problema educativo que resuelve

Los estudiantes comprenden los modelos económicos, pero tienen poca experiencia
observando cómo las políticas afectan el crecimiento, la estabilidad, la
inflación y el empleo a lo largo del tiempo.

## Usuarios

- Estudiantes de Economía.
- Estudiantes de Administración Pública.
- Estudiantes de Finanzas y áreas relacionadas.

### Competencias que desarrolla

- Análisis macroeconómico básico.
- Evaluación de políticas públicas.
- Interpretación de indicadores.
- Toma de decisiones económicas.
- Análisis de consecuencias y riesgos.

## Módulos

| # | Módulo | Qué permite hacer |
|---|--------|-------------------|
| 1 | Inflación | Ver inflación actual, meta, brecha, variación y explicación |
| 2 | PIB y crecimiento | Ver PIB, crecimiento, consumo, inversión y gasto público |
| 3 | Mercado laboral | Ver empleo, desempleo, holgura y su variación |
| 4 | Política fiscal | Modificar impuestos y gasto público, y ver sus efectos |
| 5 | Política monetaria | Modificar la tasa de interés y la meta de inflación |
| 6 | Simulación | Ejecutar de 1 a 5 periodos y comparar resultados |
| 7 | Evaluación | Responder preguntas cortas con retroalimentación |
| 8 | Analista económico | Recibir explicaciones locales de cada resultado |

## Tecnologías

- Flutter (canal estable) y Dart.
- Material 3, interfaz en español.
- Aplicación Android, diseño adaptable para teléfonos.
- Funcionamiento local, sin conexión, sin API externa y sin claves secretas.
- Sin dependencias de terceros: solo el SDK de Flutter y `flutter_lints`.
- Arquitectura simple por capas: `models`, `calculators`, `services`,
  `screens`, `widgets`.

## Estructura del proyecto

```text
lib/
  main.dart
  app.dart
  models/        # Estado económico, políticas, preguntas, constantes
  calculators/   # Reglas puras: inflación, PIB, empleo, fiscal, monetaria
  screens/       # Una pantalla por módulo
  widgets/       # Tarjetas, gráficos, controles reutilizables
  services/      # Motor de simulación, analista local, estado de la app
test/            # Pruebas unitarias y de widget
docs/            # Guía de uso, indicadores, supuestos y limitaciones
```

## Cómo ejecutar la app

```bash
flutter pub get
flutter run
```

Para ejecutar en un dispositivo o emulador Android específico:

```bash
flutter devices
flutter run -d <id-del-dispositivo>
```

## Cómo ejecutar las pruebas

```bash
flutter test
```

Verificación completa equivalente a la de integración continua:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

> Si el verificador de formato reporta diferencias por la versión del
> formateador de tu SDK, ejecuta `dart format .` y confirma los cambios.

## Cómo generar el APK

```bash
flutter build apk --release
```

El archivo generado es un APK universal único:

```text
build/app/outputs/flutter-apk/app-release.apk
```

También puede generarse desde GitHub Actions:

- Flujo `Flutter CI`: se ejecuta en `push` a `main` y `develop`, y en cada
  `pull_request` hacia `main`.
- Flujo `Build APK`: se ejecuta manualmente (`workflow_dispatch`) o al publicar
  una etiqueta con formato `v*`. Sube el artefacto `econauta-apk`.

### Identidad Android

- `applicationId`: `com.josuecr1801.econauta`
- `namespace`: `com.josuecr1801.econauta`
- Nombre visible: **Econauta**

## Advertencia sobre el uso educativo

Econauta utiliza reglas económicas simplificadas y transparentes, creadas con
fines didácticos. **No es una predicción económica, no representa a ningún país
real y no reemplaza modelos econométricos ni el análisis profesional.** Los
supuestos del modelo están documentados en `docs/README.md` para que puedan
discutirse y cuestionarse en clase.

## Licencia y uso

Proyecto educativo. Puede utilizarse y adaptarse con fines académicos citando
su origen.
