program StopEnemy;

uses
  Vcl.Forms,
  Unit1 in 'C:\Users\DarkSlayer\Downloads\Projects\Projects\Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
