# TransporteMX 2024 — Análisis de Desempeño Logístico

**Autor:** Andrea Galicia  
**Fecha:** Junio 2026  
**Herramientas:** PostgreSQL 18 · pgAdmin 4 · Power BI  

---

## Descripción del proyecto

Análisis del desempeño operativo de una empresa de logística en México, enfocado en tres áreas clave: rentabilidad por ruta, puntualidad en entregas y costos de falla por conductor.

El objetivo es detectar áreas de mejora y apoyar la toma de decisiones operativas con base en datos.

---

## Estructura de los datos

El dataset fue construido de forma sintética para simular las operaciones reales de una empresa de transporte. Contiene cuatro tablas relacionadas:

| Tabla | Descripción |
|---|---|
| `conductores` | Información de conductores y tipo de vehículo |
| `clientes` | Clientes registrados, ciudad y segmento |
| `rutas` | Rutas activas con origen, destino y tarifa por kg |
| `envios` | Registro de envíos con fechas, costos, retrasos y estatus |

---

## Análisis realizado

### 1. ¿Qué ruta genera más ingreso?

Se calculó el ingreso total por ruta usando `SUM(costo_envio_mxn)` con un `JOIN` entre `envios` y `rutas`.

**Hallazgos principales:**
- Ciudad de México – Tijuana: **$3,026,879.18**
- Ciudad de México – Culiacán: **$1,170,467.84**
- Ciudad de México – Mérida: **$1,143,170.79**

---

### 2. ¿Qué ruta tiene más envíos retrasados?

Se filtraron los envíos con `estatus = 'Retrasado'` y se agruparon por ruta.

**Hallazgos principales:**
- La ruta **CDMX – Tijuana** es la de mayor ingreso *y* una de las más retrasadas → oportunidad clara de mejora.
- **CDMX – Querétaro:** 19 envíos retrasados.
- **CDMX – Monterrey:** 14 envíos retrasados.

---

### 3. ¿Cuál conductor tiene el mayor costo de falla acumulado?

Se calculó el costo de falla por conductor en valor absoluto y en porcentaje del total.

**Hallazgos principales:**

| Conductor | Costo de falla | % del total |
|---|---|---|
| Jorge Mendoza | $18,155.20 | 10.36% |
| Sergio Reyes Ibarra | $17,509.11 | 10.00% |
| Enrique Vargas | $15,027.09 | 8.58% |

---

## 💡 Conclusiones

1. La ruta **CDMX – Tijuana** es el mayor generador de ingresos de la empresa, pero también concentra un alto número de retrasos. Reducirlos representaría un aumento directo en rentabilidad.
2. Las rutas **CDMX – Querétaro** y **CDMX – Monterrey** requieren una revisión operativa urgente por su nivel de incumplimiento en tiempos de entrega.
3. Tres conductores concentran casi el **29% del costo de falla total**, lo que justifica una revisión de desempeño individual.

---

## Archivos del repositorio

```
📂 TransporteMX-2024/
├── 📄 README.md
├── 📄 Análisis de Desempeño Logístico 2024.sql
└── Dashboard Power BI
```

---

*Proyecto de portafolio — datos sintéticos diseñados para fines de análisis y aprendizaje.*
