{****************************************************************************}
{*                 EE 4524 Artificall Intelligence - Term Project           *}
{*                             CUPID Version 1.0                            *}
{*                                                                          *}
{*                                Ray Zeisz                                 *}
{*                            December 4, 1990                              *}
{****************************************************************************}
{* Module:      FINDTYPE.PAS                                                *}
{* Date:        December 2, 1990                                            *}
{* Function:    Administers the Myers-Briggs type indicator and reports the *}
{*              results.                                                    *}
{* Usage:       FINDTYPE - runs the test and adds the score to the CUPID    *}
{*              data base.                                                  *}
{*                                                                          *}
{* File Usage:  CUPIDTMP.DAT is generated and contains the values for the   *}
{*              last person to take the test.                               *}
{*              CUPIDQUE.DAT contains the questions for the test.           *}
{*              CUPIDMAL.DAT & CUPIDFEM.DAT contain the males and females   *}
{*              (respectively) that have taken the test.  Also writes thier *}
{*              type and values to these files.                             *}
{****************************************************************************}
program FindType;

{$M 64000,0,64000}  { Since Exec() is called, reduce Heap Size }

uses
  Dos,
  Fonts,
  Drivers,
  Graph,
  Crt;

const
  QuesFileName   = 'CUPIDQUE.DAT';
  AnsFileExt     = '.ANS';
  TempFileName   = 'CUPIDTMP.DAT';
  MaleFileName   = 'CUPIDMAL.DAT';
  FemaleFileName = 'CUPIDFEM.DAT';

var
  Question  : array [1..3] of string[82];
  Ques, Ans, Gender, TempFile : text;
  Ch : char;
  Results : array [1..2] of array [0..6] of integer;
  Count   : integer;
  Female  : boolean;
  FirstName, LastName, Name,
  TypeString,
  Occupation : string;
  Eval, Ival,
  Sval, Nval,
  Tval, Fval,
  Jval, Pval : integer;
  Gd, Gm : integer;

procedure Intro;
{ Displays a brief introduction and description of test }
var
  Ch : Char;
  qu : integer;
