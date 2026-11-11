# CaféCalc — guía de uso y publicación

## Qué incluye

- Aplicación Flutter con una tabla de dos columnas, inspirada en la hoja de Excel.
- Campos editables: precio de la carga, latas por carga, costo beneficiado y libras por galón.
- Cálculos automáticos: precio promedio por lata, precio por lata a pagar y precio por libra a pagar.
- Diseño oscuro y adaptable a celulares y computadoras.

## Ejecutarla

Abre una terminal en esta carpeta y ejecuta (si `flutter` ya está en PATH):

```powershell
flutter pub get
flutter run -d chrome
```

En el equipo usado durante la práctica, si PowerShell no reconoce `flutter`, usa la ruta instalada:

```powershell
& "C:\Users\keren\Downloads\appweb\flutter\bin\flutter.bat" pub get
& "C:\Users\keren\Downloads\appweb\flutter\bin\flutter.bat" run -d chrome
```

## Crear la versión web para publicar

```powershell
flutter build web --release
```

O con la ruta anterior:

```powershell
& "C:\Users\keren\Downloads\appweb\flutter\bin\flutter.bat" build web --release
```

Flutter genera los archivos listos para alojar en `build/web`. Sube **el contenido** de esa carpeta a un servicio de alojamiento web estático. No subas solo `main.dart`.

## Publicarla con un enlace usando GitHub Pages

Este proyecto incluye el flujo automático `.github/workflows/deploy.yml`. Al subir el proyecto a GitHub, GitHub Actions compila Flutter Web con la ruta correcta para el nombre del repositorio y lo publica en Pages.

1. En GitHub, crea un repositorio público llamado `cafe-calc`.
2. En VS Code, abre una terminal en la carpeta de este proyecto y ejecuta:

   ```powershell
   git init
   git add .
   git commit -m "Primera versión de CaféCalc"
   git branch -M main
   git remote add origin https://github.com/TU-USUARIO/cafe-calc.git
   git push -u origin main
   ```

   Reemplaza `TU-USUARIO` con tu nombre de usuario de GitHub. Si la carpeta ya tiene Git configurado, no vuelvas a ejecutar `git init`; usa `git add`, `git commit` y `git push`.
3. En GitHub, abre el repositorio y ve a **Settings → Pages**. En **Build and deployment**, selecciona **GitHub Actions** como origen.
4. Abre la pestaña **Actions** y espera a que termine `Publish CaféCalc to GitHub Pages` en verde.
5. El enlace tendrá este formato: `https://TU-USUARIO.github.io/cafe-calc/`. GitHub también muestra el enlace publicado en **Settings → Pages**.

Cada vez que subas cambios a la rama `main`, GitHub Actions vuelve a compilar y publicar el sitio. GitHub Pages publica el sitio web estático; no utiliza Litebase para alojarlo.

## Litebase

Litebase es una plataforma de base de datos, no un servicio de alojamiento de sitios web. Esta calculadora no necesita base de datos porque calcula todo en el navegador y no guarda historial. Para obtener un enlace público, publica `build/web` en un hosting web estático o pide a informática de tu oficina que lo coloque en el servidor interno.

Si por “Litebase” te refieres a otro producto, confirma su dirección web o comparte una captura de la pantalla de publicación para preparar los pasos correctos.

## Fórmulas

- Precio promedio por lata = precio de la carga ÷ latas por carga.
- Precio por lata a pagar = precio promedio por lata − costo beneficiado.
- Precio por libra a pagar = precio por lata a pagar ÷ libras por galón.

Los valores iniciales de ejemplo son 16,000, 33, 15 y 30, como en la captura más reciente. Puedes editarlos directamente en la tabla.
