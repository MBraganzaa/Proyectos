unit gameEngine;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils;

const
    //Valores predefinidos para las dificultades del juego.
    ANCHO_FACIL= 5;
    LARGO_FACIL= 10;
    MINAS_FACIL= 5;
    ANCHO_MEDIO= 10;
    LARGO_MEDIO= 20;
    MINAS_MEDIO= 35;
    ANCHO_DIFICIL= 20;
    LARGO_DIFICIL= 30;
    MINAS_DIFICIL= 70;

    //Valores predefinidos para las dimensiones maximas y minimas del tablero
    MIN_ANCHO=5;
    MIN_LARGO=5;
    MAX_ANCHO=100;
    MAX_LARGO=100;

type
    //Tipo que establece los posibles estados de una celda.
    TipoEstadoCelda = (OCULTA,MARCADA,DESCUBIERTA);

    //Una celda del tablero.
    TipoCelda = record
       tieneBomba: boolean;
       estado : TipoEstadoCelda;
       bombasCircundantes: byte;
    end;

    //Los rangos del tablero para definir el arreglo bidimensional.
    RangoFila    = 1..MAX_ANCHO;
    RangoColumna = 1..MAX_LARGO;

    //El tablero: una grilla con topes (tal como hicimos en el Juego de la Vida).
    TipoTablero = record
        celdas : array[RangoFila,RangoColumna] of TipoCelda;
        topeFila    : RangoFila;
        topeColumna : RangoColumna;
    end;

    //El estado del juego
    TipoEstadoJuego = (JUGANDO,GANADO,PERDIDO);

    //El tipo Juego, que unifica todos los anteriores.
    TipoJuego = record
        estado: TipoEstadoJuego;
        tablero: TipoTablero;
        bombas,                    (* cantidad de bombas en el tablero *)
        marcadas,                  (* cantidad de celdas marcadas *)
        descubiertas : integer;     (* cantidad de celdas descubiertas *)
    end;

    //Una posición en el tablero dada por su fila y su columna.
    TipoPosicion = record
        fila: RangoFila;
        columna: RangoColumna;
    end;

function EsPosicionValida(juego: TipoJuego; fila, columna: integer): boolean;

procedure IniciarJuego(var juego: TipoJuego; cuantas_filas: RangoFila; cuantas_columnas: RangoColumna; cuantas_bombas: integer);

procedure Descubrir(var juego: TipoJuego; posicion: TipoPosicion);

procedure Marcar(var juego: TipoJuego; posicion: TipoPosicion);

procedure DesMarcar(var juego: TipoJuego; posicion: TipoPosicion);

function CircundantesMarcadas(juego: TipoJuego; posicion: TipoPosicion): integer;

function CircundantesNoDescubiertas(juego: TipoJuego; posicion: TipoPosicion): integer;

procedure MarcarCircundantes(var juego: TipoJuego; posicion: TipoPosicion);

procedure DescubrirSegura(var juego: TipoJuego);

procedure aumentarMinasCircundantesAlrededor(fila,columna : integer; var juego: tipojuego);

procedure repartirMinas(var juego: TipoJuego; fil,colum: integer);

implementation

function EsPosicionValida(juego: TipoJuego; fila, columna: integer): boolean;
begin
     EsPosicionValida:= (fila>=1)AND(fila<=juego.tablero.topeFila)AND(columna>=1)AND(columna<=juego.tablero.topeColumna);
end;

{Dado por referencia un parámetro de tipo TipoJuego y una posición en el tablero,
esta operación aumentará en 1 la cantidad de minas circundantes de todas
las celdas alrededor de la posición dada.}
procedure aumentarMinasCircundantesAlrededor(fila,columna : integer; var juego: tipojuego);
begin
     if EsPosicionValida(juego,fila-1,columna-1) then juego.tablero.celdas[fila-1,columna-1].bombasCircundantes+=1;
     if EsPosicionValida(juego,fila,columna-1) then juego.tablero.celdas[fila,columna-1].bombasCircundantes+=1;
     if EsPosicionValida(juego,fila+1,columna-1) then juego.tablero.celdas[fila+1,columna-1].bombasCircundantes+=1;
     if EsPosicionValida(juego,fila-1,columna) then juego.tablero.celdas[fila-1,columna].bombasCircundantes+=1;
     if EsPosicionValida(juego,fila+1,columna) then juego.tablero.celdas[fila+1,columna].bombasCircundantes+=1;
     if EsPosicionValida(juego,fila-1,columna+1) then juego.tablero.celdas[fila-1,columna+1].bombasCircundantes+=1;
     if EsPosicionValida(juego,fila,columna+1) then juego.tablero.celdas[fila,columna+1].bombasCircundantes+=1;
     if EsPosicionValida(juego,fila+1,columna+1) then juego.tablero.celdas[fila+1,columna+1].bombasCircundantes+=1;
