// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Audio {
    internal enum Recorder {
      /// PAUSA
      internal static let pause = L10n.tr("Localizable", "audio.recorder.pause", fallback: "PAUSA")
      /// REPRODUCIR
      internal static let play = L10n.tr("Localizable", "audio.recorder.play", fallback: "REPRODUCIR")
      /// GRABANDO... 
      ///  TOQUE PARA DETENER
      internal static let recording = L10n.tr("Localizable", "audio.recorder.recording", fallback: "GRABANDO... \n TOQUE PARA DETENER")
      internal enum Touch {
        internal enum Start {
          /// TOQUE PARA COMENZAR A GRABAR
          internal static let record = L10n.tr("Localizable", "audio.recorder.touch.start.record", fallback: "TOQUE PARA COMENZAR A GRABAR")
        }
      }
    }
  }
  internal enum General {
    /// Localizable.strings
    ///   MovilidadUK
    /// 
    ///   Created by Diego Quimbo on 4/1/22.
    internal static let accept = L10n.tr("Localizable", "general.accept", fallback: "Aceptar")
    /// Cancelar
    internal static let cancel = L10n.tr("Localizable", "general.cancel", fallback: "Cancelar")
    /// Borrar
    internal static let delete = L10n.tr("Localizable", "general.delete", fallback: "Borrar")
    internal enum Error {
      /// Error al cargar la Aplicación
      internal static let app = L10n.tr("Localizable", "general.error.app", fallback: "Error al cargar la Aplicación")
      /// Error de conexión
      internal static let connection = L10n.tr("Localizable", "general.error.connection", fallback: "Error de conexión")
      /// Error
      internal static let title = L10n.tr("Localizable", "general.error.title", fallback: "Error")
    }
    internal enum Execute {
      /// Ejecutando Aplicación...
      internal static let app = L10n.tr("Localizable", "general.execute.app", fallback: "Ejecutando Aplicación...")
    }
    internal enum Loading {
      /// Cargando Aplicación...
      internal static let app = L10n.tr("Localizable", "general.loading.app", fallback: "Cargando Aplicación...")
    }
  }
  internal enum Home {
    /// Home
    internal static let title = L10n.tr("Localizable", "home.title", fallback: "Home")
    internal enum App {
      /// Movilidad for iOS. Version: %@ Build: %@ Date: %@
      internal static func info(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
        return L10n.tr("Localizable", "home.app.info", String(describing: p1), String(describing: p2), String(describing: p3), fallback: "Movilidad for iOS. Version: %@ Build: %@ Date: %@")
      }
    }
    internal enum Error {
      /// No se encontró el servidor de licencias
      internal static let licence = L10n.tr("Localizable", "home.error.licence", fallback: "No se encontró el servidor de licencias")
      /// Error en el servicio DesktopData
      internal static let menu = L10n.tr("Localizable", "home.error.menu", fallback: "Error en el servicio DesktopData")
      /// Error en el servicio de Notificaciones
      internal static let notifications = L10n.tr("Localizable", "home.error.notifications", fallback: "Error en el servicio de Notificaciones")
      /// Error en el servicio Profiles
      internal static let profile = L10n.tr("Localizable", "home.error.profile", fallback: "Error en el servicio Profiles")
    }
    internal enum Loading {
      /// Cargando Información adicional
      internal static let info = L10n.tr("Localizable", "home.loading.info", fallback: "Cargando Información adicional")
      /// Cargando Menu
      internal static let menu = L10n.tr("Localizable", "home.loading.menu", fallback: "Cargando Menu")
      /// Cargando Perfiles
      internal static let profile = L10n.tr("Localizable", "home.loading.profile", fallback: "Cargando Perfiles")
    }
    internal enum Menu {
      /// Favoritos
      internal static let favorites = L10n.tr("Localizable", "home.menu.favorites", fallback: "Favoritos")
      /// General
      internal static let general = L10n.tr("Localizable", "home.menu.general", fallback: "General")
    }
    internal enum Search {
      /// Búsqueda General
      internal static let general = L10n.tr("Localizable", "home.search.general", fallback: "Búsqueda General")
    }
  }
  internal enum Login {
    internal enum Button {
      /// Ingresar
      internal static let text = L10n.tr("Localizable", "login.button.text", fallback: "Ingresar")
    }
    internal enum Error {
      internal enum No {
        /// Usuario sin perfil
        internal static let access = L10n.tr("Localizable", "login.error.no.access", fallback: "Usuario sin perfil")
      }
      internal enum Unknow {
        /// Usuario o contraseña incorrecto
        internal static let credentials = L10n.tr("Localizable", "login.error.unknow.credentials", fallback: "Usuario o contraseña incorrecto")
      }
    }
    internal enum Label {
      /// Contraseña
      internal static let password = L10n.tr("Localizable", "login.label.password", fallback: "Contraseña")
      /// Usuario
      internal static let username = L10n.tr("Localizable", "login.label.username", fallback: "Usuario")
    }
    internal enum TextField {
      internal enum Password {
        /// Contraseña
        internal static let placeholder = L10n.tr("Localizable", "login.textField.password.placeholder", fallback: "Contraseña")
      }
      internal enum Username {
        /// Usuario
        internal static let placeholder = L10n.tr("Localizable", "login.textField.username.placeholder", fallback: "Usuario")
      }
    }
    internal enum Watch {
      /// Ver Detalle Técnico
      internal static let detail = L10n.tr("Localizable", "login.watch.detail", fallback: "Ver Detalle Técnico")
    }
  }
  internal enum LoginError {
    /// Compartir
    internal static let share = L10n.tr("Localizable", "loginError.share", fallback: "Compartir")
  }
  internal enum LoginSetting {
    /// Build:
    internal static let build = L10n.tr("Localizable", "loginSetting.build", fallback: "Build:")
    /// Cerrar
    internal static let close = L10n.tr("Localizable", "loginSetting.close", fallback: "Cerrar")
    /// Language:
    internal static let language = L10n.tr("Localizable", "loginSetting.language", fallback: "Language:")
    /// Server:
    internal static let server = L10n.tr("Localizable", "loginSetting.server", fallback: "Server:")
    internal enum Add {
      internal enum New {
        /// Agregar Nuevo Server
        internal static let server = L10n.tr("Localizable", "loginSetting.add.new.server", fallback: "Agregar Nuevo Server")
      }
      internal enum Server {
        /// Ingrese la dirección del servidor
        internal static let description = L10n.tr("Localizable", "loginSetting.add.server.description", fallback: "Ingrese la dirección del servidor")
        /// Servidor
        internal static let title = L10n.tr("Localizable", "loginSetting.add.server.title", fallback: "Servidor")
      }
    }
    internal enum Client {
      /// Client Version:
      internal static let version = L10n.tr("Localizable", "loginSetting.client.version", fallback: "Client Version:")
    }
    internal enum Header {
      /// Movilidad for iOS
      internal static let title = L10n.tr("Localizable", "loginSetting.header.title", fallback: "Movilidad for iOS")
    }
    internal enum Networking {
      /// Herramientas de red
      internal static let tools = L10n.tr("Localizable", "loginSetting.networking.tools", fallback: "Herramientas de red")
    }
    internal enum Remove {
      internal enum Server {
        /// ¿Estás seguro de que quieres eliminar el ambiente
        internal static let description = L10n.tr("Localizable", "loginSetting.remove.server.description", fallback: "¿Estás seguro de que quieres eliminar el ambiente")
        /// Aviso
        internal static let title = L10n.tr("Localizable", "loginSetting.remove.server.title", fallback: "Aviso")
      }
    }
  }
  internal enum Metro {
    internal enum Desktop {
      internal enum Empty {
        /// No existen Tiles disponibles
        internal static let tiles = L10n.tr("Localizable", "metro.desktop.empty.tiles", fallback: "No existen Tiles disponibles")
      }
      internal enum Loading {
        /// Cargando Tiles
        internal static let tiles = L10n.tr("Localizable", "metro.desktop.loading.tiles", fallback: "Cargando Tiles")
      }
      internal enum Search {
        /// Workspaces
        internal static let workspaces = L10n.tr("Localizable", "metro.desktop.search.workspaces", fallback: "Workspaces")
      }
    }
    internal enum Start {
      /// Ir al Desktop
      internal static let desktop = L10n.tr("Localizable", "metro.start.desktop", fallback: "Ir al Desktop")
      /// Buscar
      internal static let search = L10n.tr("Localizable", "metro.start.search", fallback: "Buscar")
    }
  }
  internal enum Navigator {
    /// No se puede cargar la URL: %@
    internal static func generalError(_ p1: Any) -> String {
      return L10n.tr("Localizable", "navigator.general_error", String(describing: p1), fallback: "No se puede cargar la URL: %@")
    }
    /// No se puede cargar el sitio web debido al acceso restringido por VPN
    internal static let generalError2 = L10n.tr("Localizable", "navigator.general_error2", fallback: "No se puede cargar el sitio web debido al acceso restringido por VPN")
    /// Ir
    internal static let go = L10n.tr("Localizable", "navigator.go", fallback: "Ir")
    /// La URL no es válida
    internal static let noValidUrl = L10n.tr("Localizable", "navigator.no_valid_url", fallback: "La URL no es válida")
    /// La URL no se puede cargar status code %@
    internal static func urlStatusCode(_ p1: Any) -> String {
      return L10n.tr("Localizable", "navigator.url_status_code", String(describing: p1), fallback: "La URL no se puede cargar status code %@")
    }
  }
  internal enum Network {
    internal enum Tool {
      /// My IP
      internal static let ip = L10n.tr("Localizable", "network.tool.ip", fallback: "My IP")
      /// Output
      internal static let output = L10n.tr("Localizable", "network.tool.output", fallback: "Output")
      /// Ping
      internal static let ping = L10n.tr("Localizable", "network.tool.ping", fallback: "Ping")
      /// Servidor
      internal static let server = L10n.tr("Localizable", "network.tool.server", fallback: "Servidor")
      /// Herramientas de Red
      internal static let title = L10n.tr("Localizable", "network.tool.title", fallback: "Herramientas de Red")
      internal enum Packet {
        /// Packet received: %@
        /// Latency: %@ ms
        internal static func received(_ p1: Any, _ p2: Any) -> String {
          return L10n.tr("Localizable", "network.tool.packet.received", String(describing: p1), String(describing: p2), fallback: "Packet received: %@\nLatency: %@ ms")
        }
        /// Packet sent: %@
        internal static func sent(_ p1: Any) -> String {
          return L10n.tr("Localizable", "network.tool.packet.sent", String(describing: p1), fallback: "Packet sent: %@")
        }
        internal enum Sent {
          /// An error occurred when trying to send Packet: %@
          internal static func error(_ p1: Any) -> String {
            return L10n.tr("Localizable", "network.tool.packet.sent.error", String(describing: p1), fallback: "An error occurred when trying to send Packet: %@")
          }
        }
      }
      internal enum Start {
        /// Starting Ping to: %@
        internal static func ping(_ p1: Any) -> String {
          return L10n.tr("Localizable", "network.tool.start.ping", String(describing: p1), fallback: "Starting Ping to: %@")
        }
        internal enum Ping {
          /// An error occurred when trying to Ping: %@
          internal static func error(_ p1: Any) -> String {
            return L10n.tr("Localizable", "network.tool.start.ping.error", String(describing: p1), fallback: "An error occurred when trying to Ping: %@")
          }
        }
      }
    }
  }
  internal enum Register {
    internal enum Notification {
      internal enum Apns {
        /// El dispositivo no esta registrado a APN
        internal static let error = L10n.tr("Localizable", "register.notification.apns.error", fallback: "El dispositivo no esta registrado a APN")
      }
    }
  }
  internal enum Service {
    internal enum Menu {
      /// The service .../Desktop/W32LoadDesktop.axd?Id=0&Command=DesktopData&Initial_Load=False&Culture=es-AR&ClientType does not return a valid object
      internal static let error = L10n.tr("Localizable", "service.menu.error", fallback: "The service .../Desktop/W32LoadDesktop.axd?Id=0&Command=DesktopData&Initial_Load=False&Culture=es-AR&ClientType does not return a valid object")
    }
    internal enum ProfileExtraInfo {
      /// The service .../Desktop/UserSettings.axd?getuserinfo is returning a nil object
      internal static let error = L10n.tr("Localizable", "service.profileExtraInfo.error", fallback: "The service .../Desktop/UserSettings.axd?getuserinfo is returning a nil object")
    }
  }
  internal enum Settings {
    /// Build
    internal static let build = L10n.tr("Localizable", "settings.build", fallback: "Build")
    /// Configuración de Inicio
    internal static let initialConfig = L10n.tr("Localizable", "settings.initialConfig", fallback: "Configuración de Inicio")
    /// Iniciar en Desktop
    internal static let initialDesktop = L10n.tr("Localizable", "settings.initialDesktop", fallback: "Iniciar en Desktop")
    /// Operación de inicio
    internal static let initialOperation = L10n.tr("Localizable", "settings.initialOperation", fallback: "Operación de inicio")
    /// Perfil de inicio
    internal static let initialProfile = L10n.tr("Localizable", "settings.initialProfile", fallback: "Perfil de inicio")
    /// Sigla
    internal static let initials = L10n.tr("Localizable", "settings.initials", fallback: "Sigla")
    /// Lenguaje
    internal static let language = L10n.tr("Localizable", "settings.language", fallback: "Lenguaje")
    /// Metro Desktop
    internal static let metroDesktop = L10n.tr("Localizable", "settings.metroDesktop", fallback: "Metro Desktop")
    /// Movilidad
    internal static let movilidad = L10n.tr("Localizable", "settings.movilidad", fallback: "Movilidad")
    /// Navegador
    internal static let navigator = L10n.tr("Localizable", "settings.navigator", fallback: "Navegador")
    /// Ninguno
    internal static let `none` = L10n.tr("Localizable", "settings.none", fallback: "Ninguno")
    /// Perfil
    internal static let profile = L10n.tr("Localizable", "settings.profile", fallback: "Perfil")
    /// Servidor
    internal static let server = L10n.tr("Localizable", "settings.server", fallback: "Servidor")
    /// Cerrar Sesión
    internal static let signout = L10n.tr("Localizable", "settings.signout", fallback: "Cerrar Sesión")
    /// Usuario
    internal static let user = L10n.tr("Localizable", "settings.user", fallback: "Usuario")
    internal enum Client {
      /// Versión del cliente
      internal static let version = L10n.tr("Localizable", "settings.client.version", fallback: "Versión del cliente")
    }
    internal enum Redirect {
      /// Redirect de transacciones
      internal static let transactions = L10n.tr("Localizable", "settings.redirect.transactions", fallback: "Redirect de transacciones")
    }
    internal enum Signout {
      /// ¿Está seguro de que desea cerrar 
      ///  la sesión?
      internal static let description = L10n.tr("Localizable", "settings.signout.description", fallback: "¿Está seguro de que desea cerrar \n la sesión?")
    }
  }
  internal enum Video {
    internal enum Download {
      /// Error de conexión al intentar descargar el archivo
      internal static let error = L10n.tr("Localizable", "video.download.error", fallback: "Error de conexión al intentar descargar el archivo")
    }
    internal enum Load {
      /// Error de conexión al intentar cargar el archivo
      internal static let error = L10n.tr("Localizable", "video.load.error", fallback: "Error de conexión al intentar cargar el archivo")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
