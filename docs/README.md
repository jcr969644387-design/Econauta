# Guía de Econauta

Documentación educativa del simulador: cómo usarlo, qué significan los
indicadores y qué supuestos utiliza el modelo.

---

## 1. Guía breve de uso

1. **Observa el punto de partida.** La pantalla principal muestra el panorama
   del periodo 0: crecimiento, inflación, desempleo y estabilidad.
2. **Define tu política fiscal.** En el módulo *Política fiscal* ajusta los
   impuestos y el gasto público, revisa el impulso estimado y pulsa
   *Aplicar política fiscal*.
3. **Define tu política monetaria.** En el módulo *Política monetaria* ajusta la
   tasa de interés y la meta de inflación, y pulsa *Aplicar política monetaria*.
4. **Ejecuta la simulación.** En el módulo *Simulación* elige entre 1 y 5
   periodos y pulsa *Ejecutar simulación*. La tabla compara los resultados.
5. **Lee el análisis.** El módulo *Analista económico* explica por qué cambió
   cada indicador respecto al periodo anterior.
6. **Evalúa lo aprendido.** El módulo *Evaluación* presenta preguntas cortas con
   retroalimentación y explicación.
7. **Reinicia cuando quieras.** El botón de reinicio devuelve la economía al
   estado inicial para probar una estrategia distinta.
8. **Ajusta la experiencia.** El engranaje de la pantalla principal abre
   *Configuración*, donde puedes activar o desactivar los sonidos y la
   vibración, y elegir tema claro, oscuro o el del sistema.

### Ejercicio sugerido

Intenta bajar la inflación a la meta sin llevar el desempleo por encima del
9 % ni el déficit por encima del 3 % del PIB en cinco periodos. Luego compara
tu resultado con el de un compañero y discutan los costos de cada estrategia.

---

## 2. Descripción de los módulos

| Módulo | Contenido |
|--------|-----------|
| Inflación | Inflación actual, meta, brecha, variación y evolución |
| PIB y crecimiento | PIB, tasa de crecimiento y componentes del gasto |
| Mercado laboral | Empleo, desempleo, holgura y evolución |
| Política fiscal | Impuestos y gasto público, impulso fiscal y déficit |
| Política monetaria | Tasa de interés, meta, impulso y tasa real |
| Simulación | Ejecución de 1 a 5 periodos y tabla comparativa |
| Evaluación | Diez preguntas de opción múltiple con explicación |
| Analista económico | Comentarios generados por reglas locales |
| Configuración | Sonido, vibración, tema e información del proyecto |

---

## 3. Explicación de los indicadores

| Indicador | Qué mide | Interpretación |
|-----------|----------|----------------|
| PIB | Producción total de la economía ficticia | Base 100 en el periodo 0 |
| Crecimiento | Variación porcentual del PIB | Potencial de referencia: 2.5 % |
| Consumo | Gasto de los hogares | Cae si suben impuestos o tasa |
| Inversión | Gasto de las empresas | Muy sensible a la tasa de interés |
| Gasto público | Gasto del Estado | Definido por la política fiscal |
| Inflación | Aumento general de precios | Se compara siempre con la meta |
| Meta de inflación | Compromiso del banco central | Ancla las expectativas |
| Desempleo | Porcentaje de la fuerza laboral sin empleo | Natural: 5 % |
| Empleo | 100 menos el desempleo | Población ocupada |
| Déficit fiscal | Gasto más intereses menos ingresos | Negativo significa superávit |
| Deuda pública | Deuda acumulada como % del PIB | Nivel de alerta: 60 % |
| Índice de estabilidad | Indicador educativo de 0 a 100 | 100 es el escenario ideal |

---

## 4. Supuestos del modelo

El modelo es **determinista, simple y transparente**: con la misma política y el
mismo punto de partida siempre entrega el mismo resultado.

### 4.1 Valores de referencia

| Parámetro | Valor |
|-----------|-------|
| Crecimiento potencial | 2.5 % |
| Desempleo natural | 5.0 % |
| Impuestos neutrales | 18.0 % del PIB |
| Gasto público neutral | 20.0 % del PIB |
| Tasa de interés neutral | 5.0 % |
| Déficit prudente | 3.0 % del PIB |
| Deuda de alerta | 60.0 % del PIB |

### 4.2 Reglas utilizadas

**Impulso de demanda**

```text
impulso_fiscal    = (gasto - 20) * 0.30 + (18 - impuestos) * 0.20
impulso_monetario = (5 - tasa) * 0.25
impulso_total     = impulso_fiscal + impulso_monetario
```

**Crecimiento del PIB**

```text
crecimiento = 2.5 + impulso_total
              - max(0, deuda - 60) * 0.02
              - max(0, inflacion - 10) * 0.10
crecimiento acotado entre -8 % y 10 %
PIB_siguiente = PIB * (1 + crecimiento / 100)
```

**Inflación**

```text
inflacion_siguiente = inflacion
                      + impulso_total * 0.45
                      - (desempleo - 5) * 0.10
                      + (meta - inflacion) * 0.15
acotada entre -5 % y 60 %
```

El segundo término representa una curva de Phillips simplificada y el tercero,
el anclaje de expectativas cuando la meta es creíble.

**Mercado laboral (ley de Okun simplificada)**

```text
desempleo_siguiente = desempleo - 0.5 * (crecimiento - 2.5)
acotado entre 1 % y 30 %
empleo = 100 - desempleo
```

**Resultado fiscal y deuda**

```text
ingresos  = impuestos + (crecimiento - 2.5) * 0.10
intereses = deuda * (tasa / 100) * 0.25
deficit   = gasto + intereses - ingresos
deuda_siguiente = (deuda + deficit) / (1 + (crecimiento + inflacion) / 100)
acotada entre 0 % y 200 %
```

**Componentes del gasto**

```text
consumo   = PIB * (0.60 - 0.005 * (impuestos - 18) - 0.004 * (tasa - 5))
inversion = PIB * (0.20 - 0.010 * (tasa - 5))
gasto     = PIB * gasto_publico / 100
```

**Índice educativo de estabilidad**

```text
indice = 100
         - |inflacion - meta| * 3.0
         - |desempleo - 5| * 2.5
         - max(0, deuda - 60) * 0.5
         - max(0, deficit - 3) * 3.0
         - max(0, 2 - crecimiento) * 2.0
acotado entre 0 y 100
```

### 4.3 Analista económico local

El analista funciona **sin Internet, sin API externa y sin claves secretas**.
Compara el estado anterior con el actual y aplica reglas de umbral para generar
siete comentarios: política aplicada, crecimiento, inflación, empleo, resultado
fiscal, deuda y estabilidad. Cada comentario tiene un tono (positivo, negativo o
neutral) y una explicación en lenguaje sencillo.

---

## 5. Limitaciones

- El modelo **no es una predicción** ni representa a ningún país real.
- No incluye sector externo, tipo de cambio, expectativas racionales,
  rezagos de política, choques de oferta ni distribución del ingreso.
- Las relaciones son lineales y los coeficientes fueron elegidos con criterio
  didáctico, no estimados econométricamente.
- Los resultados sirven para razonar sobre *dirección* y *costo relativo* de las
  decisiones, no sobre magnitudes reales.
- No reemplaza software profesional de modelación macroeconómica ni el análisis
  de un economista.

Estas limitaciones son parte del contenido educativo: reconocer los supuestos de
un modelo es una competencia central del análisis económico.
