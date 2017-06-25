program WUSB;

{$R 'en_EN.res' 'Resources\en_EN.rc'}
{$R 'ru_RU.res' 'Resources\ru_RU.rc'}

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Wake in 'Wake\Wake.pas',
  MyWake in 'Wake\MyWake.pas',
  Messages in 'Language\Messages.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
  {$ENDIF }

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
