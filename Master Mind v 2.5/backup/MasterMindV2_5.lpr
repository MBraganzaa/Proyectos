program MasterMindV2_5;

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
  i, buenas, regulares : byte;
  codAdivinador, codPensador, codExtra : TCodigo;

  {Genera un código al azar y lo asigna a la variable codigo. El codigo
  generado puede contener letras repetidas.}
  procedure generarCodigo(var codigo, codEx: TCodigo);
  var letra : char;
  begin
       randomize;
       for i:=1 to 4 do begin
          letra:= chr(random(ord(ULTIMA_LETRA) - ord(PRIMERA_LETRA)+1) + ord(PRIMERA_LETRA));
          codigo[i]:= letra;
          codEx[i]:= letra;
       end; // fin del for
  end;      //fin del begin generarCodigo.


  {Lee el codigo de la entrada estandar y lo asigna a la variable codigo.
  Ademas retorna el valor TRUE si el codigo leido es correcto, FALSE sino.
  El codigo leido puede ser incorrecto si:
   * Contiene uno o mas caracteres fuera del rango.
   * No contiene el largo LARGO_CODIGO.}
  function leerCodigo(var codigo: TCodigo): boolean;
  var
      codigoE : string;
      i ,n: byte;
      c : char;
  begin
       n:=0;
       readln(codigoE);
       for c in codigoE do begin
          n+=1;
       end;

       if n <> 4 then begin
         result:= false;
         exit;
       end else begin
          for i:=1 to 4 do begin
          codigo[i]:= codigoE[i];
          end;
          for i:=1 to 4 do begin
             if (ord(codigo[i])<65) or (ord(codigo[i])>72) then begin
                result:= false;
                exit;
             end;
          end;
       result:= true;
       end;
  end;



  {Imprime el codigo pasado como argumento en la salida estandar. Deja el
  cursor al final de esa misma línea.}
  procedure imprimirCodigo(var codigo: TCodigo);
  begin
       while not leerCodigo(codigo) do
       write('ERROR: El codigo no es valido. Ingresa otro con 4 letras entre A y H>> ');

  end;


  {Calcula las notas de codAdivinador en función de codPensador. Asigna
  los buenos y los regulares a los argumentos con el mismo nombre.}
  procedure calcularNota(codAdivinador, codPensador, codExtra: TCodigo; var buenos,
  regulares: byte);
  var j, i, n : byte;

  begin

  //Declaramos variables.
  buenos:=0;
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


begin // begin principal.
  {generamos el codPensador}
  generarCodigo(codPensador,codExtra);

  //Mostramos al usuario :
  writeln('Master Mind V1.0 ');
  writeln('Dispones de ',MAX_INTENTOS,' para adivinar el codigo');
  writeln;
  for i:= 1 to MAX_INTENTOS do begin
     write('Codigo ',i,' de ',MAX_INTENTOS,' >> ');
     imprimirCodigo(codAdivinador);
     calcularNota(codAdivinador,codPensador,codExtra,buenas,regulares);

     if buenas = 4 then begin
     writeln;
     writeln('FELICIDADES! ACERTASTE EL CODIGO.');
     readln;
     EXIT;
     end;
     writeln;
  end;

  if buenas <> 4 then begin
    writeln;
    writeln('PERDISTE! El codigo era ',codExtra);
  end;
  readln;

end.
