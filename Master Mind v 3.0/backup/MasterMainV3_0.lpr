program MasterMainV3_0;
uses sysUtils;
const
 MAX_INTENTOS = 10; //Cantidad máxima de intentos.
 LARGO_CODIGO = 4; //El largo de los códigos.
 PRIMERA_LETRA = 'A'; //Letra inicial del rango disponible.
 ULTIMA_LETRA = 'H'; //Última letra del rango disponible.

type
 //Subrango para restringir las letras que se pueden usar.
 TLetras= PRIMERA_LETRA..ULTIMA_LETRA;
 //Arreglo de letras con cantidad de celdas LARGO_CODIGO.
 TCodigo= array[1..LARGO_CODIGO] of TLetras;

 //Contiene un código y las notas que éste recibió.
 TRegistroNota = record
 codigo : TCodigo;
 buenos, regulares: byte;
 end;

 {Un arreglo de TRegistroNota para guardar los códigos y sus
 notas, implementado como arreglo con tope. El valor del
 atributo tope igual a 0 indica que la lista está vacía.}
 THistoria = record
 info : array [1..MAX_INTENTOS] of TRegistroNota;
  tope : array [0..MAX_INTENTOS] of  byte;
 end;

 var
   codigo : TCodigo;
   histori : THistoria;
   errorMensaje : string;
   i,b, r : byte;

 ///////////////
 function esAdecuado(c: TCodigo; h: THistoria): boolean;  forward ;

{Genera un código al azar y lo asigna a la variable codigo. El codigo generado
puede contener letras repetidas.}
procedure generarCodigo(var codigo: TCodigo);
var i: byte;
begin
  randomize;
  for i:=1 to 4 do begin
    codigo[i]:= chr(random(ord(ULTIMA_LETRA)-ord(PRIMERA_LETRA)+1)+ ord(PRIMERA_LETRA));
  end;
end;

{Lee dos notas a la vez: B y R y retorna TRUE si son correctas o FALSE si no lo
son. En caso de que las notas no sean correctas B y R quedan con el valor 0.
El fin de linea es consumido. Para verificar que las notas sean correctas se
contempla lo siguiente:
 1: Son valores enteros
 2: Están entre 0 y LARGO_CODIGO
 3: La suma de B+R no puede ser mayor que LARGO_CODIGO
 4: Si B=(LARGO_CODIGO-1) y a la vez R>=1 las notas están mal.
Asigna a la variable errorMessage uno de estos dos mensajes según el caso:
 1 y 2: 'ERROR: Ingresa solo dos numeros enteros entre 0 y [LARGO_CODIGO]
separados por un espacio en blanco.'
 3 y 4: 'ERROR: Las notas no son correctas, por favor verifica los valores.'}
function leerNotas(var b, r: byte; var errorMessage: string): boolean;
var buenas, regulares ,EEB : char;
begin
  readln(buenas,EEB,regulares);

  if (ord(buenas)< 48) or (ord(buenas) > 52) or (ord(regulares)< 48) or (ord(regulares) > 52) then begin
     errorMensaje:= 'ERROR: Ingresa solo dos numeros enteros entre 0 y '+IntToStr(LARGO_CODIGO)+' separados por un espacio en blanco.';
     result:= false;
     exit;
  end else begin
     b:= StrToInt(buenas);
     r:= StrToInt(regulares);
  end;

  if (b+r > LARGO_CODIGO) then begin
    errorMensaje:= 'ERROR: Las notas no son correctas, por favor verifica los valores.';
    result:= false;
    exit;
  end else if  (b=LARGO_CODIGO-1) and (R>=1) then begin
    errorMensaje:= 'ERROR: Las notas no son correctas, por favor verifica los valores.';
    result:= false;
    exit;
  end;

  result:= true;
end;

{Calcula las notas de codAdivinador en función de codPensador. Asigna los buenos
y los regulares a los argumentos con el mismo nombre.}
procedure calcularNota(codAdivinador, codPensador: TCodigo; var buenos, regulares: byte);
begin

end;

{Imprime el codigo en la salida. Deja el cursor justo al final.}
procedure imprimirCodigo(codigo: TCodigo; i: byte);
begin
      write('Nota ',i,' de ',MAX_INTENTOS,' ---> ',codigo,' >> ');
        if not leerNotas(b,r,errorMensaje) then begin
          repeat
          write(errorMensaje,' >> ');
          until leerNotas(b,r,errorMensaje);
      end;
