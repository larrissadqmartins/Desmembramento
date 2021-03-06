//unit ui2c;

//interface
//uses StdCtrls;

unit ui2c;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,baseunix,unix;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

const I2C_SLAVE = 1795;
//const I2C_SLAVE = $21;


var
  Form1: TForm1;
  buf :packed array [0..1] of char;
  c   :char;
  devPath:string ='/dev/i2c-1';
  iDevaddr: cint = $02;

  //verifica o barramento i2c-1 [1]
  //i2cdetect -y 1
  //escreve 255 no barramento i2c-1
  //i2cset -y 1 0x21 255
  //ler o valor no barramento i2c-1
  //i2cget -y 1 0x21

implementation

{$R *.lfm}

{ TForm1 }
Procedure InitI2cDevice();
const
  p : PChar = '89';     //Characters to sent 8=RAM Register 9=Value
  I2C_SLAVE = 1795;     //?? Got 1795 from C-Funtcion

Var
  iwf,iio : integer;
  fd, address : Cint;
  paddress : ^integer;

begin
 address := $42;                //Device Address DS1307 RTC
 paddress := @address;    //Pointer to Device Address
 //paddress := address shr 1;

 fd := fpopen('/dev/i2c-1',O_WrOnly);     //Open the I2C bus
 iio:= fpioctl(fd, I2C_SLAVE, paddress);
//iio:= fpioctl(fd, I2C_SLAVE, pointer(address) shr 1);

 iwf := fpread(fd, p[0], 2);             //write to the Device
  form1.edit2.text:= p;
 //fpioctl and fpwrite both return -1
// writeln('After fpwrite: ' + #13 + #10 + 'FileRet#: ' + Inttostr(fd) + ' fpwriteRet#: ' + IntToStr(iwf) + ' fpioctl#: ' + IntToStr(iio));
 fpclose(fd);
end;

//  const
procedure TForm1.Button1Click(Sender: TObject);
begin
  try
   // handle:=fpopen(devPath,O_RDWR);
    handle:=fpopen(devPath,O_WrOnly);

        fpIOCtl(handle,I2C_SLAVE,pointer(idevAddr));
        fpclose(handle);
  except
     edit2.text:='Error Inicializing i2c';
     halt;
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  try
        buf:=edit1.text;
        fpwrite(handle,buf,3);
  finally
        edit2.text:='Error Escrevendo';

  end;


end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  try
        //buf:=edit1.text;
        fpread(handle,buf,1);
        edit2.text:=buf;
  finally
        edit2.text:='Error Escrevendo';

  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    InitI2cDevice;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

end.
