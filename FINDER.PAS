{****************************************************************************}
{*                 EE 4524 Artificall Intelligence - Term Project           *}
{*                             CUPID Version 1.0                            *}
{*                                                                          *}
{*                                Ray Zeisz                                 *}
{*                            December 4, 1990                              *}
{****************************************************************************}
{* Module:      FINDER.PAS                                                  *}
{* Date:        December 2, 1990                                            *}
{* Function:    Performs a hueristic search on the data base to find a      *}
{*              mate that is close to the ideal mate.                       *}
{* Usage:       FINDER - will read the CUPIDMTE.DAT and find the best match *}
{*              for the ideal mate contained in this file.                  *}
{*              FINDER ? - will prompt the user for the Myers-Briggs values *}
{*              of the ideal mate.                                          *}
{*                                                                          *}
{* File Usage:  CUPIDMTE.DAT may be used as input for the Myers-Briggs      *}
{*              values of the ideal mate.                                   *}
{*              CUPIDMAL.DAT & CUPIDFEM.DAT - contain the data base of      *}
{*              possible mates.                                             *}
{*              MATES.DAT is the final output file which lists the mates    *}
{*              that appear to be good matches.                             *}
{****************************************************************************}
program Finder;

uses
  Dos,
  Crt;

const
  InteractiveParm   = '?';
  MatchTempFileName = 'CUPIDMTE.DAT';
  MatesFileName     = 'MATES.DAT';
  MaleFileName      = 'CUPIDMAL.DAT';
  FemaleFileName    = 'CUPIDFEM.DAT';
  MaxPeople         = 100;
  DiffThreshold     = 20;
  BlankLine         = '                                                                               ';

type
  Person = record
             Name   : string[80];
             Values : array [1..4] of integer;
             Diff   : integer;
             end;

var
  MateFile, Gender, Mates : text;
  Ch : char;
  Female  : boolean;
  MateType : string[5];
  Master    : person;
  NumPeople : integer;
  People    : array[1..MaxPeople] of Person;


procedure Intro;
{ Displays a brief introduction screen }
var
  Ch : Char;
  qu : integer;
