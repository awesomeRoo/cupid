{****************************************************************************}
{*                 EE 4524 Artificall Intelligence - Term Project           *}
{*                             CUPID Version 1.0                            *}
{*                                                                          *}
{*                                Ray Zeisz                                 *}
{*                            December 4, 1990                              *}
{****************************************************************************}
{* Module:      INTRO.PAS                                                   *}
{* Date:        December 2, 1990                                            *}
{* Function:    Displays the introduction screen for the CUPID system.      *}
{****************************************************************************}
program CupidIntro;

uses
  Fonts,
  Drivers,
  Graph,
  Crt;

var
  x,y : integer;
  Ch : char;
  Gd, Gm : integer;

procedure InitializeGraphics;
begin
  { Register the drivers }
  if RegisterBGIdriver(@CGADriverProc) < 0 then Halt(99);
  if RegisterBGIdriver(@EGAVGADriverProc) < 0 then Halt(99);

  { Register all the fonts }
  if RegisterBGIfont(@GothicFontProc) < 0 then Halt(98);
  if RegisterBGIfont(@SansSerifFontProc) < 0 then Halt(98);
  if RegisterBGIfont(@SmallFontProc) < 0 then Halt(98);
  if RegisterBGIfont(@TriplexFontProc) < 0 then Halt(98);

  Gd:= Detect;                  { autodetect the hardware }
  InitGraph(Gd, Gm, '');        { activate graphics }
  if GraphResult <> grOk then   { any errors? }
    begin
    Writeln('Graphics init error: ', GraphErrorMsg(Gd));
    Halt(1);
    end;
end;

begin    { main }
  InitializeGraphics;
  ClearViewPort;

  SetTextStyle(1,0,7);
  OutTextXY(0,10,'       Cupid');
  SetTextStyle(2,0,8);
  OutTextXY(0,450,'   Computer Programmed Intelligent Dating');
  SetTextStyle(2,0,6);
  OutTextXY(440,50,'by Ray Zeisz');

  x := 100;
  y := 0;
  repeat
    circle(x,240+y,100);
    line(x+60,   160+y,x+60+60, 80+y);
    line(x+60+60,80+y, x+60+60, 100+y);
    line(x+60+60,80+y, x+60+45, 80+y);

    circle(639-x,240+y,100);
    line(639-x,340+y,639-x,400+y);
    line(639-x-15,380+y,639-x+15,380+y);
    x := x + 20;
    y := y + 5;

    if KeyPressed then begin
      CloseGraph;
      ClrScr;
      Ch := ReadKey;
      Halt(1);
      end;
  until x >= 250;

  x := 0;
  repeat
    Delay(100);
    Inc(x);
  until KeyPressed or (x > 40);

  if KeyPressed then Ch := ReadKey;
  ClearViewPort;
  CloseGraph;
end.
