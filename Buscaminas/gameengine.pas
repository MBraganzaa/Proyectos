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

implementation

function EsPosicionValida(juego: TipoJuego; fila, columna: integer): boolean;
begin
	EsPosicionValida:= (fila>0)AND(fila<=juego.tablero.topeFila)AND(columna>0)AND(columna<=juego.tablero.topeColumna);
end;

procedure IniciarJuego(var juego: TipoJuego; cuantas_filas: RangoFila; cuantas_columnas: RangoColumna; cuantas_bombas: integer);
var fila, columna, bombas: INTEGER;
begin

end;

procedure Descubrir(var juego: TipoJuego; posicion: TipoPosicion);
begin

end;

procedure Marcar(var juego: TipoJuego; posicion: TipoPosicion);
begin

end;

procedure DesMarcar(var juego: TipoJuego; posicion: TipoPosicion);
begin

end;

function CircundantesMarcadas(juego: TipoJuego; posicion: TipoPosicion): integer;
begin

end;

function CircundantesNoDescubiertas(juego: TipoJuego; posicion: TipoPosicion): integer;
begin

end;

procedure MarcarCircundantes(var juego: TipoJuego; posicion: TipoPosicion);
begin

end;

procedure DescubrirSegura(var juego: TipoJuego);
begin

end;
end.