begin
  ClrScr;
  TextColor(LightMagenta);
  Writeln(#3,' Computer Programmed Intelligent Dating');
  TextColor(Magenta);
  Writeln('  Data Base Hueristic Searcher');
  Writeln;
  Writeln;
  qu := 0;
  repeat
    Delay(100);
    Inc(qu);
  until KeyPressed or (qu = 10);
  while KeyPressed do
    Ch := ReadKey;
end;

function YesNo: char;
{ Returns TRUE for 'y' pressed }
var
  c : char;
begin
  repeat
    c := UpCase(ReadKey);
  until (c = 'Y') or (c = 'N');
  YesNo := c;
end;

procedure WriteValues(P : Person);
{ Writes MB values to the screen }
begin
  with P do begin
    Writeln('Extraversion ',Values[1]:2,'     Intraversion ',(20-Values[1]):2);
    Writeln('Sensation    ',Values[2]:2,'     iNtuition    ',(20-Values[2]):2);
    Writeln('Thinking     ',Values[3]:2,'     Feeling      ',(20-Values[3]):2);
    Writeln('Judging      ',Values[4]:2,'     Perceiving   ',(20-Values[4]):2);
  end;
end;

procedure WriteValuesF(P : Person);
{ Writes MB values to the MATES.DAT file }
begin
  with P do begin
    Writeln(Mates,'Extraversion ',Values[1]:2,'     Intraversion ',(20-Values[1]):2);
    Writeln(Mates,'Sensation    ',Values[2]:2,'     iNtuition    ',(20-Values[2]):2);
    Writeln(Mates,'Thinking     ',Values[3]:2,'     Feeling      ',(20-Values[3]):2);
    Writeln(Mates,'Judging      ',Values[4]:2,'     Perceiving   ',(20-Values[4]):2);
  end;
end;

procedure StartMatesFile;
{ Outputs the header for the MATES.DAT result file }
begin
  Assign(Mates,MatesFileName);
  Rewrite(Mates);
  Writeln(Mates,Master.Name,' who is searching for someone who is ideally:');
  WriteValuesF(Master);
  Writeln(Mates);
  Writeln(Mates,'matches well with:');
  Writeln(Mates);
end;

function GetValuesFromFile: boolean;
{ Reads the Master's ideal mate's values from the temp file }
var
  Ch : char;
  Sex : string;
begin
  {$I-}
  Assign(MateFile, MatchTempFileName);
  Reset(MateFile);
  Readln(MateFile, Master.Name);
  MateType := Copy(Master.Name, Length(Master.Name)-3, 4);
  Delete(Master.Name, Length(Master.Name)-4, 5);
  Readln(MateFile, Sex);
  if Sex = 'FEMALE' then Female := True
                    else Female := False;

  with Master do
    Readln(MateFile, Values[1], Values[2], Values[3], Values[4]);
  Close(MateFile);
  {$I+}

  if IOResult <> 0 then begin
    GetValuesFromFile := False;
    Exit;
    end;

  TextColor(LightCyan);
  Writeln('Your name is ',Master.Name,'.');
  Write('You are in search of a ');
  if Female then Write('female ')
	    else Write('male ');
  Writeln(MateType,'.');

  TextColor(White);
  Writeln;
  Write('Is this correct? [Y/N] ');
  Ch := YesNo;
  GetValuesFromFile := (Ch = 'Y');
end;

procedure GetValuesFromUser;
{ Prompts the user for ideal mate's values }
var
  dummy : integer;
  Ch : char;
  s : string;
begin
  Master.Name := 'Anonymous';
  repeat
    TextColor(Yellow);
    Writeln;
    Writeln;
    Writeln;
    Writeln('Personal Information');
    Writeln;
    TextColor(LightGreen);
    Writeln('Are you female? [Y/N] ');
    Ch := YesNo;
    Female := (Ch = 'N');

    TextColor(Yellow);
    Writeln;
    Writeln('The following questions pertain to the mate you are seeking.');
    Writeln;
    TextColor(LightGreen);
    Write('What Extraversion level? [0-20] ');
    TextColor(White);
    Readln(s);
    Val(s, Master.Values[1], dummy);
    if Master.Values[1] < 0  then Master.Values[1] := 0;
    if Master.Values[1] > 20 then Master.Values[1] := 20;

    TextColor(LightGreen);
    Write('What Sensation level? [0-20]    ');
    TextColor(White);
    Readln(s);
    Val(s, Master.Values[2], dummy);
    if Master.Values[2] < 0  then Master.Values[2] := 0;
    if Master.Values[2] > 20 then Master.Values[2] := 20;

    TextColor(LightGreen);
    Write('What Thinking level? [0-20]     ');
    TextColor(White);
    Readln(s);
    Val(s, Master.Values[3], dummy);
    if Master.Values[3] < 0  then Master.Values[3] := 0;
    if Master.Values[3] > 20 then Master.Values[3] := 20;

    TextColor(LightGreen);
    Write('What Judging level? [0-20]      ');
    TextColor(White);
    Readln(s);
    Val(s, Master.Values[4], dummy);
    if Master.Values[4] < 0  then Master.Values[4] := 0;
    if Master.Values[4] > 20 then Master.Values[4] := 20;

    TextColor(LightGreen);
    ClrScr;
    Write('You are in search of a ');
    if Female then Writeln('female ')
              else Writeln('male ');
    Writeln('with the following temperament levels:');
    Writeln;
    TextColor(Green);
    WriteValues(Master);
    TextColor(White);
    Writeln;
    Writeln;
    Write('Is this correct? [Y/N] ');
    Ch := YesNo;
  until Ch = 'Y';
end;

procedure LoadDataBase;
{ Reads in the (male or female) data base from file }
var
  dummy,
  i : integer;
begin
  {$I-}
  if Female then Assign(Gender,FemaleFileName)
            else Assign(Gender,MaleFileName);
  Reset(Gender);
  Readln(Gender);
  i := 0;
  while (IOResult = 0) and (not EOF(Gender)) and (i < MaxPeople) do begin
    Inc(i);
    Readln(Gender, People[i].Name);
    with People[i] do
      Readln(Gender,Values[1], dummy, Values[2], dummy, Values[3], dummy, Values[4]);
    People[i].Diff := 0;
    end;

  if (i >= MaxPeople) then begin
    TextColor(Red);
    Writeln('*WARNING*');
    Writeln('Data base contains more records than FINDER can store.');
    Writeln('Current limit is set to: ',MaxPeople);
    Writeln('All additional records are ignored and not searched.');
    end;

  Close(Gender);
  NumPeople := i;

  if IOResult <> 0 then begin
    TextColor(LightRed);
    Writeln('Error reading file ',IOResult);
    Halt(1);
    end;
  {$I+}
end;

procedure GetBest;
{ Finds the differnce factor by summing the squares of the differences
  between ideal and current record multiplied by a level of importance }
var
  p,t : integer;
  Scale : array[1..4] of real;
begin
  Scale[1] := 1;
  Scale[2] := 1.5;
  Scale[3] := 1.1;
  Scale[4] := 1.2;

  for t := 1 to 4 do begin
    for p := 1 to NumPeople do begin
      People[p].Diff := People[p].Diff +
           Sqr(Trunc(Abs(People[p].Values[t]-Master.Values[t]) * Scale[t]));
      end;
    end;
end;

procedure WriteRecsWithSmallestDiff;
{ Writes the MATCHING records to the screen and MATES.DAT files }
var
  min, i : integer;
begin
  min := MaxInt;
  for i := 1 to NumPeople do
    if People[i].Diff < min then min := People[i].Diff;

  TextColor(White);
  Write('The following ');
  if Female then Write('females ')
            else Write('males ');
  Writeln('appear to be good matches for the levels requested:');
  Writeln;
  TextColor(Green);
  for i := 1 to NumPeople do begin
    if People[i].Diff-DiffThreshold <= min then begin
      TextColor(LightCyan);
      Write(People[i].Name);
      Writeln(Mates,People[i].Name);
      if (People[i].Values[1] = Master.Values[1]) and
         (People[i].Values[2] = Master.Values[2]) and
         (People[i].Values[3] = Master.Values[3]) and
         (People[i].Values[4] = Master.Values[4]) then begin
        TextColor(LightMagenta);
        Write('  ',#3,' Perfect Match ',#3);
        end;
      Writeln;
      TextColor(Cyan);
      WriteValues(People[i]);
      WriteValuesF(People[i]);
      Writeln;
      Write('Press any key...');
      Ch := ReadKey;
      GotoXY(1,WhereY);
      Writeln(BlankLine);
      end;
    end;
end;

begin    { main }
  Intro;

  if ParamCount > 0 then begin
    if ParamStr(1) = InteractiveParm
      then GetValuesFromUser
      else begin
        TextColor(LightRed);
        Writeln('Invalid command line parameter: ',ParamStr(1));
        Writeln('Use "?" parameter to enter type indicator values or,');
        Writeln('use no parameter to use values in the file, ',MatchTempFileName);
        Halt(1);
        end;
    end
  else
    if Not GetValuesFromFile then
      GetValuesFromUser;

  StartMatesFile;
  LoadDataBase;
  ClrScr;
  TextColor(LightGreen);
  Writeln('Searching data base for the person closest to:');
  TextColor(Green);
  WriteValues(Master);
  Writeln;
  GetBest;
  Delay(900);
  WriteRecsWithSmallestDiff;
  Close(Mates);
end.
