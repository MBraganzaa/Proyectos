unit Motor;         

interface
const
    MAX_INTENTOS = 10; //*
    LARGO_CODIGO = 4;     //*
    PRIMERA_LETRA = 'A';  //*
    ULTIMA_LETRA = 'H';   //*

type
    TModoJuego= (ADIVINADOR,PENSADOR);
    TEstadoJuego= (INICIADO,GANO,PERDIO,TRAMPA);
    TLetras= PRIMERA_LETRA..ULTIMA_LETRA; //*
    TCodigo= array[1..LARGO_CODIGO] of TLetras;
    TRegistroNota= record
        codigo: TCodigo;
        buenos, regulares: byte;
    end;
    THistoria= record
	info : array [1..MAX_INTENTOS] of TRegistroNota;
	tope : array [1..MAX_INTENTOS] of byte;
    end;
    TPartida= record
        historial: THistoria;
        intentoActual: 0..MAX_INTENTOS;
        adivinador, pensador: TCodigo;
        modo: TModoJuego;
        estado: TEstadoJuego;
    end;

{Genera un código al azar y lo asigna a la variable codigo. El codigo generado
puede contener letras repetidas.}
procedure generarCodigo(var codigo: TCodigo);

{Lee el codigo de la entrada estandar y lo asigna a la variable codigo. Ademas
retorna el valor TRUE si el codigo leido es correcto, FALSE sino. Consume el fin de linea.
El codigo leido puede ser incorrecto si:
   * Contiene uno o mas caracteres fuera del rango [PRIMERA_LETRA,ULTIMA_LETRA].
   * No contiene el largo LARGO_CODIGO}
function leerCodigo(var codigo: TCodigo; var errorMessage: string): boolean;

{Lee dos notas a la vez: B y R y retorna TRUE si son correctas o FALSE si no lo son.
En caso de que las notas no sean correctas B y R quedan con el valor 0.
El fin de linea es consumido.
Para verificar que las notas sean correctas se contempla lo siguiente:

   1: Son valores enteros
   2: Están entre 0 y LARGO_CODIGO
   3: La suma de B+R no puede ser mayor que LARGO_CODIGO

Asigna a la variable errorMessage uno de estos dos mensajes según el caso:

   1 y 2: 'ERROR: Ingresa solo dos numeros enteros entre 0 y [LARGO_CODIGO] separados por un espacio en blanco.'
   3: 'ERROR: Las notas no son correctas, por favor verifica los valores.'
}
function leerNotas(var b, r: byte; var errorMessage: string): boolean;

{Calcula las notas de codAdivinador en función de codPensador. Asigna los buenos
y los regulares a los argumentos con el mismo nombre.}
procedure calcularNota(codAdivinador, codPensador: TCodigo; var buenos, regulares: byte);

{Imprime el codigo en la salida. Deja el cursor justo al final.}
procedure imprimirCodigo(codigo: TCodigo);

{Genera el codigo siguiente al actual en forma cirular y asigna al propio
parámetro codigo. Por ejemplo:
AAAA --> AAAB
ABCH --> ABDA (En este caso H es la letra más grande admitida)
HHHH --> AAAA}
procedure siguienteCodigo(var codigo: TCodigo);

{Crea una historia vacía y la retorna como valor.}
function crearHistoria(): THistoria;

{Retorna TRUE si la historia está vacía, FALSE en caso contrario}
function esHistoriaVacia(h: THistoria): boolean;

{Guarda en la historia un nuevo código con sus respectivas notas asociadas}
procedure guardarNota(var h: THistoria; codigo: TCodigo; buenos, regulares: integer);

{Retorna TRUE si el código pasado como argumento es apropiado para postular al
pensador o FALSE si no lo es. Para ello se compara el código con todos los códigos
guardados en la historia evaluando sus notas. Si estas notas coinciden entonces
el código es adecuado, si un caso falla entonces ya no lo será.}
function esAdecuado(c: TCodigo; h: THistoria): boolean;

