program MasterMindV4_0;

uses motor, crt;

const
     {Constantes para controlar el teclado.}
     TECLA_ESC= #27;
     //Comandos teclas especiales.
     TECLA_ESPECIAL_PRESIONADA= #0; //Al presionar una tecla especial primero se lanza este caracter.
     TECLA_UNO= '1';
     TECLA_DOS= '2';
     TECLA_CERO= '0';

var
  juego: TPartida;
  key: char;

procedure pantallaAdivinador;
var mensaje: string;
    i, maxFOR: byte;
    codeCoordX, codeCoordY: byte;
    inX, inY: byte;
    histX, histY: byte;
    msjX, msjY: byte;
    finalX, finalY: byte;

    buenos, regulares: byte;
begin
     codeCoordY:= 8;
     codeCoordX:= 35;
     inX:= 35;
     inY:= 9;
     histX:= 8;
     histY:= 13;
     msjX:=2;
     msjY:=11;
     mensaje:= 'Escribe tu codigo y presiona ENTER.';

     iniciarJuego(TModoJuego.ADIVINADOR,juego);
     generarCodigo(juego.pensador);

     repeat
        clrscr;
        GoToXY(1,1);
        TextBackground(black);
        TextColor(yellow);
        writeln('******************************************************************************');
        writeln('                          MasterMind V4.0 - KA EduSoft                        ');
        writeln('******************************************************************************');
        writeln('|----------------------------- MODO ADIVINADOR ------------------------------|');
        writeln('                                                                              ');
        TextColor(white);
        write  ('Tienes un total de '); TextColor(yellow); write(MAX_INTENTOS-juego.intentoActual); textColor(white); write(' intentos para adivinar. Escribe ahora tu codigo:');
        TextColor(white); writeln; writeln;
        write  ('                    Ultimo codigo');
        textColor(LightGreen);
        GoToXY(codeCoordX,codeCoordY);
        if esHistoriaVacia(juego.historial) then begin
            write('####');
            textColor(yellow); write(' ---> B #  R #');
        end else begin
            imprimirCodigo(juego.historial.info[juego.historial.tope].codigo);
            textColor(yellow); write(' ---> B ');
            textColor(LightCyan); write(juego.historial.info[juego.historial.tope].buenos,'  ');
            textColor(yellow); write('R ');
            textColor(LightCyan); write(juego.historial.info[juego.historial.tope].regulares);
        end;
        GoToXY(inX,inY); TextBackground(LightGray); write('                  ');
        TextBackground(black);
        writeln;
        writeln;
        textBackground(blue);
        writeln('                                                                              ');
        textcolor(white);
        gotoXY(msjX,msjY); writeln(mensaje);
        textColor(LightCyan);
        writeln('******************************* HISTORIAL ************************************');
        writeln('                                                                              ');
        writeln('                                                                              ');
        writeln('                                                                              ');
        writeln('                                                                              ');
        writeln('                                                                              ');
        writeln('                                                                              ');

        GoToXY(histX,histY);
        if not esHistoriaVacia(juego.historial) then begin
            if juego.historial.tope<=5 then
               maxFOR:= juego.historial.tope
            else maxFOR:=5;

            for i:= 1 to maxFOR do begin
               if juego.historial.tope>= i then begin
                  imprimirCodigo(juego.historial.info[i].codigo);
                  write(' B= ',juego.historial.info[i].buenos,'  R= ',juego.historial.info[i].regulares);
                  GoToXY(histX,histY+i);
               end;
            end;

            GoToXY(histX+50,histY);
            for i:= 6 to juego.historial.tope do begin
                if juego.historial.tope>= i then begin
                  imprimirCodigo(juego.historial.info[i].codigo);
                  write(' B= ',juego.historial.info[i].buenos,'  R= ',juego.historial.info[i].regulares);
                  GoToXY(histX+50,histY+i-5);
               end;
            end;
        end;

        GoToXY(inX+7,inY); TextBackground(LightGray); TextColor(black);
        cursorOn;

        while not leerCodigo(juego.adivinador,mensaje) do begin
            textBackground(blue);
            textcolor(white);
            gotoXY(msjX,msjY); writeln(mensaje);
            GoToXY(inX,inY); TextBackground(LightGray); write('                  ');
            GoToXY(inX+7,inY); TextBackground(LightGray); TextColor(black);
        end;

        mensaje:= 'Escribe tu codigo y presiona ENTER';
        calcularNota(juego.adivinador,juego.pensador,buenos,regulares);
        presentarCodigo(juego.adivinador,buenos,regulares,juego);

        TextBackground(black);

     until juego.estado<>TEstadoJuego.INICIADO;

     finalX:=(80-17)DIV 2;
     finalY:= (24-3)DIV 2;
     GoToXY(finalX,finalY);
     TextColor(white);
     if juego.estado=GANO then begin
         TextBackGround(green);
         write('*****************');
         gotoxy(finalX,finalY+1);
         write('|  GANASTE!!!   |');
         gotoxy(finalX,finaly+2);
         write('*****************');
     end else if juego.estado=PERDIO then begin
         TextBackGround(red);
         write('*****************');
         gotoxy(finalX,finalY+1);
         write('|   PERDISTE!!! |');
         gotoxy(finalX,finaly+2);
         write('*****************');
         GOTOXY(finalX,finaly+3);
         write('El codigo: ');
         imprimirCodigo(juego.pensador);
         write('  ');
     end;
     gotoxy(finalX,finaly+4);
     write('Continuar (INTRO)');
     readln;
     TextBackground(black);