end;

{Se encargaría de repartir todas las minas al azar por el tablero.
Cada vez que una celda se marque con una mina, se invoca a la operación
aumentarMinasCircundantesAlrededor sobre la posición de la celda actual. Esta
operación debería recibir por referencia un parámetro de TipoJuego y la cantidad de minas a
repartir por el tablero.}
procedure repartirMinas(var juego: TipoJuego; fil,colum :integer);
var i,fila,columna: integer;
begin
     randomize;
     for i:=1 to juego.bombas do begin
       fila:= random(fil+1);
       columna:= random(colum+1);
       while juego.tablero.celdas[fila,columna].tieneBomba or not EsPosicionValida(juego,fila,columna) do begin
       fila:= random(fil+1);
       columna:=random(colum+1);
       end;
       juego.tablero.celdas[fila,columna].tieneBomba:=true;
       aumentarMinasCircundantesAlrededor(fila,columna,juego);
     end;
end;

{Inicia todos los atributos del parámetro juego para iniciar una
partida con el largo (columnas) y ancho (filas) establecidos, ubicando
al azar la cantidad de minas (bombas) indicadas. El estado del juego
se establecerá en JUGANDO. Las minas serán repartidas al azar por el
tablero, y todas las celdas estarán ocultas.
Las celdas deberán tener el valor correcto de minas circundantes según
la cantidad de minas que haya a su alrededor.}
procedure IniciarJuego(var juego: TipoJuego; cuantas_filas: RangoFila; cuantas_columnas: RangoColumna; cuantas_bombas: integer);
var fila, columna, bombas: INTEGER;
begin
     fila:= cuantas_filas;
     columna:= cuantas_columnas;
     bombas:= cuantas_bombas;

     juego.estado:= JUGANDO;
     juego.bombas:= bombas;
     juego.tablero.topeFila:= fila;
     juego.tablero.topeColumna:= columna;

     repartirMinas(juego,fila,columna);
end;

procedure Descubrir(var juego: TipoJuego; posicion: TipoPosicion);
const MAX_POSICIONES= MAX_ANCHO*MAX_LARGO;
type TListaPendientes= record
     posiciones: array[1..MAX_POSICIONES] of TipoPosicion;
     tope: integer;
     end;
var pendientes : TListaPendientes;
    pos : TipoPosicion;
    i, iT : integer;
