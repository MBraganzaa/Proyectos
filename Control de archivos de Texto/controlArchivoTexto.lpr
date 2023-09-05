program controlArchivoTexto;

uses SysUtils, crt;
const COMANDO_FIN = '$FIN';
var  archivo : TextFile;
     opcionActual : char;
     nombreArchivo, nombreTemporal, lineaTexto : string;
     finDeEscritura : boolean;

{En caso de que exista el archivo se abre y se muestra el contenido.}
procedure mostrarTextoDeArchivo(nombre : string);
var f : TextFile; linea: string;
begin
     if FileExists(nombre) then begin
       AssignFile(f,nombre);
       Reset(f);
       while not eof(f) do begin
             readln(F,linea);
             writeln(linea);
       end;
       CloseFile(f);
     end;
end;
function copiarArchivo(nombreOriginal, nombreCopia: string): boolean;
var f1,f2 : textFile;
    lineaLeida : string;
begin
      if not FileExists(nombreOriginal) then begin
        result:= false;
        exit;
      end else if fileExists(nombreCopia) then begin
              result:= false;
              exit;
      end;

      AssignFile(f1,nombreOriginal);
      AssignFile(f2,nombreCopia);

      reset(f1);
      rewrite(f2);

      while not eof(f1) do begin
           readln(f1,lineaLeida);
           writeln(f2,lineaLeida);
      end;
      closeFile(f1);
      closeFile(f2);
      result:= true;
end;

begin
  repeat
    clrscr;
    writeln('Elige una opcion:'); writeln;
    writeln('1) Crear o abrir un archivo existente');
    writeln('2) Mostrar informacion de un archivo existente');
    writeln('3) Copiar un archivo');
    writeln('4) Cambiar nombre');
    writeln('5) Eliminar');
    writeln('6) Mostrar lista de archivos');
    writeln('0) Salir');
    writeln;
    write('>> ');
    readln(opcionActual);

    case opcionActual of
       '1': begin
                 write('Ingrese el nombre del archivo: ');
                 readln(nombreArchivo);
                 AssignFile(archivo,nombreArchivo);
                 if FileExists(nombreArchivo) then begin
                   mostrarTextoDeArchivo(nombreArchivo);
                   writeln;
                   //Append abre el archivo para escritura.
                   append(archivo);
                 end else begin
                   //Rewrite crea el archivo y lo deja abierto para escritura.
                   Rewrite(archivo);
                 end;

                 repeat
                   //1) Primero lee el texto.
                   readln(lineaTexto);
                   //compareSrt si son iguales retorna : 0;
                   finDeEscritura:= CompareStr(COMANDO_FIN,lineaTexto) = 0;

                   if not finDeEscritura then begin
                   //2) Y despues lo escribe.
                     writeln(archivo,lineaTexto);
                   end;
                 until finDeEscritura;
                 //cierro el archivo.
                 CloseFile(archivo);
       end;
       '2': begin
            write('Ingrese el nombre del archivo: ');
            readln(nombreArchivo);
            mostrarTextoDeArchivo(nombreArchivo);
            readln;
       end;
       '3': begin
            write('Ingresa el nombre del archivo a copiar: ');
            readln(nombreArchivo);
            write('Ingresa el nombre del archivo a crear: ');
            readln(nombreTemporal);

            if copiarArchivo(nombreArchivo,nombreTemporal) then begin
              writeln('El archivo se copio.');
              readln;
            end else begin
                 writeln('El archivo no se pudo copiar.');
                 readln;
            end;

       end;
       '4': begin
            write('Ingresa el nombre del archivo a renombrar: ');
            readln(nombreArchivo);
            write('Ingresa el nuevo nombre: ');
            readln(nombreTemporal);

            if RenameFile(nombreArchivo,nombreTemporal) then begin
              writeln('El archivo se cambio de nombre.');
              readln;
            end else begin
                 writeln('El archivo no se pudo renombrar.');
                 readln;
            end;
       end;

       '5': writeln('ok');
       '6': writeln('ok');
    end;

  until opcionActual = '0' ;
end.

