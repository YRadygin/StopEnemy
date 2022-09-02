unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.ImageList,
  Vcl.ImgList, Vcl.ExtCtrls, System.IOUtils, System.Types, ShellAPI, ShlObj, pngimage,
  VCLTee.TeCanvas, Vcl.Buttons, Vcl.MPlayer,mmSystem;

type
  TForm1 = class(TForm)
    Image1: TImage;
    ScrollBox1: TScrollBox;
    Label9: TLabel;
    Label10: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Edit4: TEdit;
    Edit3: TEdit;
    R: TEdit;
    G: TEdit;
    B: TEdit;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    Label11: TLabel;
    Edit5: TEdit;
    Stop: TSpeedButton;
    Start: TSpeedButton;
    Timer1: TTimer;
    Label12: TLabel;
    GroupBox3: TGroupBox;
    Label13: TLabel;
    Timer2: TTimer;
    SpeedButton1: TSpeedButton;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
  end;
    function PrintWindow(HWND:HWND;hdcBlt:HDC;nFlags:DWORD):BOOL; stdcall; external 'user32.dll';

var
  Form1: TForm1;
  SystemDyrectory,FileName:string;
  TimeAlarm : integer;

  implementation

{$R *.dfm}
  // ����������� �������
  //����������� ����


function DesktopColor(const x,y: integer): TColor;
var
   c:TCanvas;
begin
   c:= TCanvas.Create;
   c.Handle:= GetWindowDC(GetDesktopWindow);
   result:= GetPixel(c.Handle, x, y);
   c.Free;
end;

  // ������� �����
function KillDir (Dir: AnsiString): boolean;
var
  Sr: TSearchRec;
