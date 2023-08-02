program calculos;

uses AreaPerimetro;
var
  v1,v2, v3:real;
  c: char;
  figura: TFigura;
begin
  write('[C] Circulo [R] Rectangulo [T] Triangulo >> ');
  readln(c);
  while (c<>'C') and (c<>'R') and (c<>'T') do begin
    write('ERROR: Escriba C R o T >> ');
    readln(c);
  end;
  case c of
       'T' : begin
         figura:= TFigura.TRIANGULO;
         write('Ingresa la base: ');
         readln(v1);
         write('Ingresa la altura: ');
         readln(v2);
         writeln('El area del triangulo es: ',calcularArea(figura,v1,v2):4:2);
         writeln;
         write('Ingresa un lado del triangulo: ');
         readln(v1);
         write('Ingresa un lado del triangulo: ');
         readln(v2);
         write('Ingresa un lado del triangulo: ');
         readln(v3);
         writeln('El perimetro del triangulo es: ',calcularPerimetro(figura,v1,v2,v3):4:2);

       end;
       'R' : begin
         figura:= TFigura.RECTANGULO;
         write('Ingresa el largo: ');
         readln(v1);
         write('Ingresa el ancho: ');
         readln(v2);
         writeln('El area del rectangulo es: ',calcularArea(figura,v1,v2):4:2);
         writeln('El perimetro del rectangulo es: ',calcularPerimetro(figura,v1,v2,0):4:2);
       end;
       'C' : begin
         figura:=TFigura.CIRCULO;
         write('Ingresa el radio: ');
         readln(v1);
         writeln('El area del circulo es: ',calcularArea(figura,v1,0):4:2);
         writeln('El perimetro del circulo es: ',calcularPerimetro(figura,v1,0,0):4:2);
       end;
  end;
  readln;
end.