begin
     pendientes.tope:=0;
     pos:= posicion;
     i:=0;
     iT:=0;
     pendientes.posiciones[i]:= pos;

     repeat
     if juego.tablero.celdas[pendientes.posiciones[i].fila ,pendientes.posiciones[i].columna].tieneBomba then begin
             juego.estado:= PERDIDO;
             juego.tablero.celdas[pendientes.posiciones[i].fila,pendientes.posiciones[i].columna].estado:= DESCUBIERTA;
     end else if
             juego.tablero.celdas[pendientes.posiciones[i].fila-1,pendientes.posiciones[i].columna-1].tieneBomba or
             juego.tablero.celdas[pendientes.posiciones[i].fila,pendientes.posiciones[i].columna-1].tieneBomba or
             juego.tablero.celdas[pendientes.posiciones[i].fila+1,pendientes.posiciones[i].columna-1].tieneBomba or
             juego.tablero.celdas[pendientes.posiciones[i].fila-1,pendientes.posiciones[i].columna].tieneBomba or
             juego.tablero.celdas[pendientes.posiciones[i].fila+1,pendientes.posiciones[i].columna].tieneBomba or
             juego.tablero.celdas[pendientes.posiciones[i].fila-1,pendientes.posiciones[i].columna+1].tieneBomba or
             juego.tablero.celdas[pendientes.posiciones[i].fila,pendientes.posiciones[i].columna+1].tieneBomba or
             juego.tablero.celdas[pendientes.posiciones[i].fila+1,pendientes.posiciones[i].columna+1].tieneBomba
             then begin
             if juego.tablero.celdas[pendientes.posiciones[i].fila,pendientes.posiciones[i].columna].estado = OCULTA then begin
             juego.tablero.celdas[pendientes.posiciones[i].fila,pendientes.posiciones[i].columna].estado:=DESCUBIERTA;
             juego.descubiertas+=1;
             end;
     end else begin
             if juego.tablero.celdas[pendientes.posiciones[i].fila,pendientes.posiciones[i].columna].estado = OCULTA then begin
              juego.tablero.celdas[pendientes.posiciones[i].fila,pendientes.posiciones[i].columna].estado:=DESCUBIERTA;
              juego.descubiertas+=1;
             end;
                  //  1
                  iT+=1;
                  pendientes.tope+=1;
                  pos.fila:= pendientes.posiciones[i].fila-1;
                  pos.columna:= pendientes.posiciones[i].columna-1;
                  pendientes.posiciones[iT]:= pos;
              if (juego.tablero.celdas[pendientes.posiciones[iT].fila,pendientes.posiciones[iT].columna].estado = DESCUBIERTA)
              or not EsPosicionValida(juego,pendientes.posiciones[iT].fila,pendientes.posiciones[iT].columna) then begin
                  iT-=1;
                  pendientes.tope-=1;
              end else begin
                  juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado:=DESCUBIERTA;
                  juego.descubiertas+=1;
              end;
                  //  2
                  iT+=1;
                  pendientes.tope+=1;
                  pos.fila:= pendientes.posiciones[i].fila;
                  pos.columna:= pendientes.posiciones[i].columna-1;
                  pendientes.posiciones[iT]:= pos;
              if (juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado = DESCUBIERTA)
                   or not EsPosicionValida(juego,pendientes.posiciones[it].fila,pendientes.posiciones[it].columna) then begin
                  iT-=1;
                  pendientes.tope-=1;
              end else begin
                  juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado:=DESCUBIERTA;
                  juego.descubiertas+=1;
              end;
                  //  3
                  iT+=1;
                  pendientes.tope+=1;
                  pos.fila:= pendientes.posiciones[i].fila+1;
                  pos.columna:= pendientes.posiciones[i].columna-1;
                  pendientes.posiciones[iT]:= pos;
              if (juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado = DESCUBIERTA)
              or not EsPosicionValida(juego,pendientes.posiciones[it].fila,pendientes.posiciones[it].columna) then begin
                  iT-=1;
                  pendientes.tope-=1;
              end else begin
                  juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado:=DESCUBIERTA;
                  juego.descubiertas+=1;
              end;
                  //  4
                  iT+=1;
                  pendientes.tope+=1;
                  pos.fila:= pendientes.posiciones[i].fila-1;
                  pos.columna:= pendientes.posiciones[i].columna;
                  pendientes.posiciones[iT]:= pos;
              if (juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado = DESCUBIERTA)
              or not EsPosicionValida(juego,pendientes.posiciones[it].fila,pendientes.posiciones[it].columna) then begin
                  iT-=1;
                  pendientes.tope-=1;
              end else begin
                  juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado:=DESCUBIERTA;
                  juego.descubiertas+=1;
              end;
                  //  5
                  iT+=1;
                  pendientes.tope+=1;
                  pos.fila:= pendientes.posiciones[i].fila+1;
                  pos.columna:= pendientes.posiciones[i].columna;
                  pendientes.posiciones[iT]:= pos;
              if (juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado = DESCUBIERTA)
              or not EsPosicionValida(juego,pendientes.posiciones[it].fila,pendientes.posiciones[it].columna) then begin
                  iT-=1;
                  pendientes.tope-=1;
              end else begin
                  juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado:=DESCUBIERTA;
                  juego.descubiertas+=1;
              end;
                  //  6
                  iT+=1;
                  pendientes.tope+=1;
                  pos.fila:= pendientes.posiciones[i].fila-1;
                  pos.columna:= pendientes.posiciones[i].columna+1;
                  pendientes.posiciones[iT]:= pos;
              if (juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado = DESCUBIERTA)
              or not EsPosicionValida(juego,pendientes.posiciones[it].fila,pendientes.posiciones[it].columna) then begin
                  iT-=1;
                  pendientes.tope-=1;
              end else begin
                  juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado:=DESCUBIERTA;
                  juego.descubiertas+=1;
              end;
                  //  7
                  iT+=1;
                  pendientes.tope+=1;
                  pos.fila:= pendientes.posiciones[i].fila;
                  pos.columna:= pendientes.posiciones[i].columna+1;
                  pendientes.posiciones[iT]:= pos;
              if (juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado = DESCUBIERTA)
              or not EsPosicionValida(juego,pendientes.posiciones[it].fila,pendientes.posiciones[it].columna) then begin
                  iT-=1;
                  pendientes.tope-=1;
              end else begin
                  juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado:=DESCUBIERTA;
                  juego.descubiertas+=1;
              end;
                  //  8
                  iT+=1;
                  pendientes.tope+=1;
                  pos.fila:= pendientes.posiciones[i].fila+1;
                  pos.columna:= pendientes.posiciones[i].columna+1;
                  pendientes.posiciones[iT]:= pos;
              if (juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado = DESCUBIERTA)
              or not EsPosicionValida(juego,pendientes.posiciones[it].fila,pendientes.posiciones[it].columna) then begin
                    iT-=1;
                    pendientes.tope-=1;
              end else begin
                  juego.tablero.celdas[pendientes.posiciones[it].fila,pendientes.posiciones[it].columna].estado:=DESCUBIERTA;
                  juego.descubiertas+=1;
              end;
     end;

     if pendientes.tope > 0 then begin
        i+=1;
        pendientes.tope-=1;
     end else pendientes.tope-=1;

     until pendientes.tope = (-1) ;
