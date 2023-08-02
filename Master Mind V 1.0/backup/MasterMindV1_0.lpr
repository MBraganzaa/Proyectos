program MasterMindV1_0;

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
  codAdivinador, codPensador : TCodigo;


begin
  randomize;

  {Con este for creamos el codigo del pensador... sin que se repita}
  for i:=1 to 4 do begin
    letra:= chr(random(ord(ULTIMA_LETRA) - ord(PRIMERA_LETRA)+1) + ord(PRIMERA_LETRA));
    j:=1;

    while (j < i) do begin
    if codPensador[j] = letra then begin
      letra:= chr(random(ord(ULTIMA_LETRA) - ord(PRIMERA_LETRA)+1) + ord(PRIMERA_LETRA));
      j:=1;
    end else begin
      j+=1;
      end;
    end;
    codPensador[i]:= letra;
  end;

  //Mostramos al usuario :
  writeln('Master Mind V1.0 ', codPensador);
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

  {con este for conprobamos si el codigo que ingresa el usuraio es igual al del pensador}
  for j:=1 to 4 do begin

  if codPensador[j] = codAdivinador[j] then begin
    buenas+=1;
    codAdivinador[j]:= '1';
    end;

  for n:=1 to 4 do begin

       if codAdivinador[n] = '1' then begin
        break;
       end else if codAdivinador[n] = codPensador[j] then begin
         regulares+=1;
         codAdivinador[n]:= '2';
       end;
    end;

  end;

  writeln('Buenas: ',buenas,' Regulares: ',regulares);
  end;

  if buenas <> 4 then begin
    writeln;
    writeln('PERDISTE! El codigo era ',codPensador);
  end;

  readln;
end.

