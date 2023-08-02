unit nuevoJuegoUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ButtonPanel;

type

  { TventanaJuegoNuevo }

  TventanaJuegoNuevo = class(TForm)
    botonFacil: TButton;
    botonMedio: TButton;
    botonDificil: TButton;
    ButtonPanel1: TButtonPanel;
    etiquetaLargo: TLabel;
    etiquetaAncho: TLabel;
    Label1: TLabel;
    spinAncho: TSpinEdit;
    spinCantidadMinas: TSpinEdit;
    spinLargo: TSpinEdit;
    procedure botonDificilClick(Sender: TObject);
    procedure botonFacilClick(Sender: TObject);
    procedure botonMedioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  ventanaJuegoNuevo: TventanaJuegoNuevo;

implementation
uses gameEngine;

{$R *.lfm}

{ TventanaJuegoNuevo }

procedure TventanaJuegoNuevo.FormCreate(Sender: TObject);
begin

end;

procedure TventanaJuegoNuevo.botonFacilClick(Sender: TObject);
begin
  spinAncho.Value:= ANCHO_FACIL;
  spinLargo.Value:= LARGO_FACIL;
  spinCantidadMinas.Value:= MINAS_FACIL;
end;

procedure TventanaJuegoNuevo.botonDificilClick(Sender: TObject);
begin
  spinAncho.Value:= ANCHO_DIFICIL;
  spinLargo.Value:= LARGO_DIFICIL;
  spinCantidadMinas.Value:= MINAS_DIFICIL;
end;

procedure TventanaJuegoNuevo.botonMedioClick(Sender: TObject);
begin
  spinAncho.Value:= ANCHO_MEDIO;
  spinLargo.Value:= LARGO_MEDIO;
  spinCantidadMinas.Value:= MINAS_MEDIO
end;

end.

