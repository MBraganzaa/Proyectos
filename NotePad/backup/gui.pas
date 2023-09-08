unit gui;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, LCLType, notepad;

const
    DEFAULT_APP_TITLE= 'Notepad PAS - Nuevo documento';
    APP_NAME= 'Notepad PAS';

type

  { TmainWindow }

  TmainWindow = class(TForm)
    MainMenu1: TMainMenu;
    HojaDeTexto: TMemo;
    menuArchivo: TMenuItem;
    menuArchivo_abrir: TMenuItem;
    menuArchivo_Nuevo: TMenuItem;
    menuArchivo_guardar: TMenuItem;
    menuArchivo_guardarComo: TMenuItem;
    MenuItem5: TMenuItem;
    menuArchivo_Salir: TMenuItem;
    dialogoAbrir: TOpenDialog;
    dialogoGuardar: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure HojaDeTextoChange(Sender: TObject);
    procedure menuArchivo_abrirClick(Sender: TObject);
    procedure menuArchivo_guardarClick(Sender: TObject);
    procedure menuArchivo_guardarComoClick(Sender: TObject);
    procedure menuArchivo_NuevoClick(Sender: TObject);
    procedure menuArchivo_SalirClick(Sender: TObject);
  private

  public

  end;

var
  mainWindow: TmainWindow;
  mainApp: TNotepad;

  ultimoIntentoGuardarComo_OK: boolean; //Si GuardarComo finalizó bien...

implementation

{$R *.lfm}

{ TmainWindow }

procedure TmainWindow.FormCreate(Sender: TObject);
begin
     inicializar(mainApp);
end;

procedure TmainWindow.HojaDeTextoChange(Sender: TObject);
begin
    cambiosPendientes(true,mainApp);
end;

procedure TmainWindow.menuArchivo_abrirClick(Sender: TObject);
var i, opcion: integer;
    lineaActual: String;
begin
    if cambiosPendientes(mainApp) then begin
        opcion:= Application.MessageBox('Hay cambios sin guardar.'+#13#13+'¿Deseas guardarlos antes de cerrar este archivo?','Guardar cambios',MB_YESNOCANCEL+MB_ICONQUESTION);
        case opcion of
           IDYES: begin
                borrarHoja(mainApp);
                for i:=0 to (HojaDeTexto.Lines.Count-1) do begin
                    agregarLinea(HojaDeTexto.Lines[i],mainApp);
                end;

                if archivoAbierto(mainApp) then begin
                    guardar(mainApp);
                    reiniciar(mainApp);
                    mainWindow.Caption:= DEFAULT_APP_TITLE;
                    HojaDeTexto.Clear;
                end else begin
                    menuArchivo_guardarComo.Click;
                    if ultimoIntentoGuardarComo_OK then begin
                        reiniciar(mainApp);
                        mainWindow.Caption:= DEFAULT_APP_TITLE;
                        HojaDeTexto.Clear;
                    end;
                end;
           end;
           IDCANCEL: begin
               exit;
           end;
        end;
    end;


    if dialogoAbrir.Execute then begin
        HojaDeTexto.Clear;
        cargarArchivo(dialogoAbrir.FileName,mainApp);

        for i:=1 to cantidadLineas(mainApp) do begin
            obtenerLinea(i,lineaActual,mainApp);
            HojaDeTexto.Append(lineaActual);
        end;

        cambiosPendientes(false,mainApp);
        mainWindow.Caption:= APP_NAME+' - '+ExtractFileName(dialogoAbrir.FileName);
    end;
end;

procedure TmainWindow.menuArchivo_guardarClick(Sender: TObject);
var i: integer;
begin
    if not archivoAbierto(mainApp) then begin
        menuArchivo_guardarComo.Click;
    end else if cambiosPendientes(mainApp) then begin
          borrarHoja(mainApp);
          for i:=0 to (HojaDeTexto.Lines.Count-1) do begin
              agregarLinea(HojaDeTexto.Lines[i],mainApp);
          end;
          guardar(mainApp);
    end;
end;

procedure TmainWindow.menuArchivo_guardarComoClick(Sender: TObject);
var opcion, i: integer;
begin
    if dialogoGuardar.Execute then begin
         if FileExists(dialogoGuardar.FileName) then begin
             opcion:= Application.MessageBox('Ya existe un archivo con ese nombre.'+#13#13+'¿Deseas sobrescribirlo?','Sobrescribir archivo',MB_YESNOCANCEL+MB_ICONINFORMATION);
             case opcion of
                IDYES: begin
                    borrarHoja(mainApp);
                    for i:=0 to (HojaDeTexto.Lines.Count-1) do begin
                        agregarLinea(HojaDeTexto.Lines[i],mainApp);
                    end;
                    guardarComo(dialogoGuardar.FileName,mainApp);
                    mainWindow.Caption:= APP_NAME+' - '+ExtractFileName(dialogoGuardar.FileName);
                    ultimoIntentoGuardarComo_OK:= true;
                end;
                IDNO: menuArchivo_guardarComo.Click;
                IDCANCEL: ultimoIntentoGuardarComo_OK:= false;
             end;
         end else begin
              borrarHoja(mainApp);
              for i:=0 to (HojaDeTexto.Lines.Count-1) do begin
                  agregarLinea(HojaDeTexto.Lines[i],mainApp);
              end;
              guardarComo(dialogoGuardar.FileName,mainApp);
              mainWindow.Caption:=  APP_NAME+' - '+ExtractFileName(dialogoGuardar.FileName);
              ultimoIntentoGuardarComo_OK:= true;
          end;
       end else begin
           ultimoIntentoGuardarComo_OK:= false;
       end;
end;

procedure TmainWindow.menuArchivo_NuevoClick(Sender: TObject);
var opcion, i: integer;
begin
    if cambiosPendientes(mainApp) then begin
        opcion:= Application.MessageBox('Hay cambios sin guardar.'+#13#13+'¿Deseas guardarlos antes de cerrar este archivo?','Guardar cambios',MB_YESNOCANCEL+MB_ICONQUESTION);
        case opcion of
           IDYES: begin
                borrarHoja(mainApp);
                for i:=0 to (HojaDeTexto.Lines.Count-1) do begin
                    agregarLinea(HojaDeTexto.Lines[i],mainApp);
                end;

                if archivoAbierto(mainApp) then begin
                    guardar(mainApp);
                    reiniciar(mainApp);
                    mainWindow.Caption:= DEFAULT_APP_TITLE;
                    HojaDeTexto.Clear;
                end else begin
                    menuArchivo_guardarComo.Click;
                    if ultimoIntentoGuardarComo_OK then begin
                        reiniciar(mainApp);
                        mainWindow.Caption:= DEFAULT_APP_TITLE;
                        HojaDeTexto.Clear;
                    end;
                end;
           end;
           IDNO: begin
               mainWindow.Caption:= DEFAULT_APP_TITLE;
               HojaDeTexto.Clear;
               reiniciar(mainApp);
           end;
           IDCANCEL: begin end;
        end;
    end else begin
        reiniciar(mainApp);
        mainWindow.Caption:= DEFAULT_APP_TITLE;
        HojaDeTexto.Clear;
    end;
end;

procedure TmainWindow.menuArchivo_SalirClick(Sender: TObject);
begin
    finalizar(mainApp);
    mainWindow.Close;
end;

end.

