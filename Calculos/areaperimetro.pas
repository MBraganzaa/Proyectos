unit AreaPerimetro;

interface
type
  TFigura= (RECTANGULO, TRIANGULO, CIRCULO);

function calcularArea(f:TFigura; valor1,valor2 : real):real;

function calcularPerimetro(f:TFigura; valor1,valor2,valor3: real): real;

implementation
function calcularArea(f:TFigura; valor1,valor2 : real):real;
begin
  case f of
       RECTANGULO: result:= valor1*valor2;
       TRIANGULO: result:= valor1*valor2/2;
       CIRCULO: result:= valor1*valor1*3.14;
  end;
end;

function calcularPerimetro(f:TFigura; valor1,valor2,valor3: real): real;
begin
   case f of
        RECTANGULO: result:= valor1*2+valor2*2;
        TRIANGULO: result:= valor1+valor2+valor3;
        CIRCULO: result:= valor1*2*pi;
   end;
end;
end.

