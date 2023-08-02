unit Controlador;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Spin, Menus, theLife;

type

  { TVentana }

  TVentana = class(TForm)
    botonIniciar: TButton;
    botonPausa: TButton;
    etiquetaAncho: TLabel;
    etiquetaLargo: TLabel;
    etiquetaGeneraciones: TLabel;
    etiquetaNumGeneraciones: TLabel;
    etiquetaPoblacion: TLabel;
    etiquetaNumeroPoblacion: TLabel;
    PaintBox1: TPaintBox;
    spinAncho: TSpinEdit;
    spinLargo: TSpinEdit;
    ejecucion: TTimer;
    procedure botonIniciarClick(Sender: TObject);
    procedure botonPausaClick(Sender: TObject);
    procedure ejecucionTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PaintBox1Click(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    life: lifeField;
    blockHeight, blockWidth: integer;
    mouseX, mouseY: integer;
    inited: boolean;
  public
    procedure pintarTablero();

  end;

var
  Ventana: TVentana;

implementation

{$R *.lfm}

{ TVentana }

procedure TVentana.FormCreate(Sender: TObject);
var i, j: byte;
begin
     DoubleBuffered:= true;
     PaintBox1.Enabled:= false;
     botonPausa.caption:= 'Pausar';
     botonPausa.Enabled:= false;
end;

procedure TVentana.FormResize(Sender: TObject);
begin
  PaintBox1.Height:= self.Height;
  PaintBox1.Width:= self.Width;
  if life.celulasVivas.topH<>0 then begin
      blockHeight:= self.Height div life.celulasVivas.topH;
      blockWidth:= self.Width div life.celulasVivas.topW;
  end;
end;

procedure TVentana.PaintBox1Click(Sender: TObject);
var i, j: integer;
    auxImod, auxJmod, auxIdiv, auxJdiv: integer;
begin
    auxImod:= mouseY MOD blockHeight;
    auxJmod:= mouseX MOD blockWidth;
    auxIdiv:= mouseY DIV blockHeight;
    auxJdiv:= mouseX DIV blockWidth;

    if auxImod>0 then
       i:= auxidiv + 1
    else
       i:= auxidiv;

    if auxJmod>0 then
       j:= auxjdiv + 1
    else
       j:= auxjdiv;

    insertarCelula(i,j,life);
    pintarTablero();
end;

procedure TVentana.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     mouseX:= X;
     mouseY:= y;
end;

procedure TVentana.pintarTablero();
var xCoord, yCoord: integer;
    i, j: integer;
begin
     with PaintBox1.Canvas do begin
        Brush.Style:= bsSolid;
        Brush.Color:= clBlack;

        xCoord:= 0;
        yCoord:= 0;
        for i:= 1 to life.celulasVivas.topH do begin
           for j:=1 to life.celulasVivas.topW do begin
               if life.celulasVivas.cells[i][j] then
                  Brush.Color:= clBlack
               else
                  Brush.Color:= clWhite;

               FillRect(xCoord,yCoord,blockWidth+xCoord,blockHeight+yCoord);
               xCoord+= blockWidth;
           end;
           yCoord+= blockHeight;
           xCoord:=0;
        end;
    end;
    etiquetaNumGeneraciones.Caption:= inttostr(life.generaciones);
    etiquetaNumeroPoblacion.Caption:= inttostr(life.poblacion);
end;

procedure TVentana.botonIniciarClick(Sender: TObject);
begin
     init(spinAncho.Value,spinLargo.value,life);
     inited:= true;
     blockHeight:= self.Height div life.celulasVivas.topH;
     blockWidth:= self.Width div life.celulasVivas.topW;
     PaintBox1.Enabled:= true;
     botonPausa.Enabled:= true;

     ejecucion.Enabled:= true;
     botonIniciar.Caption:= 'Reiniciar';
end;

procedure TVentana.botonPausaClick(Sender: TObject);
begin
    if inited then begin
        ejecucion.enabled:= not ejecucion.enabled;
        if ejecucion.enabled then botonPausa.caption:= 'Pausar'
        else botonPausa.caption:= 'Continuar';
        pintarTablero();
    end;
end;

procedure TVentana.ejecucionTimer(Sender: TObject);
begin
    pintarTablero;
    nextGeneration(life);
end;

end.

