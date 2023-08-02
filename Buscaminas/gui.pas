unit GUI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, StdCtrls, gameEngine;

const
    COLOR1= clBlue;
    COLOR2= clGreen;
    COLOR3= clRed;
    COLOR4= clNavy;
    COLOR5= clMaroon;
    COLOR6= clSkyBlue;
    COLOR7= clBlack;
    COLOR8= clFuchsia;
    CELDA_ANCHO= 25;
    CELDA_LARGO= 25;

type

  { TCeldaVisual }

  TCeldaVisual= class(TButton)
    private
        posicionCelda: TipoPosicion;
    public
        constructor Crear(p: TipoPosicion; AOwner: TComponent);
        destructor Destroy; override;
        property Fila: RangoFila read posicionCelda.fila;
        property Columna: RangoColumna read posicionCelda.columna;
        property Posicion: TipoPosicion read posicionCelda;
  end;

  { TventanaPrincipal }

  TventanaPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    menuAcciones: TMenuItem;
    menuAcciones_marcarSegura: TMenuItem;
    MenuItem1: TMenuItem;
    menuOpciones_modoDebug: TMenuItem;
    menuJuego_Nuevo: TMenuItem;
    MenuItem2: TMenuItem;
    menuJuego_Salir: TMenuItem;
    menuJuego: TMenuItem;
    barraEstado: TStatusBar;
    //procedure aboutMenu_KABuscaminasClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menuAcciones_marcarSeguraClick(Sender: TObject);
    procedure menuJuego_NuevoClick(Sender: TObject);
    procedure menuJuego_SalirClick(Sender: TObject);
    procedure accionCelda(Sender: TObject);
    procedure menuOpciones_modoDebugClick(Sender: TObject);
    procedure rightClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    vistaTablero: array[RangoFila,RangoColumna] of TCeldaVisual;
    game: TipoJuego;
  public
    procedure actualizar();
    procedure init(f: RangoFila; c: RangoColumna; m: integer);
  end;

var
  ventanaPrincipal: TventanaPrincipal;

implementation
uses nuevoJuegoUnit;

{$R *.lfm}

{ TCeldaVisual }

constructor TCeldaVisual.Crear(p: TipoPosicion; AOwner: TComponent);
begin
  inherited Create(AOwner);
  self.posicionCelda:= p;
end;

destructor TCeldaVisual.Destroy;
begin
     inherited Destroy;
end;

{ TventanaPrincipal }

procedure TventanaPrincipal.menuJuego_SalirClick(Sender: TObject);
begin
  Close;
end;

procedure TventanaPrincipal.accionCelda(Sender: TObject);
begin
  if game.estado<>JUGANDO then begin
      ShowMessage('El juego ha terminado: inicia un nuevo juego');
  end else
    if (Sender is TCeldaVisual ) then begin
      Descubrir(game,TCeldaVisual(sender).Posicion);
      actualizar;
  end;
end;

procedure TventanaPrincipal.menuOpciones_modoDebugClick(Sender: TObject);
begin
  menuOpciones_modoDebug.Checked:= not menuOpciones_modoDebug.Checked;
  actualizar();
end;

procedure TventanaPrincipal.rightClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if game.estado<>JUGANDO then begin
      ShowMessage('El juego ha terminado: inicia un nuevo juego.');
  end else
  if (Sender is TCeldaVisual ) and (Button=TMouseButton.mbRight) then begin
      case game.tablero.celdas[TCeldaVisual(sender).Fila,TCeldaVisual(sender).Columna].estado of
          OCULTA: marcar(game,TCeldaVisual(sender).Posicion);
          MARCADA: DesMarcar(game,TCeldaVisual(sender).Posicion);
      end;
  end else if (Sender is TCeldaVisual) and (Button=TMouseButton.mbMiddle) then begin
      MarcarCircundantes(game,TCeldaVisual(sender).Posicion);
  end;

  actualizar;
end;

