program Truco21;

// Manuel Braganza.

const
     MAX_TARJETAS_GRUPOS = 7;
     MAX_GRUPOS = 3;
     MAX_TARJETAS = MAX_TARJETAS_GRUPOS*MAX_GRUPOS;
     MIN_TARJETA_VALOR = 'A';
     MAX_TARJETA_VALOR = chr(MAX_TARJETAS + ord('A')-1);
type
     tarjetas = MIN_TARJETA_VALOR..MAX_TARJETA_VALOR; //Del primer valor hasta el ultimo valor;
     grupo = array[1..MAX_TARJETAS_GRUPOS] of tarjetas;
     mazo = array[1..MAX_TARJETAS] of tarjetas;
var
  i, j, indice : integer;
  grupo1, grupo2, grupo3 : grupo;
  deck : mazo;
  letra : char;
  validarLetra : boolean;

begin
  randomize;

  // Mostramos al usuario.
  writeln('Haremos 3 secuencias. Empecemos...');
  writeln('Secuencia 1 :');
  writeln;

  {Con este for logramos declarar todas las tarjetas en la variable deck}
  for i:=1 to 21 do begin

    // declaramos la var 'J';
    j:=1;
    // Optenemos un numero para compararlo con la tabla ASCII;
    indice:= random(ord(MAX_TARJETA_VALOR)- ord(MIN_TARJETA_VALOR)+1)+ord(MIN_TARJETA_VALOR);
    // Convertimos a char;
    letra:= chr(indice);

  {Con este while logramos que no re repitan las letras 'tarjetas'}
    while (j<i) do begin
      // En caso de que deck[j] sea igual a letra se crea una nuevo valor.
      if deck[j] = letra then begin
         indice:= random(ord(MAX_TARJETA_VALOR)- ord(MIN_TARJETA_VALOR)+1)+ord(MIN_TARJETA_VALOR);
         letra:= chr(indice);
         j:=1;
      // En caso de que no...
      end else begin
        j+=1;
      end;              // fin del if;
    end;                // fin del while;

    deck[i]:= letra;
  end;                  // fin del for;

  {Con este conjunto de for agregamos las tarjetas a su respectivo grupo}
  j:=1;
  for i:=1 to 7 do begin
    grupo1[i]:= deck[j];
    j+=1;
    end;                       // fin del for grupo1
  j:=8;
  for i:=1 to 7 do begin
    grupo2[i]:= deck[j];
    j+=1;
    end;                       // fin del for grupo2
  j:=15;
  for i:=1 to 7 do begin
    grupo3[i]:= deck[j];
    j+=1;
    end;                       // fin del for grupo3

  {Con este for mostramos los grupos de tarjetas}
  for i:=1 to 7 do begin
  writeln('           ',grupo1[i],'   ',grupo2[i],'   ',grupo3[i]);
  end;


  {Con este for hacemos el truco de magia...}
  for i:=1 to 3 do begin
  // Declaramos la var 'validarLetra'
  validarLetra:= false;

  // Mostramos al usuario las siguientes instrucciones;
  writeln;
  { Con este repeat validamos si letra es una opcion valida.}
  repeat
  write('En que grupo esta tu tarjeta [1,2,3]: ');
  readln(letra);
  if (i = 1) and (validarLetra = true) then begin
  writeln('secuencia 2:');
  end else if (i = 2) and (validarLetra = true) then begin
  writeln('secuencia 3:');
  end;


  case letra of
  '1' : begin

      { Con este if evitamos que se muestre el tablero en la ultima fase}
      if i = 3 then begin
      break;
      end else begin
      {mostramos el tablero con sus 21 cartas}
      writeln;
      write('           ');
      for j:=1 to 7 do begin

      write(grupo2[j],'   ');
        if j = 3 then begin
        writeln;
        write('           ');
        end else if j = 6 then begin
            writeln;
            write('           ');
           end;
      end;
      for j:=1 to 7 do begin
      write(grupo1[j],'   ');
        if j = 2 then begin
        writeln;
        write('           ');
        end else if j = 5 then begin
            writeln;
            write('           ');
           end;
      end;
      for j:=1 to 7 do begin
      write(grupo3[j],'   ');
        if j = 1 then begin
        writeln;
        write('           ');
        end else if j = 4 then begin
            writeln;
            write('           ');
            end;
        end;
      end;

      {Con este for reescribimos los nuevos grupos como se muestran en pantalla}
      for j:=1 to 7 do begin
      case j of
      1 : begin
       grupo1[j]:= deck[8];
       grupo2[j]:= deck[9];
       grupo3[j]:= deck[10];
      end;
      2 : begin
       grupo1[j]:= deck[11];
       grupo2[j]:= deck[12];
       grupo3[j]:= deck[13];
      end;
      3 : begin
       grupo1[j]:= deck[14];
       grupo2[j]:= deck[1];
       grupo3[j]:= deck[2];
      end;
      4 : begin
       grupo1[j]:= deck[3];
       grupo2[j]:= deck[4];
       grupo3[j]:= deck[5];
      end;
      5 : begin
       grupo1[j]:= deck[6];
       grupo2[j]:= deck[7];
       grupo3[j]:= deck[15];
      end;
      6 : begin
       grupo1[j]:= deck[16];
       grupo2[j]:= deck[17];
       grupo3[j]:= deck[18];
      end;
      7 : begin
       grupo1[j]:= deck[19];
       grupo2[j]:= deck[20];
       grupo3[j]:= deck[21];
          end;
        end;                                 //fin  del case
       end;                                  //fin  del for

      {Con este conjunto de for agregamos las tarjetas a su respectivo grupo}
      j:=1;
      for indice:=1 to 7 do begin
      deck[j]:= grupo1[indice];
      j+=1;
      end;                       // fin del for grupo1
      j:=8;
      for indice:=1 to 7 do begin
      deck[j]:= grupo2[indice];
      j+=1;
      end;                       // fin del for grupo2
      j:=15;
      for indice:=1 to 7 do begin
      deck[j]:= grupo3[indice];
      j+=1;
      end;                       // fin del for grupo3
      writeln;
      // declaramos la var 'validarLetra' a true.
      validarLetra:= true;

  end;                                      //fin  del case opcion '1'


  '2' : begin

      { Con este if evitamos que se muestre el tablero en la ultima fase}
      if i = 3 then begin
      break;
      end else begin
      {mostramos el tablero con sus 21 cartas}
      writeln;
      write('           ');
      for j:=1 to 7 do begin

      write(grupo1[j],'   ');
        if j = 3 then begin
        writeln;
        write('           ');
        end else if j = 6 then begin
            writeln;
            write('           ');
           end;
      end;
      for j:=1 to 7 do begin
      write(grupo2[j],'   ');
        if j = 2 then begin
        writeln;
        write('           ');
        end else if j = 5 then begin
            writeln;
            write('           ');
           end;
      end;
      for j:=1 to 7 do begin
      write(grupo3[j],'   ');
        if j = 1 then begin
        writeln;
        write('           ');
        end else if j = 4 then begin
            writeln;
            write('           ');
           end;
      end;
      end;

      {Con este for reescribimos los nuevos grupos como se muestran en pantalla}
      for j:=1 to 7 do begin
      case j of
      1 : begin
       grupo1[j]:= deck[1];
       grupo2[j]:= deck[2];
       grupo3[j]:= deck[3];
      end;
      2 : begin
       grupo1[j]:= deck[4];
       grupo2[j]:= deck[5];
       grupo3[j]:= deck[6];
      end;
      3 : begin
       grupo1[j]:= deck[7];
       grupo2[j]:= deck[8];
       grupo3[j]:= deck[9];
      end;
      4 : begin
       grupo1[j]:= deck[10];
       grupo2[j]:= deck[11];
       grupo3[j]:= deck[12];
      end;
      5 : begin
       grupo1[j]:= deck[13];
       grupo2[j]:= deck[14];
       grupo3[j]:= deck[15];
      end;
      6 : begin
       grupo1[j]:= deck[16];
       grupo2[j]:= deck[17];
       grupo3[j]:= deck[18];
      end;
      7 : begin
       grupo1[j]:= deck[19];
       grupo2[j]:= deck[20];
       grupo3[j]:= deck[21];
         end;
       end;                                 //fin  del case
      end;                                  //fin  del for

      {Con este conjunto de for agregamos las tarjetas a su respectivo grupo}
      j:=1;
      for indice:=1 to 7 do begin
      deck[j]:= grupo1[indice];
      j+=1;
      end;                       // fin del for grupo1
      j:=8;
      for indice:=1 to 7 do begin
      deck[j]:= grupo2[indice];
      j+=1;
      end;                       // fin del for grupo2
      j:=15;
      for indice:=1 to 7 do begin
      deck[j]:= grupo3[indice];
      j+=1;
      end;                       // fin del for grupo3
      writeln;
      // declaramos la var 'validarLetra' a true.
      validarLetra:= true;

  end;                                      //fin  del case opcion '2'

  '3' : begin

      { Con este if evitamos que se muestre el tablero en la ultima fase}
      if i = 3 then begin
      break;
      end else begin
      {mostramos el tablero con sus 21 cartas}
      writeln;
      write('           ');
      for j:=1 to 7 do begin

      write(grupo2[j],'   ');
        if j = 3 then begin
        writeln;
        write('           ');
        end else if j = 6 then begin
            writeln;
            write('           ');
           end;
      end;
      for j:=1 to 7 do begin
      write(grupo3[j],'   ');
        if j = 2 then begin
        writeln;
        write('           ');
        end else if j = 5 then begin
            writeln;
            write('           ');
           end;
      end;
      for j:=1 to 7 do begin
      write(grupo1[j],'   ');
        if j = 1 then begin
        writeln;
        write('           ');
        end else if j = 4 then begin
            writeln;
            write('           ');
           end;
        end;
      end;

      {Con este for reescribimos los nuevos grupos como se muestran en pantalla}
      for j:=1 to 7 do begin
      case j of
      1 : begin
       grupo1[j]:= deck[8];
       grupo2[j]:= deck[9];
       grupo3[j]:= deck[10];
      end;
      2 : begin
       grupo1[j]:= deck[11];
       grupo2[j]:= deck[12];
       grupo3[j]:= deck[13];
      end;
      3 : begin
       grupo1[j]:= deck[14];
       grupo2[j]:= deck[15];
       grupo3[j]:= deck[16];
      end;
      4 : begin
       grupo1[j]:= deck[17];
       grupo2[j]:= deck[18];
       grupo3[j]:= deck[19];
      end;
      5 : begin
       grupo1[j]:= deck[20];
       grupo2[j]:= deck[21];
       grupo3[j]:= deck[1];
      end;
      6 : begin
       grupo1[j]:= deck[2];
       grupo2[j]:= deck[3];
       grupo3[j]:= deck[4];
      end;
      7 : begin
       grupo1[j]:= deck[5];
       grupo2[j]:= deck[6];
       grupo3[j]:= deck[7];
         end;
       end;                                 //fin  del case
      end;                                  //fin  del for

      {Con este conjunto de for agregamos las tarjetas a su respectivo grupo}
      j:=1;
      for indice:=1 to 7 do begin
      deck[j]:= grupo1[indice];
      j+=1;
      end;                       // fin del for grupo1
      j:=8;
      for indice:=1 to 7 do begin
      deck[j]:= grupo2[indice];
      j+=1;
      end;                       // fin del for grupo2
      j:=15;
      for indice:=1 to 7 do begin
      deck[j]:= grupo3[indice];
      j+=1;
      end;                       // fin del for grupo3
      writeln;
      // declaramos la var 'validarLetra' a true.
      validarLetra:= true;

    end else begin                          //fin  del case opcion '3'
      write('ERROR - Ingrese una opcion valida, ');
    end;                                    //fin  del case else.
   end;                                     //fin  del case principal.
  until validarLetra = true;                //fin  del repeat.
  end;                                      //fin  del for principal.

  // mostramos el resultado al usuario.
  write('Obviamente elegiste la letra ',deck[11]);
  readln;
end.