{Inicia una nueva partida en el modo de juego indicado. El estado se establece en INICIADO.}
procedure iniciarJuego(modoPartida: TModoJuego; var j: TPartida);

{Indica si los dos codigos pasados son iguales}
function sonIguales(c1, c2: TCodigo): boolean;

{Muestra un código del adivinador y sus respectivas notas frente al código del pensador.
Este procedimiento aumenta en 1 los intentos del juego, y determina además el estado
en que debe quedar la partida:

   * INICIADO: Si el adivinador aun tiene inentos disponibles y no ha adivinado
   * GANO: Si el adivinador ha acertado el codigo antes de agotar sus intentos.
   * PERDIO: Si el adivinador ha agotado sus intentos.
   * TRAMPA: Si el pensador hizo trampa al otorgar las notas. (solo para el modo ADIVINADOR)}
procedure presentarCodigo(codigo: TCodigo; b, r: byte; var j: TPartida);

implementation
uses sysutils;

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

{Lee el codigo de la entrada estandar y lo asigna a la variable codigo. Ademas             //******************************
retorna el valor TRUE si el codigo leido es correcto, FALSE sino. Consume el fin de linea.
El codigo leido puede ser incorrecto si:
   1 Contiene uno o mas caracteres fuera del rango [PRIMERA_LETRA,ULTIMA_LETRA].
   2 No contiene el largo LARGO_CODIGO

El mensaje de error se asignará a errorMessage según el caso:

   1: 'Solo puedes ingresar letras entre [PRIMERA_LETRA] y [ULTIMA_LETRA].'
   2: 'El largo del codigo debe ser de [LARGO_CODIGO] letras.'}
function leerCodigo(var codigo: TCodigo; var errorMessage: string): boolean;
begin

end;

{Lee dos notas a la vez: B y R y retorna TRUE si son correctas o FALSE si no lo son.
En caso de que las notas no sean correctas B y R quedan con el valor 0.
El fin de linea es consumido.
Para verificar que las notas sean correctas se contempla lo siguiente:

   1: Son valores enteros
   2: Están entre 0 y LARGO_CODIGO
   3: La suma de B+R no puede ser mayor que LARGO_CODIGO

Asigna a la variable errorMessage uno de estos dos mensajes según el caso:

   1 y 2: 'ERROR: Ingresa solo dos numeros enteros entre 0 y [LARGO_CODIGO] separados por un espacio en blanco.'
   3: 'ERROR: Las notas no son correctas, por favor verifica los valores.'
}
function leerNotas(var b, r: integer; var errorMessage: string): boolean;
var buenas, regulares ,EEB : char;
begin
  readln(buenas,EEB,regulares);

  if (ord(buenas)< 48) or (ord(buenas) > 52) or (ord(regulares)< 48) or (ord(regulares) > 52) then begin
     errorMessage:= 'ERROR: Ingresa solo dos numeros enteros entre 0 y '+IntToStr(LARGO_CODIGO)+' separados por un espacio en blanco.';
     result:= false;
     exit;
  end else begin
     b:= StrToInt(buenas);
     r:= StrToInt(regulares);
  end;

  if (b+r > LARGO_CODIGO) then begin
    errorMessage:= 'ERROR: Las notas no son correctas, por favor verifica los valores.';
    result:= false;
    exit;
  end else if  (b=LARGO_CODIGO-1) and (R>=1) then begin
    errorMessage:= 'ERROR: Las notas no son correctas, por favor verifica los valores.';
    result:= false;
    exit;
  end;

  result:= true;
end;

{Calcula las notas de codAdivinador en función de codPensador. Asigna los buenos
y los regulares a los argumentos con el mismo nombre.}
procedure calcularNota(codAdivinador, codPensador: TCodigo; var buenos, regulares: byte);


{Imprime el codigo en la salida. Deja el cursor justo al final.}
procedure imprimirCodigo(codigo: TCodigo);
var b , r: byte;
    errorMessage: string;
