unit VentanaAcercaDeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ButtonPanel;

type

  { TventanaAcercaDe }

  TventanaAcercaDe = class(TForm)
    ButtonPanel1: TButtonPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Logo: TImage;
  private

  public

  end;

var
  ventanaAcercaDe: TventanaAcercaDe;

implementation

{$R *.lfm}

{ TventanaAcercaDe }

end.