end;

{Aplica la acción de marcar sobre la celda en la posición dada. Si la
posición no es correcta no se hace nada. Si la celda esta OCULTA se
cambia su estado a MARCADA, en cualquier otro caso no se hace nada. Se
aumenta la cuenta de celdas marcadas en 1.}
procedure Marcar(var juego: TipoJuego; posicion: TipoPosicion);
begin
     if EsPosicionValida(juego,posicion.fila,posicion.columna) then begin
        if (juego.tablero.celdas[posicion.fila,posicion.columna].estado = OCULTA) then begin
        juego.tablero.celdas[posicion.fila,posicion.columna].estado:= MARCADA;
        juego.marcadas+=1;
        end;
     end;
end;
{Aplica la acción de desmarcar sobre la celda en la posición dada. Si
la posición no es correcta no se hace nada. Si la celda esta MARCADA
se cambia su estado a OCULTA, en cualquier otro caso no se hace nada.
Se disminuye la cuenta de celdas marcadas en 1.}
procedure DesMarcar(var juego: TipoJuego; posicion: TipoPosicion);
begin
     if EsPosicionValida(juego,posicion.fila,posicion.columna) then begin
       if (juego.tablero.celdas[posicion.fila,posicion.columna].estado = MARCADA) then begin
        juego.tablero.celdas[posicion.fila,posicion.columna].estado:= OCULTA;
        juego.marcadas-=1;
        end;
     end;
end;
{Retorna la cantidad de celdas que están alrededor de la celda en
cuestión cuyo estado es MARCADA. Si no hay ninguna retorna 0. Si la
posición no es válida no hace nada.}
function CircundantesMarcadas(juego: TipoJuego; posicion: TipoPosicion): integer;
var valor : integer;
begin
     valor:=0;
     if (juego.tablero.celdas[posicion.fila-1,posicion.columna-1].estado = MARCADA) AND (EsPosicionValida(juego,posicion.fila-1,posicion.columna-1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila,posicion.columna-1].estado = MARCADA) AND (EsPosicionValida(juego,posicion.fila,posicion.columna-1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila+1,posicion.columna-1].estado = MARCADA) AND (EsPosicionValida(juego,posicion.fila+1,posicion.columna-1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila-1,posicion.columna].estado = MARCADA) AND (EsPosicionValida(juego,posicion.fila-1,posicion.columna)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila+1,posicion.columna].estado = MARCADA) AND (EsPosicionValida(juego,posicion.fila+1,posicion.columna)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila-1,posicion.columna+1].estado = MARCADA) AND (EsPosicionValida(juego,posicion.fila-1,posicion.columna+1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila,posicion.columna+1].estado = MARCADA) AND (EsPosicionValida(juego,posicion.fila,posicion.columna+1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila+1,posicion.columna+1].estado = MARCADA) AND (EsPosicionValida(juego,posicion.fila+1,posicion.columna+1)) then valor+=1;
     result:= valor;
end;

{Retorna la cantidad de celdas que están alrededor de la celda en
cuestión cuyo estado es MARCADA u OCULTA (distinto de DESCUBIERTA). Si
no hay ninguna retorna 0. Si la posición no es válida no hace nada.}
function CircundantesNoDescubiertas(juego: TipoJuego; posicion: TipoPosicion): integer;
var valor: integer;
begin
     valor:=0;
     if (juego.tablero.celdas[posicion.fila-1,posicion.columna-1].estado <> DESCUBIERTA) AND (EsPosicionValida(juego,posicion.fila-1,posicion.columna-1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila,posicion.columna-1].estado <> DESCUBIERTA) AND (EsPosicionValida(juego,posicion.fila,posicion.columna-1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila+1,posicion.columna-1].estado <> DESCUBIERTA) AND (EsPosicionValida(juego,posicion.fila+1,posicion.columna-1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila-1,posicion.columna].estado <> DESCUBIERTA) AND (EsPosicionValida(juego,posicion.fila-1,posicion.columna)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila+1,posicion.columna].estado <> DESCUBIERTA) AND (EsPosicionValida(juego,posicion.fila+1,posicion.columna)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila-1,posicion.columna+1].estado <> DESCUBIERTA) AND (EsPosicionValida(juego,posicion.fila-1,posicion.columna+1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila,posicion.columna+1].estado <> DESCUBIERTA) AND (EsPosicionValida(juego,posicion.fila,posicion.columna+1)) then valor+=1;
     if (juego.tablero.celdas[posicion.fila+1,posicion.columna+1].estado <> DESCUBIERTA) AND (EsPosicionValida(juego,posicion.fila+1,posicion.columna+1)) then valor+=1;
     result:= valor;
