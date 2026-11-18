# FINCTRL — Dashboard Financiero Personal

<p align="center">
  <img src="https://img.shields.io/badge/versi%C3%B3n-2.6%20MX-10b981?style=flat-square" alt="Versión" />
  <img src="https://img.shields.io/badge/stack-HTML5%20%7C%20TailwindCSS%20%7C%20Vanilla%20JS-3b82f6?style=flat-square" alt="Stack" />
  <img src="https://img.shields.io/badge/database-LocalStorage%20%2B%20Supabase%20PostgreSQL-059669?style=flat-square" alt="Base de Datos" />
  <img src="https://img.shields.io/badge/integraci%C3%B3n-Google%20Calendar%20API%20%26%20ICS-2563eb?style=flat-square" alt="Calendario" />
</p>

> Aplicación web interactiva para el control de presupuesto, dispersión de nómina y programación de pagos personales, desarrollada con HTML5, Tailwind CSS, JavaScript moderno y persistencia en PostgreSQL (Supabase).

Puedes ejecutar la aplicación web en vivo desde **[este enlace][live-demo]**, o bien consultar el código fuente principal en [index.html][app-entry] y el esquema relacional de base de datos en [supabase_schema.sql][db-schema].

## ¿En qué consiste el proyecto?

**FINCTRL — Dashboard Financiero Personal** es una herramienta web de gestión financiera diseñada como una evolución moderna, visual e intuitiva de un archivo de control de presupuesto en Excel.

A diferencia de las hojas de cálculo tradicionales que concentran decenas de columnas y fórmulas en una sola vista saturada, este proyecto implementa una arquitectura modular de tres pantallas con cálculos reactivos en tiempo real:

- **Diseño adaptable al sistema y codificado por estatus**: La interfaz detecta automáticamente el esquema de color del sistema operativo (Modo Claro u Oscuro) y utiliza una codificación cromática consistente para distinguir montos en estatus `Pendiente` (Ámbar), `Apartado` (Azul) y `Pagado` (Verde Esmeralda).
- **Tipografía optimizada para lectura financiera**: Combinación de `Inter` para jerarquía editorial y `JetBrains Mono` para cifras monetarias, porcentajes e indicadores de liquidez.
- **Componentes financieros interactivos**: Motor de cálculo automático de salario neto mensual, selector dinámico de frecuencia de pago (`Semanal`, `Quincenal`, `Mensual`), tarjetas de liquidez por periodo, matriz de seguimiento por categorías y conectores para sincronización con **Supabase (PostgreSQL)** y **Google Calendar**.

## Propósito

El objetivo principal de la aplicación es centralizar y simplificar la administración del ingreso mensual y los compromisos de pago personales, logrando que el usuario pueda:

1. **Conocer su liquidez real por periodo**: Calcular automáticamente el ingreso neto disponible por semana (`S1–S4`), quincena (`Q1–Q2`) o mes (`M1`) a partir del salario bruto mensual de carta oferta (por defecto `$40,000 MXN`) o de un monto neto personalizado.
2. **Controlar el flujo de efectivo en tiempo real**: Descontar automáticamente del saldo disponible únicamente aquellos conceptos cuyo estatus cambie a `Pagado` o `Apartado`, permitiendo visualizar cuánto dinero libre queda en cada semana.
3. **Clasificar egresos, ahorro e ingresos extras**: Organizar cada movimiento dentro de categorías claras (_Gastos Fijos Obligatorios_, _Ahorro / Inversión_, _Gustos / Ocio_, _Ingresos Extras_ y _Otros_ personalizados).
4. **Respaldar y sincronizar su historial mensual**: Conservar el registro histórico de cada mes tanto de manera local (`localStorage`) como en una base de datos relacional en la nube (`Supabase` / `DBeaver`) y en su calendario personal (`Google Calendar`).

## Organización de la Aplicación

La interfaz está estructurada en **3 pantallas principales** accesibles desde la barra de navegación superior, separando la visualización ejecutiva, la operación semanal de pagos y la configuración técnica:

| Pantalla 1: Resumen (`screen-dashboard`)                    | Pantalla 2: Cronograma (`screen-schedule`)                     | Pantalla 3: Nómina y Ajustes (`screen-payroll`)                    |
| :---------------------------------------------------------- | :------------------------------------------------------------- | :----------------------------------------------------------------- |
| **01.** Tarjeta KPI de Ingresos Netos del Mes               | **05.** Selector de Enfoque por Semana (`Todos`, `S1–S4`)      | **09.** Calculadora de Salario Bruto a Neto Mensual                |
| **02.** Tarjeta KPI de Total Gastado y Apartado             | **06.** Filtro por Categoría Principal y Subconceptos          | **10.** Selector de Frecuencia (`Semanal`, `Quincenal`, `Mensual`) |
| **03.** Tarjeta KPI de Ahorro e Inversión (`%`)             | **07.** Matriz Editable de Montos y Estatus de Pago            | **11.** Configuración de Regla de Descuento y Tema Visual          |
| **04.** Tarjetas de Liquidez por Periodo y Barras de Avance | **08.** Acciones de Agendado en Google Calendar (`.ics` / URL) | **12.** Conexión con Supabase (PostgreSQL) y Exportación CSV/JSON  |

- **Esquema SQL (`supabase_schema.sql`)**: Incluye la definición de las tablas `finctrl_backups` y `finctrl_concepts` junto con sus políticas de seguridad (Row Level Security) para sincronizar y consultar los datos desde **DBeaver** o el panel de **Supabase**.