begin
{$I-}
  if (Dir <> '') and (Dir[length(Dir)] = '\') then
    Delete(Dir, length(dir), 1);
  if FindFirst(Dir + '\*.*', faDirectory + faHidden + faSysFile +
    faReadonly + faArchive, Sr) = 0 then
    repeat
      if (Sr.Name = '.') or (Sr.Name = '..') then
        continue;
      if (Sr.Attr and faDirectory <> faDirectory) then
       begin
       if AnsiLowerCase(ExtractFileExt(sr.Name)) = '.png' then
         begin
          FileSetReadOnly(Dir + '\' + sr.Name, False);
        DeleteFile(Dir + '\' + sr.Name);
        end
       end
    else
         KillDir(Dir + '\' + sr.Name);
    until FindNext(sr) <> 0;
    FindClose(sr);
//  RemoveDir(Dir); // ������ ������ �������
    KillDir := (FileGetAttr(Dir) = -1);
end;

   //��������� ���������� ����� �����

   function GetSpecialPath(CSIDL: word): string;
    var s: string;
    begin
      SetLength(s, MAX_PATH);
      if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
      then s := '';
      result := PChar(s);
    end;

   { �������� ��������� (��� �������� ������� ���������� ������� ������ �������
   c������� � ����� '\Documents\EVE\capture\Screenshots\)  }
   procedure CreateSnapshot ( WindowName : Pchar);
    var
      hSrcWnd:HWND;
      Result: HRESULT;
    begin
      hSrcWnd := FindWindow(nil, WindowName); // ���� ������� ��������� � ���� ������ ����
      SendMessage(hSrcWnd,WM_KEYDOWN,Ord(44) ,1); //���������� ������� ���������� � ���� �������� �������
    end;


{ �������� ������� ������ � ��������� ��������� �������, ������������ � ����
 ������ - ��� = ���� ������� ����� ������, �� ���� � �������� ������������
 ������� ��������� �������� ������������ � ������� ��������� �����
 }
  procedure stop_enemy(TestStart:boolean);


   var
    W,H,i,j: Integer;
    bmp, bmp2: TBitmap;
    tsr : tsearchrec;
    png: TPNGObject;
    label
    stop;

  begin

    CreateSnapshot(Pchar(form1.ComboBox1.Text));   //��������� ���� ���������
    sleep(2000); //����� �� ���������� �����
    bmp :=  TBitmap.Create;
    bmp2  :=  TBitmap.Create;
    png := TPNGObject.Create;
    SystemDyrectory := GetSpecialPath(CSIDL_PROFILE); //�������� ��������� ����������  CSIDL_PROFILE - ����� ������������
    //���� � �������� ��� ���������� ����� �� ����� png(��� ������ ������)
    if FindFirst(SystemDyrectory +'\Documents\EVE\capture\Screenshots\' + '*.png',faAnyFile,tsr) = 0 then FileName:= tsr.Name;
    png.loadfromfile(SystemDyrectory+'\Documents\EVE\capture\Screenshots\'+FileName); // ��������� ���� � ����������
    bmp.Assign(png); //������������ � bmp
    W := StrToInt(form1.Edit3.Text);  //������ c ���� �����
    H := StrToInt(form1.Edit4.Text);  //������ � ���� �����
    //������ ������ � ������ ����������� ������� �� ���������
    bmp2.Width:=W;
    bmp2.Height:=H;
    //�������� ����� ��������� �� ���������� �������� ������ ���� � ������ � ������ � bmp2
    BitBlt(bmp2.Canvas.Handle, 0, 0, W, H, bmp.Canvas.Handle, StrToInt(form1.Edit1.Text), StrToInt(form1.Edit2.Text), SRCCOPY);
    bmp2.PixelFormat:=pf8bit;  // ��������� � 8�� ������ �������� ������������� �������
    { ���� ������������ �������� �� ������������ ���� ���������� �������� � ���� �������
    � �������� ��� ����������� ��������� � �������� � ����� ������, ���� � �������� ������������ �������� ����� �������� �������}
    if TestStart = True then
      Begin
        for i := 1 to bmp2.Height do
         for j:= 1 to bmp2.Height do
            if (bmp2.Canvas.Pixels[i,j] = RGB(StrToInt(form1.R.Text),StrToInt(form1.G.Text),StrToInt(form1.B.Text))) then
                begin
                form1.GroupBox3.Visible:= True;
                form1.StopClick(nil);
                sndPlaySound('alarm.wav',SND_ASYNC+SND_LOOP);
                TimeAlarm := 25;
                form1.timer2.Enabled:=True;
                goto stop;
                end;
      stop:
      end;
    //��� ����������� ������� ���������� ����� ��������� � �����
    form1.Image1.Picture.Bitmap.Assign(bmp2);
    //������������ ����������
    png.Free;
    bmp.Free;
    bmp2.Free;
    //������� ���������� �� �����������
    killDir(SystemDyrectory+'\Documents\EVE\capture\Screenshots\');
  end;



procedure TForm1.Button1Click(Sender: TObject);
   //��������� ������ ���� ���������
  var
  TestStart : boolean;

  Begin
      TestStart:=False;
      stop_enemy(TestStart);
  End;


  procedure TForm1.FormCreate(Sender: TObject);
//   ��������� ������ ������ ��������� ������, ������� ����� �� �����������
    var
    wnd: hwnd;
    buff: array [0..127] of char;

begin
  SystemDyrectory := GetSpecialPath(CSIDL_PROFILE);
  killDir(SystemDyrectory+'\Documents\EVE\capture\Screenshots\');
  ComboBox1.clear;
  wnd := GetWindow(handle, gw_hwndfirst); //�������� ���������� �������� ����
  while wnd <> 0 do
    begin // �� ����������:
      if (wnd <> Application.Handle) // ����������� ����
      and IsWindowVisible(wnd) // ��������� ����
      and (GetWindow(wnd, gw_owner) = 0) // �������� ����
      and (GetWindowText(wnd, buff, SizeOf(buff)) <> 0) then
        begin
          GetWindowText(wnd, buff, SizeOf(buff));
          ComboBox1.Items.Add(StrPas(buff));
        end;
    wnd := GetWindow(wnd, gw_hwndnext);
    end;
  ComboBox1.ItemIndex := 0;

end;

{ ��� ������� ������� F11, F12 ��� �������� ���� ������ �������� �������������
 ��� ������������(���������� ������ � ���� �����) }
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
   var
    p: TPoint;
    x, y: integer;
    Color: Longint;
    r, g, b: Byte;
begin
   if Key=VK_F11 then
   begin
      GetCursorPos(p);
      x := p.X;
      y := p.Y;
      Edit1.Text:=IntToStr(x);
      Edit2.Text:=IntToStr(y);

    end;
   if Key=VK_F12 then
   begin
      GetCursorPos(p);
      x := p.X;
      y := p.Y;
      Edit3.Text:=IntToStr(x-StrToInt(Edit1.Text));
      Edit4.Text:=IntToStr(y-StrToInt(Edit2.Text));

   End;
   if Key=VK_F10 then
   begin
      GetCursorPos(p);
      x := p.X;
      y := p.Y;
      Color:= DesktopColor(p.x, p.y);
      r := Color;
      g := Color shr 8;
      b := Color shr 16;
      label16.Caption := 'RGB: '+ IntToStr(r) +
    ' ' + IntToStr(g) +
    ' ' + IntToStr(b);
   end;
end;

//��������� ������������
procedure TForm1.StopClick(Sender: TObject);
begin
  Label12.Visible:=False;
  GroupBox1.Enabled:=True;
  Stop.Enabled := False;
  Stop.Visible:= False;
  Start.Visible := True;
  Start.Enabled:= True;
  Timer1.Enabled:=False;
end;

// ���������� �������
procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
   sndPlaySound(nil,SND_ASYNC);
   form1.GroupBox3.Visible:= False;
   Timer2.Enabled:=False;
end;

//��������� ��������� �������(����� ������������)
procedure TForm1.StartClick(Sender: TObject);
begin
  Label12.Visible:=True;
  GroupBox1.Enabled:=False;
  Stop.Enabled := True;
  Stop.Visible :=True;
  Start.Enabled:= False;
  Start.Visible:= False;
  Timer1.Enabled:=True;
end;

//������ �������� ��������, ��� ��� � �������� �� ����� ����� ���������� ������ ���������
// � ����� �������� �� ������� �������� �������� ��������
procedure TForm1.Timer1Timer(Sender: TObject);
var
TestStart :Boolean;
begin
   Timer1.Interval:=StrToInt(Edit5.Text)*1000;
   TestStart:=True;
   stop_enemy(TestStart);

end;

//������ ������� ����������� ��� ��������� ������� � � ������ ���� �� ���������� �������
//����� 25 ������ ��� ���� ���� ���������.
procedure TForm1.Timer2Timer(Sender: TObject);

begin

  TimeAlarm:=TimeAlarm-1;
  label15.Caption:=IntToStr(TimeAlarm);
  if TimeAlarm =0  then
    begin
      Timer2.Enabled:=False;
      sndPlaySound(nil,SND_ASYNC);
      if CheckBox1.Checked = True then
        begin
          winexec('taskkill /F /IM exefile.exe', SW_HIDE);
          ShowMessage('��������� ������ �������');
        end;
      form1.GroupBox3.Visible:= False;
    end;
end;
end.