begin
    write('Nota '+' de ',MAX_INTENTOS,' ---> ',codigo,' >> ');
        if not leerNotas(b,r,errorMessage) then begin
          repeat
          write(errorMessage,' >> ');
          until leerNotas(b,r,errorMessage);
      end;
end;

{Genera el codigo siguiente al actual en forma cirular y asigna al propio
parámetro codigo. Por ejemplo:
AAAA --> AAAB
ABCH --> ABDA (En este caso H es la letra más grande admitida)
HHHH --> AAAA}
//procedure siguienteCodigo(var codigo: TCodigo);
procedure siguienteCodigo(var codigo: TCodigo; h: THistoria; cod: TCodigo; var errorB : boolean);
var validar, val, valid: boolean;
    n, i, m, p , g: byte;
begin
  errorB := false;
  i:=LARGO_CODIGO;
  n:=LARGO_CODIGO - 1;
  m:=LARGO_CODIGO - 2;
  p:=LARGO_CODIGO - 3;

  repeat
        case codigo[i] of
        'A' : begin codigo[i]:= 'B'; validar:=false;  val:=false; valid:=false; end;
        'B' : codigo[i]:= 'C';
        'C' : codigo[i]:= 'D';
        'D' : codigo[i]:= 'E';
        'E' : codigo[i]:= 'F';
        'F' : codigo[i]:= 'G';
        'G' : codigo[i]:= 'H';
        'H' : begin
              codigo[i]:= 'A';
              validar:= true;
        end;
        end;
  if (cod = codigo) and (g = 40) then begin
  errorB:= true;
  exit;
  end;
  if validar then begin
    case codigo[n] of
        'A' : codigo[n]:= 'B';
        'B' : codigo[n]:= 'C';
        'C' : codigo[n]:= 'D';
        'D' : codigo[n]:= 'E';
        'E' : codigo[n]:= 'F';
        'F' : codigo[n]:= 'G';
        'G' : codigo[n]:= 'H';
        'H' : begin
              codigo[n]:= 'A';
              val:= true;
        end;
        end;
        end;

  if val then begin
    case codigo[m] of
        'A' : codigo[m]:= 'B';
        'B' : codigo[m]:= 'C';
        'C' : codigo[m]:= 'D';
        'D' : codigo[m]:= 'E';
        'E' : codigo[m]:= 'F';
        'F' : codigo[m]:= 'G';
        'G' : codigo[m]:= 'H';
        'H' : begin
              codigo[m]:= 'A';
              valid:= true;
        end;
        end;
        end;

  if valid then begin
    case codigo[p] of
        'A' : codigo[p]:= 'B';
        'B' : codigo[p]:= 'C';
        'C' : codigo[p]:= 'D';
        'D' : codigo[p]:= 'E';
        'E' : codigo[p]:= 'F';
        'F' : codigo[p]:= 'G';
        'G' : codigo[p]:= 'H';
        'H' : begin
              codigo[p]:= 'A';
              g+=1;
        end;
        end;
        end;
  until esAdecuado(codigo,h);

end;

{Crea una historia vacía y la retorna como valor.}
//function crearHistoria(): THistoria;
function crearHistoria(var h: THistoria): THistoria;
var i: byte;
begin
  for i:= 1 to MAX_INTENTOS do begin
  h.tope[i]:=0;
  end;
end;

{Retorna TRUE si la historia está vacía, FALSE en caso contrario}
//function esHistoriaVacia(h: THistoria): boolean;
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
    i: byte;
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
             if c[n] = '1' then begin
             c[n]:= '1';
             end else if c[n] = '2'then begin
             c[n]:='2';
             end else begin
              regularesExtra+=1;
              h.info[s].codigo[j]:=('2');
              c[n]:='2';
              end; end;
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

procedure iniciarJuego(modoPartida: TModoJuego; var j: TPartida);
begin

end;

function sonIguales(c1, c2: TCodigo): boolean;
begin

end;

procedure presentarCodigo(codigo: TCodigo; b, r: byte; var j: TPartida);
begin

end;


end.