begin
  ClrScr;
  TextColor(LightMagenta);
  Writeln(#3,' Computer Programmed Intelligent Dating');
  TextColor(Magenta);
  Writeln('  Myers-Briggs Type Indicator  (Keirsey Subset)');
  Writeln;
  qu := 0;
  repeat
    Delay(100);
    Inc(qu);
  until KeyPressed or (qu = 5);
  while KeyPressed do
    Ch := ReadKey;
  TextColor(White);
  Write('   There are no "right" or "wrong" answers to the questions on this inventory.  ');
  Write('Your answers will help show how you like to look at things and how you like to  ');
  Write('go about deciding things.  Knowing your own preferences and learning about other');
  Write('people''s can help you understand where your special strengths are, what kinds   ');
  Write('of work you might enjoy and be successful doing, and how people with different  ');
  Write('preferences can relate to each other and be valuable to society.                ');
  Writeln;
  Write('   You will be catagorized into one of 16 personality types. (e.g. ESTJ or INTJ)');
  Write('Each of these types have unique characteristics.  Also you will be classified   ');
  Write('into one of four temperaments.  A sample character description of your type will');
  Write('be displayed at the end of the test.  If an X appears in your personality type  ');
  Write('this means that the test is unable to determine a preference for one of the     ');
  Write('catagories.  For example an EXTJ would have characteristic of both the ESTJ and ');
  Write('ENTJ types as well as both the NT and SJ temperaments.                          ');
  Writeln;
  Write('     Read each question carefully and indicate your answer by typing a or b.    ');
  Write('Do not think too long about any question.                                       ');
  Writeln;
  Writeln;
  Writeln('Press any key...');
  Ch := ReadKey;
end;

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
  ClearViewPort;
end;

procedure InitializeResults;
var
  i : integer;
begin
  for i := 0 to 6 do begin
    Results[1][i] := 0;
    Results[2][i] := 0;
    end;
end;

function Strn(x : word):string;
{ converts a number to a string }
var
  s : string;
begin
  Str(x,s);
  if x < 10 then s := Concat(' ',s);
  Strn := s
end;

procedure MakeASCII(var s : string);
{ removes weird characters from a string }
var
  i : integer;
begin
  for i := 1 to length(s) do begin
    if s[i] in ['A'..'Z'] then s[i] := Chr( Ord(UpCase(s[i])) + 32);
    if not (s[i] in ['a'..'z',' ']) then s[i] := '_';
    end;
  s[1] := UpCase(s[1]);
end;

procedure MakeTypeString(var TypeString : string);
{ creates a four letter MB type string }
begin
  TypeString := '';
  if Eval = Ival
    then TypeString := 'X'
    else if Eval > Ival then TypeString := 'E'
                 else TypeString := 'I';

  if Sval = Nval
    then TypeString := Concat(TypeString,'X')
    else if Sval > Nval
      then TypeString := Concat(TypeString,'S')
      else TypeString := Concat(TypeString,'N');

  if Tval = Fval
    then TypeString := Concat(TypeString,'X')
    else if Tval > Fval
      then TypeString := Concat(TypeString,'T')
      else TypeString := Concat(TypeString,'F');

  if Jval = Pval
    then TypeString := Concat(TypeString,'X')
    else if Jval > Pval
      then TypeString := Concat(TypeString,'J')
      else TypeString := Concat(TypeString,'P');
end;

procedure FindOccupation(var Occupation : string; TypeString : string);
{ Finds the occupation string based on the MB type; for printing purposes }
begin
  Occupation := '';
  if TypeString = 'INTP' then Occupation := '  Architect  ';
  if TypeString = 'ENTP' then Occupation := '  Inventor   ';
  if TypeString = 'INTJ' then Occupation := '  Scientist  ';
  if TypeString = 'ENTJ' then Occupation := ' Fieldmarshal';
  if TypeString = 'INFP' then Occupation := '   Questor   ';
  if TypeString = 'ENFP' then Occupation := '  Journalist ';
  if TypeString = 'INFJ' then Occupation := '    Author   ';
  if TypeString = 'ENFJ' then Occupation := '  Pedagogue  ';
  if TypeString = 'ESFJ' then Occupation := '    Vendor   ';
  if TypeString = 'ISFJ' then Occupation := ' Conservator ';
  if TypeString = 'ESFP' then Occupation := ' Entertainer ';
  if TypeString = 'ISFP' then Occupation := '    Artist   ';
  if TypeString = 'ESTJ' then Occupation := 'Administrator';
  if TypeString = 'ISTJ' then Occupation := '   Trustee   ';
  if TypeString = 'ESTP' then Occupation := '   Promotor  ';
  if TypeString = 'ISTP' then Occupation := '   Artisian  ';
end;

function YesNo: char;
{ returns TRUE for 'y' }
var
  c : char;
begin
  repeat
    c := UpCase(ReadKey);
  until (c = 'Y') or (c = 'N');
  YesNo := c;
end;

procedure GetGeneralInfo;
{ Gets info such as sex and name from the person taking the test }
begin
  ClrScr;
  TextColor(Yellow);
  Writeln('General Information');
  Writeln;

  repeat
    TextColor(LightGreen);
    Write('What is your first name? ');
    TextColor(White);
    repeat
      Readln(FirstName);
    until FirstName <> '';
    MakeASCII(FirstName);
    TextColor(LightGreen);
    Write('What is your last name?  ');
    TextColor(White);
    repeat
      Readln(LastName);
    until LastName <> '';
    MakeASCII(LastName);
    TextColor(LightGreen);
    Write('Are you female? [Y/N]    ');
    Ch := YesNo;
    if Ch = 'N' then Female := False
                else Female := True;

    TextColor(Yellow);
    ClrScr;
    Writeln;
    Writeln('Your name is ',FirstName,' ',LastName,'.');
    if Female then Writeln('You are female.')
              else Writeln('You are male.');
    TextColor(White);
    Writeln;
    Writeln('Is this correct? [Y/N] ');
    Ch := YesNo;
  until Ch = 'Y';
  Name := Concat(FirstName,' ',LastName);
end;

begin    { main }
  Intro;
  InitializeResults;
  GetGeneralInfo;

  Assign(Ques,QuesFileName);
  Reset(Ques);
  Assign(Ans,Concat(FirstName,AnsFileExt));
  Rewrite(Ans);
  Writeln(Ans,Name);
  Count := 0;

  repeat
    ClrScr;
    GotoXY(1,11);
    Readln(Ques,question[1]);  TextColor(White); Writeln(question[1]);
    Readln(Ques,question[2]);  TextColor(Cyan);  Writeln(question[2]);
    Readln(Ques,question[3]);                    Writeln(question[3]);

    repeat
      Ch := ReadKey;
      if Ch = '1' then Ch := 'A';
      if Ch = '2' then Ch := 'B';
      Ch := Upcase(Ch);
    until (Ch = 'A') or (Ch = 'B');

    Inc(Count);
    if Ch = 'A' then begin
      Inc(Results[1][(Count-1) MOD 7]);
      Writeln(Ans,Question[1]);
      Writeln(Ans,Question[2]);
      end
    else begin
      Inc(Results[2][(Count-1) MOD 7]);
      Writeln(Ans,Question[1]);
      Writeln(Ans,Question[3]);
      end;
  until EOF(Ques);

  TextColor(Cyan);
  ClrScr;
  Writeln('Working...');
  Close(Ques);
  Close(Ans);

  Eval := Results[1][0] * 2;
  Ival := Results[2][0] * 2;
  Sval := Results[1][1] + Results[1][2];
  Nval := Results[2][1] + Results[2][2];
  Tval := Results[1][3] + Results[1][4];
  Fval := Results[2][3] + Results[2][4];
  Jval := Results[1][5] + Results[1][6];
  Pval := Results[2][5] + Results[2][6];

  MakeTypeString(TypeString);
  FindOccupation(Occupation, TypeString);

  Assign(TempFile,TempFileName);
  Rewrite(TempFile);
  Writeln(TempFile,Name);
  Writeln(TempFile,TypeString);
  if Female then Writeln(TempFile,'FEMALE')
            else Writeln(TempFile,'MALE');
  Writeln(TempFile,Eval,' ',Ival,' ',Sval,' ',Nval,' ',Tval,' ',Fval,' ',Jval,' ',Pval);
  Close(TempFile);

  if Female then Assign(Gender,FemaleFileName)
            else Assign(Gender,MaleFileName);
  Append(Gender);
  Writeln(Gender,Name,' ',TypeString);
  Writeln(Gender,' ',Eval,' ',Ival,' ',Sval,' ',Nval,' ',Tval,' ',Fval,' ',Jval,' ',Pval);
  Close(Gender);

  InitializeGraphics;
  SetTextStyle(1,0,10);
  OutTextXY(175,40, TypeString);

  SetTextStyle(2,0,8);
  OutTextXY(70,300,Concat('Extraversion ',Strn(Eval),'   Introversion ',Strn(Ival)));
  OutTextXY(70,330,Concat('Sensation    ',Strn(Sval),'   iNtuition    ',Strn(Nval)));
  OutTextXY(70,360,Concat('Thinking     ',Strn(Tval),'   Feeling      ',Strn(Fval)));
  OutTextXY(70,390,Concat('Judging      ',Strn(Jval),'   Perceiving   ',Strn(Pval)));
  OutTextXY(10,450,Concat('Press any key...'));

  SetTextStyle(3,0,7);
  OutTextXY(100,210,Occupation);

  Ch := ReadKey;
  ClearViewPort;
  CloseGraph;
  ClrScr;

  TextColor(LightGreen);
  Writeln('Would you like a characters description of the typical ',TypeString,'? [Y/N]');
  Ch := YesNo;
  if Ch = 'Y' then begin
    SwapVectors;
    Exec('DESCRIBE.EXE',TypeString);
    SwapVectors;
    end;
end.