### Flujo de operación de cada periodo

Cada mes presupuestado dentro de la aplicación sigue un ciclo de control consistente:

1. **Configuración de Base Mensual**: Definición del salario bruto o neto mensual y elección de la frecuencia de dispersión (`Semanal`, `Quincenal` o `Mensual`).
2. **Registro de Conceptos y Subconceptos**: Alta de compromisos de pago o ahorro dentro de su categoría correspondiente, eligiendo si el monto se asigna a una semana específica, se repite o se divide entre los periodos.
3. **Seguimiento de Estatus (`Pendiente` → `Apartado` → `Pagado`)**: Actualización del estado de cada subconcepto conforme transcurren las semanas del mes.
4. **Cálculo Reactivo de Saldo Disponible**: Actualización inmediata de las tarjetas de liquidez semanal y de las barras de progreso presupuestal al modificar cualquier monto o estatus.
5. **Sincronización y Cierre Mensual**: Respaldo automático en la base de datos de Supabase, generación de recordatorios en Google Calendar y exportación opcional a Excel (`CSV`) o `JSON`.

## Información Técnica y Arquitectura

- **Arquitectura Frontend (_Zero-Build SPA_)**: Aplicación de página única contenida en [index.html][app-entry], construida con HTML5 semántico, **Tailwind CSS** (configurado con detección de tema del sistema mediante `matchMedia('(prefers-color-scheme: dark)')`) y **JavaScript ES6+** puro. No requiere compiladores ni servidores intermedios para ejecutarse.
- **Persistencia Híbrida (_Offline-First + Cloud PostgreSQL_)**:
  - **Nivel Local**: Todos los cambios se serializan instantáneamente en `localStorage` bajo la clave `FINCTRL_DASHBOARD_STATE_V3`, garantizando disponibilidad sin conexión.
  - **Nivel Cloud (Supabase)**: Integración con `@supabase/supabase-js@2` que sincroniza una instantánea completa en `public.finctrl_backups` (formato `JSONB`) y desglosa cada fila por mes y periodo (`s1` a `s4`) en `public.finctrl_concepts` para facilitar consultas analíticas en SQL desde **DBeaver**.
- **Integración con Google Calendar**:
  - Generación de enlaces de plantilla directa hacia Google Calendar Web por cada concepto.
  - Generación dinámica de archivos bajo el estándar **iCalendar (RFC 5545 `.ics`)** con todos los compromisos del mes activo.
  - Conector con **Google Identity Services (OAuth 2.0)** y **Google Calendar REST API v3** para inserción directa de eventos en el calendario primario del usuario.

## Instalación y Uso

Para clonar el repositorio y utilizar el dashboard localmente o conectarlo con tu base de datos:

```bash
# Clonar el repositorio
git clone https://github.com/dial999/finanzas-dashboard.git && cd finanzas-dashboard/

# Abrir la aplicación directamente en el navegador predeterminado (Windows PowerShell)
Invoke-Item .\index.html
```

> **Nota sobre la base de datos**: La aplicación funciona de inmediato en modo local sin configuración adicional. Para habilitar el guardado en la nube y la administración desde **DBeaver**, crea un proyecto en Supabase, ejecuta el script [`supabase_schema.sql`][db-schema] en el editor SQL y registra tu `Project URL` y `Anon Public Key` en la pestaña **Nómina & Ajustes**.

## Estructura del Repositorio

```bash
< PROJECT ROOT >
   |
   |-- index.html             # Aplicación web principal (Vistas: Resumen, Cronograma, Nómina y Ajustes)
   |
   |-- supabase_schema.sql    # Definición de tablas PostgreSQL (finctrl_backups, finctrl_concepts) y políticas RLS
   |
   |-- README.md              # Documentación general, arquitectura técnica y roadmap del proyecto
```

## Futuras Propuestas y Mejoras (Roadmap)

- **Conexión y administración productiva con Supabase y DBeaver**: Configurar la instancia principal de PostgreSQL en Supabase y vincularla con DBeaver para consultas SQL históricas y reportes personalizados por trimestre o año.
- **Despliegue continuo en GitHub Pages**: Publicar el repositorio mediante GitHub Pages para contar con un enlace web permanente accesible desde dispositivos móviles y de escritorio.
- **Clonación de plantilla entre meses**: Añadir una función para copiar automáticamente la estructura de conceptos fijos del mes actual hacia el mes siguiente, reiniciando los estatus a `Pendiente`.
- **Fechas de corte específicas por subconcepto**: Permitir asignar un día exacto del mes a cada pago (por ejemplo, día 15 para seguro de auto) para programar alertas con fecha y hora precisas en Google Calendar.
- **Sincronización bidireccional de estatus en Google Calendar**: Actualizar automáticamente el título del evento en Google Calendar cuando un concepto cambie a estatus `Pagado` dentro del dashboard.
- **Autenticación de usuario con Supabase Auth**: Incorporar inicio de sesión con cuenta de Google para restringir las políticas RLS de PostgreSQL exclusivamente al identificador del propietario (`auth.uid()`).
- **Asistente financiero en lenguaje natural (Gemini API)**: Integrar un módulo conversacional que permita registrar gastos o cambiar estatus mediante instrucciones de texto simples.

## Créditos y Autoría

- **Autora y Diseño del Sistema**: **Diana Lorena Muñoz Ramos** (2026).

---

[live-demo]: https://dial999.github.io/finanzas-dashboard/
[app-entry]: index.html
[db-schema]: supabase_schema.sql
