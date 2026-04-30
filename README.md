# Addresses Catalog

Aplicación iOS para gestionar un catálogo de direcciones. Permite visualizar, editar la ciudad y el estado/provincia de cada dirección, y guarda los cambios localmente.

Desarrollada 100% programáticamente con **UIKit** (sin Storyboards).

## Características

- Carga de datos desde un archivo **CSV** (`Address.csv`)
- Visualización de direcciones en una tabla
- Edición de **Ciudad** y **Estado/Provincia** (texto libre)
- Registro automático de la **fecha de última modificación**
- Persistencia local de los cambios (usando JSON)
- Soporte para más de 1000 registros
- Diseño limpio y responsive

## Tecnologías utilizadas

- **Swift 5**
- **UIKit** (programático, sin Storyboards)
- **Codable** para serialización
- **FileManager** + JSON para persistencia local
- **UITableView** + **UINavigationController**

## Cómo ejecutar el proyecto

1. Clona o descarga el repositorio
2. Abre el proyecto con **Xcode** (`AddressesCatalog.xcodeproj`)
3. Asegúrate de que el archivo `Address.csv` tenga el **Target Membership** activado
4. Compila y ejecuta en simulador o dispositivo (`⌘ + R`)

## Funcionalidades principales

### Pantalla principal
- Muestra todas las direcciones cargadas
- Cada celda muestra: dirección, ciudad, estado y fecha de modificación

### Edición de dirección
- Toca cualquier dirección para editarla
- Puedes modificar libremente:
  - **Ciudad**
  - **Estado / Provincia**
- Al seleccionar una dirección se te abrirá una nueva pantalla en la que tu podrás elegir qué deseas modificar.
  - **No olvides que el teclado en el simulador se muestra con: CMD + K (`⌘ + K`)
- Al guardar se actualiza automáticamente la fecha de modificación

### Persistencia
- Los cambios se guardan automáticamente en formato JSON
- Al volver a abrir la app, se cargan los últimos cambios realizados