end;

{Esta acción se lleva a cabo solo si la posición es correcta y si la
celda en cuestión ya está descubierta. La cantidad de celdas
circundantes OCULTAS o MARCADAS sebe ser igual a la cantidad de minas
alrededor de esta celda. Todas las celdas circundantes quedan
marcadas.}
procedure MarcarCircundantes(var juego: TipoJuego; posicion: TipoPosicion);
var valor: integer;
begin
     if (juego.tablero.celdas[posicion.fila,posicion.columna].estado = DESCUBIERTA) AND (EsPosicionValida(juego,posicion.fila,posicion.columna)) then begin
        valor:=0;
        if (juego.tablero.celdas[posicion.fila-1,posicion.columna-1].tieneBomba) AND (EsPosicionValida(juego,posicion.fila-1,posicion.columna-1)) then valor+=1;
        if (juego.tablero.celdas[posicion.fila,posicion.columna-1].tieneBomba) AND (EsPosicionValida(juego,posicion.fila,posicion.columna-1)) then valor+=1;
        if (juego.tablero.celdas[posicion.fila+1,posicion.columna-1].tieneBomba) AND (EsPosicionValida(juego,posicion.fila+1,posicion.columna-1)) then valor+=1;
        if (juego.tablero.celdas[posicion.fila-1,posicion.columna].tieneBomba) AND (EsPosicionValida(juego,posicion.fila-1,posicion.columna)) then valor+=1;
        if (juego.tablero.celdas[posicion.fila+1,posicion.columna].tieneBomba) AND (EsPosicionValida(juego,posicion.fila+1,posicion.columna)) then valor+=1;
        if (juego.tablero.celdas[posicion.fila-1,posicion.columna+1].tieneBomba) AND (EsPosicionValida(juego,posicion.fila-1,posicion.columna+1)) then valor+=1;
        if (juego.tablero.celdas[posicion.fila,posicion.columna+1].tieneBomba) AND (EsPosicionValida(juego,posicion.fila,posicion.columna+1)) then valor+=1;
        if (juego.tablero.celdas[posicion.fila+1,posicion.columna+1].tieneBomba) AND (EsPosicionValida(juego,posicion.fila+1,posicion.columna+1)) then valor+=1;
     //
        if CircundantesNoDescubiertas(juego,posicion) = valor then begin
           juego.tablero.celdas[posicion.fila-1,posicion.columna-1].estado:= MARCADA;
           juego.tablero.celdas[posicion.fila,posicion.columna-1].estado:= MARCADA;
           juego.tablero.celdas[posicion.fila+1,posicion.columna-1].estado := MARCADA;
           juego.tablero.celdas[posicion.fila-1,posicion.columna].estado := MARCADA;
           juego.tablero.celdas[posicion.fila+1,posicion.columna].estado := MARCADA;
           juego.tablero.celdas[posicion.fila-1,posicion.columna+1].estado := MARCADA;
           juego.tablero.celdas[posicion.fila,posicion.columna+1].estado := MARCADA;
           juego.tablero.celdas[posicion.fila+1,posicion.columna+1].estado := MARCADA;
        end;
     end;

end;

{Aplica la acción Descubrir sobre una celda al azar del tablero, que
aún esté OCULTA y que además no tenga mina (bomba).}
procedure DescubrirSegura(var juego: TipoJuego);
var fila,columna : integer;
begin
randomize;
fila := random(juego.tablero.topeFila+1);
columna := random(juego.tablero.topeColumna+1);

   if (juego.tablero.celdas[fila,columna].estado = OCULTA) AND NOT juego.tablero.celdas[fila,columna].tieneBomba then begin
       juego.tablero.celdas[fila,columna].estado:= DESCUBIERTA;
       juego.descubiertas+=1;
   end else begin
       fila := random(juego.tablero.topeFila+1);
       columna := random(juego.tablero.topeColumna+1);
   end;
end;
end.

