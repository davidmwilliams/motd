UNIT uMain;

//
// DB - NewsItem, ItemDateTime, ItemAuthor, ItemHeadline, ItemText
//

// ==========================================================================
INTERFACE

USES
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, DB, ADODB, ComCtrls, Dialogs;

TYPE
  TfrmMain = class(TForm)
    cbDontShowAgain: TCheckBox;
    bOK: TButton;
    connWebby: TADOConnection;
    dsLastUpdate: TADODataSet;
    dsLastUpdateLastNewsItem: TDateTimeField;
    dsNewsItems: TADODataSet;
    dsNewsItemsitemdatetime: TDateTimeField;
    dsNewsItemsitemauthor: TStringField;
    dsNewsItemsitemheadline: TStringField;
    dsNewsItemsitemtext: TStringField;
    theNews: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure bOKClick(Sender: TObject);

  private
  public
  end;

VAR
  frmMain: TfrmMain;

// ==========================================================================
IMPLEMENTATION

{$R *.dfm}

USES
  Registry;

// --------------------------------------------------------------------------
procedure TfrmMain.FormCreate(Sender: TObject);

var
  DontDisplay: boolean;
  LastFileDate: TDateTime;
  theReg: TRegistry;
  NewFileDate: TDateTime;

begin
// See if the user has requested MOTD to be supressed until something is new
  theReg := TRegistry.Create;
  theReg.OpenKey ('Software\motd', True);
  try
    DontDisplay := theReg.ReadBool ('DontDisplay')
  except
    DontDisplay := False;
  end;
  try
    LastFileDate := theReg.ReadDateTime ('LastFileDate')
  except
    LastFileDate := 0
  end;

// Check the timestamp of the most recently added item
  NewFileDate := 0;
  try
    connWebby.Connected := True;
    dsLastUpdate.Active := True;
    NewFileDate := dsLastUpdateLastNewsItem.AsDateTime;
    dsLastUpdate.Active := False;
  except
    MessageDlg ('I could not connect to Webby to display "Message of the Day" items.'
      + #13 + 'Please contact I.T.', mtError, [mbOK], 0);
    theReg.Free;
    Application.Terminate
  end;

  if NewFileDate > LastFileDate then
  begin
    theReg.WriteBool ('DontDisplay', False);
    theReg.WriteDateTime ('LastFileDate', NewFileDate);
    theReg.Free;
  end
  else
    if DontDisplay then
    begin
      connWebby.Connected := False;
      theReg.Free;
      Application.Terminate
    end;

// Display the most recent nine items
  dsNewsItems.Active := True;
  while not dsNewsItems.Eof do
  begin
    theNews.Lines.Add ('');

    with theNews.SelAttributes do
    begin
      Style := [fsBold];
      Size := 12;
      Color := clBlue
    end;
    theNews.Lines.Add (dsNewsItemsitemheadline.AsString);

    with theNews.SelAttributes do
    begin
      Style := [fsBold];
      Size := 10;
      Color := clBlack
    end;
    theNews.Lines.Add ('By ' + dsNewsItemsitemauthor.AsString + ' on ' + dsNewsItemsitemdatetime.AsString);

    with theNews.SelAttributes do
    begin
      Style := [];
      Size := 10;
      Color := clBlack
    end;
    theNews.Lines.Add (dsNewsItemsitemtext.AsString);

    theNews.Lines.Add ('');
    dsNewsItems.MoveBy(1)
  end;

  theNews.SelStart := 0;

// Tidy up
  dsNewsItems.Active := False;
  connWebby.Connected := False
end;

// --------------------------------------------------------------------------
procedure TfrmMain.bOKClick(Sender: TObject);
var
  theReg: TRegistry;

begin
  if cbDontShowAgain.Checked then
  begin
    theReg := TRegistry.Create;
    theReg.OpenKey ('Software\motd', True);
    theReg.WriteBool ('DontDisplay', True);
    theReg.Free
  end;

  Close
end;

// ==========================================================================
END.