procedure TventanaPrincipal.actualizar();
var i: RangoFila; j: RangoColumna;
begin
   for i:=1 to game.tablero.topeFila do begin
     for j:=1 to game.tablero.topeColumna do begin
       if not menuOpciones_modoDebug.Checked then begin
         case game.tablero.celdas[i,j].estado of
             OCULTA     : TButton(vistaTablero[i,j]).Caption:='';
             MARCADA    : begin
               TButton(vistaTablero[i,j]).Font.Color:= clRed;
               TButton(vistaTablero[i,j]).Caption:= '!';
             end;
             DESCUBIERTA: begin
               if game.tablero.celdas[i,j].tieneBomba then begin
                 TButton(vistaTablero[i,j]).Caption:= '*';

               end else begin
                 if game.tablero.celdas[i,j].bombasCircundantes=0 then begin
                     TButton(vistaTablero[i,j]).Caption:= '.';
                     TButton(vistaTablero[i,j]).Enabled:= false;
                 end else begin
                     TButton(vistaTablero[i,j]).Caption:= inttostr(game.tablero.celdas[i,j].bombasCircundantes);
                     TButton(vistaTablero[i,j]).Enabled:= true;
                 end;
               end;
             end;
         end;
       end//Fin MODO NORMAL
       else begin
           if game.tablero.celdas[i,j].tieneBomba then begin
                 TButton(vistaTablero[i,j]).Caption:= 'B';
           end else if game.tablero.celdas[i,j].bombasCircundantes=0 then begin
                 TButton(vistaTablero[i,j]).Caption:= '#';
           end else begin
                 TButton(vistaTablero[i,j]).Caption:= inttostr(game.tablero.celdas[i,j].bombasCircundantes);
           end;

           case game.tablero.celdas[i,j].estado of
               MARCADA:TButton(vistaTablero[i,j]).Caption:= TButton(vistaTablero[i,j]).Caption+'!';
               DESCUBIERTA: TButton(vistaTablero[i,j]).Enabled:= false;
           end;
       end;
     end;
   end;
   case game.estado of
      GANADO: begin
        ShowMessage('¡¡¡GANASTE!!!');
        barraEstado.SimpleText:= 'FELICITACIONES ¡¡¡GANASTE!!!';
      end;
      PERDIDO: begin
        ShowMessage('Lamentablemente has perdido');
        barraEstado.SimpleText:= 'LAMENTABLEMENTE PERDISTE';
      end;
      JUGANDO: begin
        barraEstado.SimpleText:= IntToStr(game.bombas)+' minas | '+inttostr(game.marcadas)+'!'+' | '+inttostr(game.descubiertas)+' descubiertas';
      end;
    end;
end;

procedure TventanaPrincipal.init(f: RangoFila; c: RangoColumna; m: integer);
var i: RangoFila; j: RangoColumna;
    p: TipoPosicion;
    celda: TCeldaVisual;
begin
     if (m>f*c) then m:= f*c;

     for i:=1 to game.tablero.topeFila do begin
       for j:=1 to game.tablero.topeColumna do begin
            if vistaTablero[i,j]<>NIL then
                vistaTablero[i,j].Free;
       end;
     end;

     IniciarJuego(game,f,c,m);

     for i:=1 to f do begin
       for j:=1 to c do begin
         p.fila:= i;
         p.columna:= j;
         celda:= TCeldaVisual.Crear(p,self);
         TButton(celda).Parent:= self;
         TButton(celda).Height:= CELDA_ANCHO;
         TButton(celda).Width:= CELDA_LARGO;
         TButton(celda).Left:= (j-1)*CELDA_LARGO;
         TButton(celda).Top:= (i-1)*CELDA_ANCHO;
         TButton(celda).OnClick:= @accionCelda;
         TButton(celda).OnMouseDown:= @rightClick;
         TButton(celda).Font.Style:= [TFontStyle.fsBold];
         vistaTablero[i,j]:= celda;
       end;
     end;
     self.Height:= CELDA_ANCHO*f+barraEstado.Height*2;
     self.Width:= CELDA_LARGO*c;
     barraEstado.SimpleText:= IntToStr(game.bombas)+' minas | '+inttostr(game.marcadas)+'!'+' | '+inttostr(game.descubiertas)+' descubiertas';
end;

procedure TventanaPrincipal.menuJuego_NuevoClick(Sender: TObject);
begin
  Application.CreateForm(TventanaJuegoNuevo,ventanaJuegoNuevo);
  if ventanaJuegoNuevo.ShowModal=mrOK then begin
      init(ventanaJuegoNuevo.spinAncho.Value,ventanaJuegoNuevo.spinLargo.Value,ventanaJuegoNuevo.spinCantidadMinas.Value);
      actualizar();
  end;
  FreeAndNil(ventanaJuegoNuevo);
end;

procedure TventanaPrincipal.FormCreate(Sender: TObject);
begin
    init(ANCHO_FACIL,LARGO_FACIL,MINAS_FACIL);
end;

procedure TventanaPrincipal.menuAcciones_marcarSeguraClick(Sender: TObject);
begin
  if game.estado=JUGANDO then begin
    DescubrirSegura(game);
    actualizar;
  end;
end;


end.

