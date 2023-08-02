unit theLife;

{$mode objfpc}{$H+}

{****************************************************************************}
{              INTERFACE: DELCARACION DE TIPOS Y SUBPROGRAMAS                }
{****************************************************************************}
interface

const MAX_WIDTH= 1000; //El largo máximo de celdas admitidas.
      MAX_HEIGHT= 1000;//El ancho (altura) máximo de celdas admitidas.

type
     RangoFilas= 1..MAX_HEIGHT;  //Números entre 1 y 1000 en este caso.
     RangoColumnas= 1..MAX_WIDTH;//Números entre 1 y 1000 en este caso.
     {Este tipo es registro que contiene un tablero (arreglo bidimensional)
     llamado cells (células) no es otra cosa que una tablero de booleanos.
     Los atributos topW y topH indican hasta dónde se recorren las columnas
     y las filas respectivamente.}
     LifeGrid= record
        cells: array[RangoFilas,RangoColumnas] of boolean;
        topW, topH: integer;
     end;
     {Este tipo contiene dos tableros de tipo LifeGrid, uno para las celulas actuales
     y otro para crear la siguiente generación según las reglas del juego, que
     luego será pasado a la generación actual de células vivas.}
     LifeField= record
         celulasVivas: lifeGrid;    //Tablero de celulas actuales
         nuevaGeneracion: lifeGrid; //Tablero de la siguiente generacion a crear
         generaciones: longint;     //Cantidad de generaciones
         poblacion: longint;        //Cantidad de celulas vivas actualmente.
     end;

{Inicializa el tablero de células vivas con el alto (h) y el largo (w) dados.
Nótese que h indica la cantidad de filas (el alto) y w la cantidad de filas (el largo).
El numero de generaciones se establece en 1 ya que esta es la primera generacion.
Se generaran al azar celulas vivas en todo el tablero, y el numero de generaciones
indicará cuántas hay.
El parámetro l será el que surfirá los cambios, dado que se pasa por referencia.}
procedure init(h: RangoFilas; w: RangoColumnas; var l: lifeField);

{Dada una posicion del tablero (i,j) en celulasVivas, contará cuántas células vivas hay alrededor de esa celda
específicamente, y retornará dicho valor.}
function getCelulasVivas(i: RangoFilas; j:RangoColumnas; var l: lifeField): byte;

{Aumentará el contador de generaciones en 1. Además actualizará el tablero
en función de las células que hay siguiendo las reglas del Juego de la Vida
de Jhon Conway:

* Si una celula esta muerta pasará a estar viva solo si hay 3 células a su alrededor,
en otro caso permanecerá muerta.
* Si una celula esta viva permanecerá viva solo si hay 2 o 3 células a su alrededor,
en cualquier otra caso muere.

Para esta implementación se sugiere utilizar los arreglos celulasVivas y nuevaGeneracion
definidos en el tipo LifeField (CampoVivo), de forma tal que se verifican las condiciones
en celulasVivas y se crea el nuevo tablero en nuevaGeneracion. Se sugiere lo siguiente:

* La población se reinicia a cero.
* Las celulas vivas son celdas con el valor TRUE, y las muertas celdas con el valor FALSE.
* Se recorre cada celda del arreglo celulasVivas y se verifica su estado y cuantas celulas vivas hay alrededor.
* Si una celda en celulasVivas está muerta (FALSE) y tiene 3 celulas vivas alrededor, esa misma posicion se pondrá
en TRUE en nuevaGeneracion.
* Si una celda en ceulasVivas está muerta y no tiene 3 celulas vivas exactamente a su alrededor, se pondrá en
FALSE en nuevaGeneracion.
* Si una celula esta viva en celuasVivas y tiene 2 o 3 celulas vivas a su alrededor, se pondrá en TRUE en
nuevaGeneracion.
* Si una celula esta viva en celulasVivas y tiene menos de 2 o más de 3 celulas vivas a su alrededor,
esa posicion se pondrá en FALSE en nuevaGeneracion.
* Cada vez que se establece una celula como viva en nuevaGeneracion se suma 1 al contador de población.

Cuando se ha recorrido todo el tablero, se recorrerá nuevaGeneracion y se copiaran sus valores a celulasVivas
quedando ambos tableros de forma identica.}
procedure nextGeneration(var l: lifeField);