end;

{Genera el código siguiente al actual en forma circular y lo asigna al propio
parámetro codigo. Por ejemplo:
 AAAA --> AAAB
 ABCH --> ABDA (En este caso y el siguiente H es la letra más grande admitida)
 HHHH --> AAAA}
procedure siguienteCodigo(var codigo: TCodigo; h: THistoria);
begin
  i:=LARGO_CODIGO;
  repeat
        case codigo[i] of
        'A' : begin codigo[i]:= 'B';
              if i = 0 then begin i:= 4; end
        end;
        'B' : codigo[i]:= 'C';
        'C' : codigo[i]:= 'D';
        'D' : codigo[i]:= 'E';
        'E' : codigo[i]:= 'F';
        'F' : codigo[i]:= 'G';
        'G' : codigo[i]:= 'H';
        'H' : begin
                   codigo[i]:= 'A';
                   i-=1;
                   end;
        end;
  until esAdecuado(codigo,h);
end;


{Crea una historia vacía y la retorna como valor.}
function crearHistoria(var h: THistoria): THistoria;
var i: byte;
begin
  for i:= 1 to MAX_INTENTOS do h.tope[i]:=0;
end;

{Retorna TRUE si la historia está vacía, FALSE en caso contrario}
function esHistoriaVacia(h: THistoria; i: byte): boolean;
begin
      if h.tope[i] = 0  then begin
          result:= true;
          exit;

      end else result:= false;
end;

{Guarda en la historia un nuevo código con sus respectivas notas asociadas}
procedure guardarNota(var h: THistoria; c: TCodigo; b, r: byte);
var registro: TRegistroNota;
    i, s: byte;

begin
  for i:=1 to MAX_INTENTOS do begin
      if esHistoriaVacia(h,i) then begin
         with registro do begin
         codigo:= c;
         buenos:= b;
         regulares:= r;
         end;
       h.info[i]:= registro;
       h.tope[i]:= 1;
       exit;
      end;
   end;
end;



{Retorna TRUE si el código pasado como argumento es apropiado para postular al
pensador o FALSE si no lo es. Para ello se compara el código con todos los códigos
guardados en la historia evaluando sus notas. Si estas notas coinciden entonces
el código es adecuado, si un caso falla entonces ya no lo será.}
function esAdecuado(c: TCodigo; h: THistoria): boolean;
var buenosExtra, regularesExtra, i, j, n, s: byte;
    codigoExtra, codigoExtraC: TCodigo;
begin

  for s:=1 to MAX_INTENTOS do begin

  codigoExtraC:= c;
  codigoExtra:= h.info[s].codigo;
  buenosExtra:= 0;
  regularesExtra:= 0;


  if not esHistoriaVacia(h,s) then begin
     for i:=1 to LARGO_CODIGO do begin
         if c[i] = h.info[s].codigo[i] then begin
         buenosExtra+=1;
         h.info[s].codigo[i]:= '1';
         c[i]:= '1';
         end;
     end;
  {con este for comprobamos si el codigo que ingresa el usuario hay un regular}
       for j:=1 to LARGO_CODIGO do begin
       for n:=1 to LARGO_CODIGO do begin
           if c[n] = h.info[s].codigo[j] then begin
             case c[n] of
             '1' : ;
             '2' : ;
             else begin
              regularesExtra+=1;
              h.info[s].codigo[j]:=('2');
              c[n]:='2';
              end;

              end;

           end;
         end;
         end;
     end else exit;
     h.info[s].codigo:= codigoExtra;
     c:= codigoExtraC;
     if (buenosExtra = h.info[s].buenos) and (regularesExtra = h.info[s].regulares) then begin
        result:= true;
     end else begin
        result:= false;
        exit;
     end;

 end;
end;

begin
writeln('MasterMind V3.0');
writeln('Dispones de ',MAX_INTENTOS,' para adivinar el codigo ');
writeln;
crearHistoria(histori);
generarCodigo(codigo);
for i:= 1 to MAX_INTENTOS do begin
imprimirCodigo(codigo,i);
guardarNota(histori,codigo,b,r);
siguienteCodigo(codigo,histori);
end;



readln;
end.
