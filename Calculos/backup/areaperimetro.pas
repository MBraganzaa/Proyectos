unit AreaPerimetro;

interface
type
  TFigura= (RECTANGULO, TRIANGULO, CIRCULO);

function AreaPerimetro1(f:TFigura; valor1,valor2 : real):real;

implementation
function AreaPerimetro1(f:TFigura; valor1,valor2 : real):real;
begin
  case f of
       RECTANGULO: result:= valor1*valor2;
       TRIANGULO: result:= valor1*valor2/2;
       CIRCULO: result:= valor1*valor1*3.14;
  end;

end;

end.