{Devolverá TRUE si i y j son valores válidos para el tablero:

i>=1 y i<=topH
j>=1 y j<=topW

Si no se cumplen estas condiciones, retorna FALSE.
El parametro l no se modifica, aunque se pasa por referencia. Esto se hace
simplmente por una cuestión de eficiencia del programa.}
function sonCoordenadasValidas(i, j: integer; var l: lifeField): boolean;

{Establece la celda indicada por i y j como celula viva y aumenta la población en 1.
Si la célula ya estaba viva no se hace nada.}
procedure insertarCelula(i, j: integer; var l: lifeField);


{****************************************************************************}
{                      IMPLEMENTACION DE SUBPROGRAMAS                        }
{****************************************************************************}
implementation

procedure init(h: RangoFilas; w: RangoColumnas; var l: lifeField);
var i,j : integer;
begin
  randomize;
  with l do begin
    celulasVivas.topH:= h;
    celulasVivas.topW:= w;
    nuevaGeneracion.topH:= h;
    nuevaGeneracion.topW:= w;
    generaciones:= 1;
    poblacion:= 0;

  for i:=1 to celulasVivas.topH do begin
    for j:=1 to celulasVivas.topW do begin
      celulasVivas.cells[i,j]:= random(2)=1;
      if celulasVivas.cells[i,j] then poblacion+=1;
    end;
  end;
  end;
end;

function getCelulasVivas(i: RangoFilas; j: RangoColumnas; var l: lifeField ): byte;
var contador : byte;
begin
     contador:=0;
     if sonCoordenadasValidas(i-1,j-1,l) and l.celulasVivas.cells[i-1,j-1] then contador +=1;
     if sonCoordenadasValidas(i-1,j,l) and l.celulasVivas.cells[i-1,j] then contador +=1;
     if sonCoordenadasValidas(i+1,j-1,l) and l.celulasVivas.cells[i+1,j-1] then contador +=1;
     if sonCoordenadasValidas(i,j-1,l) and l.celulasVivas.cells[i,j-1] then contador +=1;
     if sonCoordenadasValidas(i,j+1,l) and l.celulasVivas.cells[i,j+1] then contador +=1;
     if sonCoordenadasValidas(i-1,j+1,l) and l.celulasVivas.cells[i-1,j+1] then contador +=1;
     if sonCoordenadasValidas(i+1,j,l) and l.celulasVivas.cells[i+1,j] then contador +=1;
     if sonCoordenadasValidas(i+1,j+1,l) and l.celulasVivas.cells[i+1,j+1] then contador +=1;

     result:= contador;
end;

procedure nextGeneration(var l: lifeField);
var i,j: integer;
  celulasVivasVerificador: byte;
begin
    with l do begin
      generaciones+=1;
      poblacion:=0;
      for i:=1 to celulasVivas.topH do begin
        for j:=1 to celulasVivas.topW do begin
          if not celulasVivas.cells[i,j] then begin
            nuevaGeneracion.cells[i,j]:= getCelulasVivas(i,j,l)=3;
          end else begin
            celulasVivasVerificador:= getCelulasVivas(i,j,l);
            nuevaGeneracion.cells[i,j]:= (celulasVivasVerificador = 2) or (celulasVivasVerificador = 3);
          end;
          if nuevaGeneracion.cells[i,j] then begin
            poblacion+=1;
          end;
        end;
      end;
    end;

    for i:=1 to l.celulasVivas.topH do begin
      for j:=1 to l.celulasVivas.topW do begin
        l.celulasVivas.cells[i,j] := l.nuevaGeneracion.cells[i,j];
      end;
    end;

end;

function sonCoordenadasValidas(i, j: integer; var l: lifeField): boolean;
begin
     result:= (i>=1) and (i<=l.celulasVivas.topH) and (j>=1) and (j<=l.celulasVivas.topW);
end;

procedure insertarCelula(i, j: integer; var l: lifeField);
begin
     if sonCoordenadasValidas(i,j,l) and not l.celulasVivas.cells[i,j] then begin
       l.celulasVivas.cells[i,j]:= true;
       l.poblacion+=1;
     end;
end;


end.