end;

procedure pantallaPensador;
var mensaje: string;
    i, maxFOR: byte;
    codeCoordX, codeCoordY: byte;
    inX, inY: byte;
    histX, histY: byte;
    msjX, msjY: byte;
    finalX, finalY: byte;
    firstCode: TCodigo;
    firstAgain: boolean;

    buenos, regulares: byte;
begin
     codeCoordY:= 8;
     codeCoordX:= 35;
     inX:= 40;
     inY:= 8;
     histX:= 8;
     histY:= 13;
     msjX:=2;
     msjY:=11;
     mensaje:= 'Escribe las notas y presiona ENTER.';

     iniciarJuego(TModoJuego.PENSADOR,juego);
     generarCodigo(juego.adivinador);
     firstCode:= juego.adivinador;
     firstAgain:= false;

     repeat
        while not esAdecuado(juego.adivinador,juego.historial) and not firstAgain do begin
            siguienteCodigo(juego.adivinador);
            firstAgain:= firstCode=juego.adivinador;
        end;

        clrscr;
        GoToXY(1,1);
        TextBackground(black);
        TextColor(yellow);
        writeln('******************************************************************************');
        writeln('                          MasterMind V4.0 - KA EduSoft                        ');
        writeln('******************************************************************************');
        writeln('|------------------------------ MODO PENSADOR -------------------------------|');
        writeln('                                                                              ');
        TextColor(white);
        write  ('Queda un total '); TextColor(yellow); write(MAX_INTENTOS-juego.intentoActual); textColor(white); write(' intentos para adivinar. Escribe las notas [B R]:');
        TextColor(white); writeln; writeln;
        write  (' Creo que se trata del codigo... ');
        textColor(LightGreen);
        GoToXY(codeCoordX,codeCoordY);
        imprimirCodigo(juego.adivinador);

        GoToXY(inX,inY); TextBackground(LightGray); write('     ');
        TextBackground(black);
        writeln;
        writeln;
        textBackground(blue);
        writeln('                                                                              ');
        textcolor(white);
        gotoXY(msjX,msjY); writeln(mensaje);
        textColor(LightCyan);
        writeln('******************************* HISTORIAL ************************************');
        writeln('                                                                              ');
        writeln('                                                                              ');
        writeln('                                                                              ');
        writeln('                                                                              ');
        writeln('                                                                              ');
        writeln('                                                                              ');

        GoToXY(histX,histY);
        if not esHistoriaVacia(juego.historial) then begin
            if juego.historial.tope<=5 then
               maxFOR:= juego.historial.tope
            else maxFOR:=5;

            for i:= 1 to maxFOR do begin
               if juego.historial.tope>= i then begin
                  imprimirCodigo(juego.historial.info[i].codigo);
                  write(' B= ',juego.historial.info[i].buenos,'  R= ',juego.historial.info[i].regulares);
                  GoToXY(histX,histY+i);
               end;
            end;

            GoToXY(histX+50,histY);
            for i:= 6 to juego.historial.tope do begin
                if juego.historial.tope>= i then begin
                  imprimirCodigo(juego.historial.info[i].codigo);
                  write(' B= ',juego.historial.info[i].buenos,'  R= ',juego.historial.info[i].regulares);
                  GoToXY(histX+50,histY+i-5);
               end;
            end;
        end;

        GoToXY(inX+1,inY); TextBackground(LightGray); TextColor(black);
        cursorOn;

        while not leerNotas(buenos,regulares,mensaje) do begin
            textBackground(blue);
            textcolor(white);
            gotoXY(msjX,msjY); writeln(mensaje);
            GoToXY(inX,inY); TextBackground(LightGray); write('                  ');
            GoToXY(inX+7,inY); TextBackground(LightGray); TextColor(black);
        end;

        mensaje:= 'Escribe tus notas y presiona ENTER';
        presentarCodigo(juego.adivinador,buenos,regulares,juego);

        TextBackground(black);

     until juego.estado<>TEstadoJuego.INICIADO;

     finalX:=(80-17)DIV 2;
     finalY:= (24-3)DIV 2;
     GoToXY(finalX,finalY);
     TextColor(white);
     if juego.estado=GANO then begin
         TextBackGround(red);
         write('*****************');
         gotoxy(finalX,finalY+1);
         write('TE HE VENCIDO!!!|');
         gotoxy(finalX,finaly+2);
         write('*****************');
     end else if juego.estado=PERDIO then begin
         TextBackGround(green);
         write('*****************');
         gotoxy(finalX,finalY+1);
         write('|ME HAS VENCIDO!!');
         gotoxy(finalX,finaly+2);
         write('*****************');
     end else begin
         TextBackGround(yellow);
         textColor(black);
         write('*****************');
         gotoxy(finalX,finalY+1);
         write(' HACES TRAMPA!!! ');
         gotoxy(finalX,finaly+2);
         write('*****************');
         GOTOXY(finalX,finaly+3);
         write('El codigo: ');
         imprimirCodigo(juego.pensador);
         write('  ');
     end;
     gotoxy(finalX,finaly+4);
     write('Continuar (INTRO)');
     readln;
     TextBackground(black);
end;

procedure dibujarMenu;
begin
    repeat
        cursoroff;
        clrscr;
        GoToXY(1,1);
        TextBackground(black);
        TextColor(yellow);
        writeln('******************************************************************************');
        writeln('                          MasterMind V4.0 - KA EduSoft                        ');
        writeln('******************************************************************************');
        writeln;
        TextColor(white);
        writeln('                     ***  Selecciona el modo de juego ***                     ');
        writeln;
        writeln('                                1 - ADIVINADOR                                ');
        writeln('                                2 - PENSADOR                                  ');
        writeln('                                0 - SALIR (ESC)                               ');
        writeln;
        writeln;
        TextBackground(Green);
        TextColor(White);
        Writeln('                                                                              ');
        writeln('     www.kaedusoft.edu.uy - Vladimir Rodriguez - GPL-GNU Licence - 2018       ');
        writeln('                                                                              ');
        TextBackground(black);
        key:= readkey;
        if key=TECLA_ESPECIAL_PRESIONADA then key:= readkey;

        case key of
           TECLA_UNO: pantallaAdivinador;
           TECLA_DOS: pantallaPensador;
        end;

    until (key=TECLA_ESC) or (key=TECLA_CERO);
end;



begin
    dibujarMenu;
end.

