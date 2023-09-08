unit notepad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
    MAX_LINEAS_HOJA= 10000; //Diez mil líneas como máximo.
    TEMP_FILE_DEFAULT_NAME= 'temp_notepadpas.tmpka';

type
    TListaLineas = array [1..MAX_LINEAS_HOJA] of string;

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
     aplicacion.hoja.dimension:= 0;
end;

procedure agregarLinea(linea: String; var aplicacion: TNotepad);
begin
     if aplicacion.hoja.dimension<MAX_LINEAS_HOJA then begin
     aplicacion.hoja.dimension += 1;
     aplicacion.hoja.lineasTexto[aplicacion.hoja.dimension]:= linea;

     end;
end;

function cantidadLineas(var aplicacion: TNotepad): integer;
begin
     result:= aplicacion.hoja.dimension;
end;

function obtenerLinea(indice: integer; var linea: String;
  var aplicacion: TNotepad): boolean;
begin
    if (indice<0) and (indice>=aplicacion.hoja.dimension) then begin
      linea:= aplicacion.hoja.lineasTexto[indice];
      result:= true;
    end else begin
        linea:= '';
        result:= false;
    end;
end;

procedure cambiosPendientes(pendientes: boolean; var aplicacion: TNotepad);
begin
     aplicacion.cambiosPendientes:= pendientes;
end;

function cambiosPendientes(var aplicacion: TNotepad): boolean;
begin
     result:= aplicacion.cambiosPendientes;
end;

function archivoAbierto(var aplicacion: TNotepad): boolean;
begin
     result:= aplicacion.archivoAbierto;
end;

function guardarComo(ruta: String; var aplicacion: TNotepad): boolean;
var i: integer;
begin
     if aplicacion.archivoAbierto then begin
       closeFile(aplicacion.archivo);
       aplicacion.archivoAbierto:=false;
     end;

     AssignFile(aplicacion.archivo,ruta);
     Rewrite(aplicacion.archivo);
     aplicacion.rutaArchivo:= ruta;

     for i:=1 to aplicacion.hoja.dimension do begin
         writeln(aplicacion.archivo,aplicacion.hoja.lineasTexto[i]);
     end;

     CloseFile(aplicacion.archivo);
     AssignFile(aplicacion.archivo,ruta);
     Reset(aplicacion.archivo);
     aplicacion.archivoAbierto:=true;
     aplicacion.cambiosPendientes:=false;
end;

function guardar(var aplicacion: TNotepad): boolean;
var tempFile: TextFile;
    i : integer;
    rutaTempFile: string;
begin
     if aplicacion.archivoAbierto and aplicacion.cambiosPendientes then begin
       //ExtractFilePath contiene todo la ruta del archivo menos el nombre. es decir solo los directorios.
       rutaTempFile:=ExtractFilePath(aplicacion.rutaArchivo)+TEMP_FILE_DEFAULT_NAME;
       AssignFile(tempFile,rutaTempFile);
       reWrite(tempFile);

       for i := 1 to aplicacion.hoja.dimension do begin
         writeln(tempFile,aplicacion.hoja.lineasTexto[i]);
       end;

       closeFile(tempFile);
       closeFile(aplicacion.archivo);

       if DeleteFile(aplicacion.rutaArchivo) then begin
          // RenameFile cambia el nombre de un archivo.
          RenameFile(rutaTempFile,aplicacion.rutaArchivo);
       end else begin
          DeleteFile(rutaTempFile);
       end;
       AssignFile(aplicacion.archivo,aplicacion.rutaArchivo);
       reset(aplicacion.archivo);
       aplicacion.cambiosPendientes:= false;
       aplicacion.archivoAbierto:= true;
     end;
end;

function cargarArchivo(ruta: String; var aplicacion: TNotepad): boolean;
var lineaLeida: string;
begin
     with aplicacion do begin
         if archivoAbierto then begin
            closeFile(archivo);
         end;
     AssignFile(archivo,ruta);
     reset(archivo);

     archivoAbierto:= true;
     cambiosPendientes:= false;
     rutaArchivo:= ruta;
     hoja.dimension:= 0;

    while not eof(archivo) do begin
        readln(archivo,lineaLeida);
        agregarLinea(lineaLeida,aplicacion);
    end;
    result:=true;
    end;
end;

procedure reiniciar(var aplicacion: TNotepad);
begin
     with aplicacion do begin
         if archivoAbierto then begin
            closeFile(archivo);
            archivoAbierto:= false;
            rutaArchivo:= '';
         end;
         cambiosPendientes:= false;
     end;
     borrarHoja(aplicacion);
end;

procedure finalizar(var aplicacion: TNotepad);
begin
     with aplicacion do begin
         if archivoAbierto then begin
            closeFile(archivo);
            archivoAbierto:= false;
         end;
     end;
end;

end.

