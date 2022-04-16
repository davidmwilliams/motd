program MOTD;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Message of the day';

  try
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  except
  end;
end.
