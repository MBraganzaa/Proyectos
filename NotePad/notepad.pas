unit notepad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
    MAX_LINEAS_HOJA= 10000; //Diez mil líneas como máximo.
    TEMP_FILE_DEFAULT_NAME= 'NotePad//MBraganzaa';

type
    TListaLineas= ^NodoLinea;
    NodoLinea= record
        linea: string;
        siguiente: TListaLineas;
    end;

    THoja= record
        lineasTexto: TListaLineas;
        dimension: integer;
    end;

    TNotepad= record
        archivoAbierto: boolean; //Indica si estamos trabajando con un archivo existente.
        cambiosPendientes: boolean; //Si hay cambios por guardar
        hoja: THoja; //La hoja de trabajo.
        archivo: TextFile; //El archivo actualmente abierto.
        rutaArchivo: String; //La ruta del archivo abierto.
    end;

    {Inicia todo lo necesario para funcionar, estableciendo lo siguiente:

    * No hay un archivo abierto, la aplicación recién se inició.
    * No hay cambios pendientes.
    * La hoja está vacía, no tiene ninguna línea de texto.}
    procedure inicializar(var aplicacion: TNotepad);

    {Deja la hoja de trabajo vacía, es decir, sin líneas.}
    procedure borrarHoja(var aplicacion: TNotepad);

    {Agrega una línea de texto a la hoja. Si la hoja alcanzó el límite de líneas
    entonces no hace nada.}
    procedure agregarLinea(linea: String; var aplicacion: TNotepad);

    {Retorna la cantidad de líneas que hay en la hoja actualmente.}
    function cantidadLineas(var aplicacion: TNotepad): integer;

    {Asigna al argumento linea la línea de texto en el índice indicado en la hoja.
    Si el índice es inválido (por estar fuera del rango) se retorna FALSE y el
    argumento linea se establece como vacío (''); si el índice es válido se retorna
    TRUE y el argumento línea estará asignado correctamente.}
    function obtenerLinea(indice: integer; var linea: String; var aplicacion: TNotepad): boolean;

    {Establece si hay cambios pendientes por guardar según pendientes sea TRUE
    o FALSE.}
    procedure cambiosPendientes(pendientes: boolean; var aplicacion: TNotepad);

    {Devuelve TRUE si hay cambios pendientes por ser guardados, FALSE si no.}
    function cambiosPendientes(var aplicacion: TNotepad): boolean;

    {Retorna TRUE si se está trabajando con un archivo abierto, FALSE si no.}
    function archivoAbierto(var aplicacion: TNotepad): boolean;

    {Esta función crea un nuevo archivo de texto en la ruta especificada (la ruta
    contiene el nombre del archivo y su extensión). Si el archivo ya existe se
    sobrescribe, sino, se crea uno nuevo. Si hay un archivo abierto en el momento
    de realizar esta operacion, dicho archivo se cierra sin efectuar cambios en él,
    salvo que el ruta indique que se trata de éste mismo archivo, sobrescribiéndolo.
    Se establece que no hay cambios pendientes por guardar.
    Queda abierto el archivo creado.
    Se retorna TRUE si todo funciona bien, FALSE en caso contrario.}
    function guardarComo(ruta: String; var aplicacion: TNotepad): boolean;

    {Guarda los cambios en el archivo actualmente abierto, este debe quedar con
    los cambios actualizados, y se debe marcar que ya no hay cambios pendientes.
    Si no hay cambios pendientes no se hace nada.}
    function guardar(var aplicacion: TNotepad): boolean;

    {Carga la información de un nuevo archivo en la hoja.
    Se establece que hay un archivo abierto.
    No hay cambios pendientes.
    Si ya habia un archivo abierto este se cierra.}
    function cargarArchivo(ruta: String; var aplicacion: TNotepad): boolean;

    {Si hay un archivo abierto, lo cierra sin guardar cambios.
    Deja la hoja vacía, sin cambios pendientes y sin archivo abierto.}
    procedure reiniciar(var aplicacion: TNotepad);

    {Si hay un archivo abierto lo cierra.}
    procedure finalizar(var aplicacion: TNotepad);

implementation

procedure inicializar(var aplicacion: TNotepad);
begin
     with aplicacion do begin
         archivoAbierto:= false ;
         cambiosPendientes:= false ;
         hoja.dimension:= 0 ;
     end;
end;

procedure borrarHoja(var aplicacion: TNotepad);
begin

end;

procedure agregarLinea(linea: String; var aplicacion: TNotepad);
begin

end;

function cantidadLineas(var aplicacion: TNotepad): integer;
begin

end;

function obtenerLinea(indice: integer; var linea: String;
  var aplicacion: TNotepad): boolean;
begin

end;

procedure cambiosPendientes(pendientes: boolean; var aplicacion: TNotepad);
begin

end;

function cambiosPendientes(var aplicacion: TNotepad): boolean;
begin

end;

function archivoAbierto(var aplicacion: TNotepad): boolean;
begin

end;

function guardarComo(ruta: String; var aplicacion: TNotepad): boolean;
begin

end;

function guardar(var aplicacion: TNotepad): boolean;
begin

end;

function cargarArchivo(ruta: String; var aplicacion: TNotepad): boolean;
begin

end;

procedure reiniciar(var aplicacion: TNotepad);
begin

end;

procedure finalizar(var aplicacion: TNotepad);
begin

end;

end.

