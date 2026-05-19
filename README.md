# InnovaTech

> *Sujeto a modifiaciones.*

## Programas, frameworks y dependencias

**Formación general del proyecto: *Backend y Frontend*** 

| Tipo | Nombre | Versión | Uso |
|------|--------|---------|-----|
| Framework | SpringBoot | 3.4.4 | Construcción del Backend en general. |
| Herramienta | Java Maven | x | Construcción del Backend en general. |
| Librería | React | 18.2.0 | Construcción del Frontend. |
| Herramienta | Node.js | 20 | Entorno de ejecución para el servicio web. |

**Dependencias del *backend***

| Nombre | Versión | Uso |
|--------|---------|-----|
| Spring Web | x | Regulador para peticiones HTTP. |
| Validation | x | Construcción de reglas de la entidad. |
| JPA | 3.4.3 | Persistencia de datos. |
| OpenApi | 2.7.0 | Documentación de API Rest. |
| Lombok | x | Biblioteca para evitar código repetitivo. |
| MySql Driver | x | Conector para la entrada de MySql como database. |
| Actuator | x | Monitoreo del Estado de salud de los back-ends. |

**Modo de trabajo del *infraestructure***

| Modulo | Archivo | Uso |
|--------|---------|-----|
| Compute | compute.tf | Conlleva la información de templates y la formación de instancias. |
| network | network.tf | Posee la información de redes en donde se situan las máquinas y su comunicación con el mundo. |
| security | security.tf | Creación de los Secutiry Groups (limitación de la comunicación de entrada y salida). |
| variables | variables.tf | Forma para limpiar y corregir código de manera más focalizada. |
| Outputs | outputs.tf | Salida de información. |
| Main |Main.tf | Cuerpo de configuraciones principales. |

