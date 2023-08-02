program masterMindV2_0;

// Manuel Braganza.

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

var
  i, j, n, buenas, regulares : integer;
  Letra : char;
  codAdivinador, codPensador, codExtra : TCodigo;

begin
  randomize;


  {Con este for creamos el codigo del pensador... sin que se repita}
  for i:=1 to 4 do begin
    letra:= chr(random(ord(ULTIMA_LETRA) - ord(PRIMERA_LETRA)+1) + ord(PRIMERA_LETRA));
    codPensador[i]:= letra;
    codExtra[i]:= letra;
  end;

  //Mostramos al usuario :
  writeln('Master Mind V1.0 ');
  writeln('Dispones de ',MAX_INTENTOS,' para adivinar el codigo');

  for i:=1 to MAX_INTENTOS do begin
  //En caso de que adivine se muestra al usuario :
  if buenas = 4 then begin
     writeln;
     writeln('FELICIDADES! ACERTASTE EL CODIGO.');
     break;
  //En caso de que no...
  end else begin
      writeln;
      write('Codigo ',i,' de ',MAX_INTENTOS,' >> ');
      readln(codAdivinador);
  end;

  //Declaramos variables.
  buenas:=0;
  regulares:=0;
  codPensador:= codExtra;

  {con este for conprobamos si el codigo que ingresa el usuraio es igual al del pensador}
  for j:=1 to 4 do begin
  if codAdivinador[j] = codPensador[j] then begin
    buenas+=1;
    codAdivinador[j]:= '1';
    codPensador[j]:= '1';
    end;
  end;

  {con este for comprobamos si el codigo que ingresa el usuario hay un regular}
  for j:=1 to 4 do begin
  for n:=1 to 4 do begin
    if codPensador[n] = codAdivinador[j] then begin
      if codPensador[n] = '1' then begin
        // vuelve al for "n"
      end else if codPensador[n] = '2' then begin
        // vuelve al for "n"
      end else begin
         regulares+=1;
         codAdivinador[j]:= '2';
         codPensador[n]:= '2';
         end;
       end;
    end;
  end;

  writeln('Buenas: ',buenas,' Regulares: ',regulares);
  end;

  if buenas <> 4 then begin
    writeln;
    writeln('PERDISTE! El codigo era ',codExtra);
  end;

  readln;
end.
