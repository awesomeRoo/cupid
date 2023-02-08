{****************************************************************************}
{*                 EE 4524 Artificall Intelligence - Term Project           *}
{*                             CUPID Version 1.0                            *}
{*                                                                          *}
{*                                Ray Zeisz                                 *}
{*                            December 4, 1990                              *}
{****************************************************************************}
{* Module:      CUPID.PAS                                                   *}
{* Date:        December 2, 1990                                            *}
{* Function:    Finds the Myers-Briggs type that is best suited for one's   *}
{*              mate based on one's Myers-Briggs values and some questions. *}
{* Usage:       CUPID - the program will read the CUPIDTMP.DAT file for the *}
{*              master description, then find the mates values accordingly. *}
{*              CUPID ? - the ? paramter will cause interactive mode to be  *}
{*              invoked; i.e. the Myers-Briggs values for the master are    *}
{*              entered from the keyboard.                                  *}
{*                                                                          *}
{* File Usage:  CUPIDTMP.DAT may be used as input for the Myers-Briggs type.*}
{*              CUPIDMTE.DAT will contain the Myers-Briggs values of the    *}
{*              theoretical ideal mate.                                     *}
{****************************************************************************}
program Cupid;

{$M 64000,0,64000}  { Since Exec() is called, reduce Heap Size }

uses
  Dos,
  Crt;

const
  InteractiveParm  = '?';
  TempFileName     = 'CUPIDTMP.DAT';
  TempMateFileName = 'CUPIDMTE.DAT';
  BlankLine        = '                                                                           ';

  AlternativeTypeVote = 2;


type
  MBTypes = (E,I,S,N,T,F,J,P);
  VoteRec = record
           E, I, S, N, T, F, J, P : integer;
           end;

var
  TempFile,
  TempMateFile : text;
  Ch : char;
  Female  : boolean;
  Name,
  MasterTypeString,
  MateTypeString : string;
  Master,
  Mate : VoteRec;
  isE, isI, isS, isN, isT, isF, isJ, isP : boolean;  { Master's flags }
  Gd, Gm : integer;


function YesNo: char;
{ Returns TRUE if a 'y' is pressed }
var
  c : char;
begin
  repeat
    c := UpCase(ReadKey);
  until (c = 'Y') or (c = 'N');
  YesNo := c;
end;

procedure Intro;
{ Displays a brief introduction screen }
var
  Ch : Char;
  qu : integer;
begin
  ClrScr;
  TextColor(LightMagenta);
  writeln(#3,' Computer Programmed Intelligent Dating');
  TextColor(Magenta);
  Writeln('  Match Maker');
  Writeln;
  qu := 0;
  repeat
    Delay(100);
    Inc(qu);
  until KeyPressed or (qu = 20);
  while KeyPressed do
    Ch := ReadKey;
end;

procedure Working;
{ Displays a "Working" symbol }
begin
  ClrScr;
  TextColor(Cyan);
  Write('Working...');
end;

procedure InitializeMate;
{ Prepares the voting data structure for voting }
const
  Base = 5;
begin
  with Mate do begin
    E := Base; I := Base; S := Base; N := Base;
    T := Base; F := Base; J := Base; P := Base;
    end;
end;

procedure WriteValues(M : VoteRec);
{ Writes all of the Myers-Briggs names and their values }
begin
  with M do begin
    Writeln('Extraversion ',E:2,'     Intraversion ',I:2);
    Writeln('Sensation    ',S:2,'     iNtuition    ',N:2);
    Writeln('Thinking     ',T:2,'     Feeling      ',F:2);
    Writeln('Judging      ',J:2,'     Perceiving   ',P:2);
  end;
end;

procedure MakeTypeString(var TypeString : string; M : VoteRec);
{ Concats the MB type string based on the votes }
begin
  TypeString := '';
  if M.E = M.I
    then TypeString := 'X'
    else if M.E > M.I then TypeString := 'E'
                 else TypeString := 'I';

  if M.S = M.N
    then TypeString := Concat(TypeString,'X')
    else if M.S > M.N
      then TypeString := Concat(TypeString,'S')
      else TypeString := Concat(TypeString,'N');

  if M.T = M.F
    then TypeString := Concat(TypeString,'X')
    else if M.T > M.F
      then TypeString := Concat(TypeString,'T')
      else TypeString := Concat(TypeString,'F');

  if M.J = M.P
    then TypeString := Concat(TypeString,'X')
    else if M.J > M.P
      then TypeString := Concat(TypeString,'J')
      else TypeString := Concat(TypeString,'P');
end;

function GetValuesFromFile: boolean;
{ Reads in the Master's data from the Temp file }
var
  Ch : char;
  Sex : string;
begin
  {$I-}
  Assign(TempFile, TempFileName);
  Reset(TempFile);
  Readln(TempFile, Name);
  Readln(TempFile, MasterTypeString);
  Readln(TempFile, Sex);
  if Sex = 'FEMALE' then Female := True
                    else Female := False;
  with Master do
    Readln(TempFile,E,I,S,N,T,F,J,P);
  Close(TempFile);
  {$I+}

  if IOResult <> 0 then begin
    GetValuesFromFile := False;
    Exit;
    end;

  TextColor(LightCyan);
  ClrScr;
  Writeln('Your name is ',Name);
  if Female then Writeln('You are female.')
	    else Writeln('You are male.');
  WriteValues(Master);
  TextColor(White);
  Writeln;
  Writeln;
  Write('Is this correct? [Y/N] ');
  Ch := YesNo;
  GetValuesFromFile := (Ch = 'Y');
end;

procedure GetValuesFromUser;
{ prompts the user for the Master's MB type }
var
  Ch : char;
  s : string;
  dummy : integer;
begin
  Name := 'Unknown';

  repeat
    ClrScr;
    TextColor(Yellow);
    Writeln('Temperament Information');
    Writeln;
    TextColor(LightGreen);
    Writeln('Are you female? [Y/N] ');
    Ch := YesNo;
    Female := (Ch = 'Y');

    Write('What is your Extraversion level? [0-20] ');
    TextColor(White);
    Readln(s);
    Val(s, Master.E, dummy);
    if Master.E < 0  then Master.E := 0;
    if Master.E > 20 then Master.E := 20;
    Master.I := 20 - Master.E;

    TextColor(LightGreen);
    Write('What is your Sensation level? [0-20]    ');
    TextColor(White);
    Readln(s);
    Val(s, Master.S, dummy);
    if Master.S < 0  then Master.S := 0;
    if Master.S > 20 then Master.S := 20;
    Master.N := 20 - Master.S;

    TextColor(LightGreen);
    Write('What is your Thinking level? [0-20]     ');
    TextColor(White);
    Readln(s);
    Val(s, Master.T, dummy);
    if Master.T < 0  then Master.T := 0;
    if Master.T > 20 then Master.T := 20;
    Master.F := 20 - Master.T;

    TextColor(LightGreen);
    Write('What is your Judging level? [0-20]      ');
    TextColor(White);
    Readln(s);
    Val(s, Master.J, dummy);
    if Master.J < 0  then Master.J := 0;
    if Master.J > 20 then Master.J := 20;
    Master.P := 20 - Master.J;

    TextColor(LightCyan);
    ClrScr;
    if Female then Writeln('You are female.')
              else Writeln('You are male.');
    WriteValues(Master);
    TextColor(White);
    Writeln;
    Writeln;
    Write('Is this correct? [Y/N] ');
    Ch := YesNo;
  until Ch = 'Y';
  MakeTypeString(MasterTypeString,Master);
end;

function Question(s : string): boolean;
{ Displays a Yes/No question and returns TRUE for Yes }
var
  Ch : char;
begin
  ClrScr;
  TextColor(White);
  Write(s);
  Ch := YesNo;
  Working;
  Question := (Ch = 'Y');
end;

function QuestionAB(s1, s2, s3 : string): boolean;
{ Displays a three line A/B question; A returns TRUE, B returns FALSE }
var
  Ch : char;
begin
  ClrScr;
  TextColor(White);
  Writeln(s1);
  TextColor(Cyan);
  Writeln(s2);
  Writeln(s3);
  repeat
    Ch := UpCase(ReadKey);
  until (Ch in ['A','B','1','2']);
  Working;
  QuestionAB := (Ch in ['A','1']);
end;

procedure SetMastersFlags;
{ Sets the boolean flags for easier comparisons }
begin
  with Master do begin
    isE := E >= I;
    isI := I >= E;
    isS := S >= N;
    isN := N >= S;
    isT := T >= F;
    isF := F >= T;
    isJ := J >= P;
    isP := P >= J;
    end; { with }
end;

procedure Vote(MB : MBTypes; Votes : integer);
{ Votes in the data structure; makes sure no negative values ever result }
begin
  with mate do
    case Ord(MB) of
      0 : if (E+Votes > 0) then E := E + Votes;
      1 : if (I+Votes > 0) then I := I + Votes;
      2 : if (S+Votes > 0) then S := S + Votes;
      3 : if (N+Votes > 0) then N := N + Votes;
      4 : if (T+Votes > 0) then T := T + Votes;
      5 : if (F+Votes > 0) then F := F + Votes;
      6 : if (J+Votes > 0) then J := J + Votes;
      7 : if (P+Votes > 0) then P := P + Votes;
    end; { case }
end;

procedure OppositeRules;
{ The rule is opposites attract }
begin
  if Master.E > Master.I then Vote(I,Round(Master.E/3));
  if Master.I > Master.E then Vote(E,Round(Master.I/3));
  if Master.S > Master.N then Vote(N,Round(Master.S/3));
  if Master.N > Master.S then Vote(S,Round(Master.N/3));
  if Master.T > Master.F then Vote(F,Round(Master.T/3));
  if Master.F > Master.T then Vote(T,Round(Master.F/3));
  if Master.J > Master.P then Vote(P,Round(Master.J/3));
  if Master.P > Master.J then Vote(J,Round(Master.P/3));
end;

procedure ExtremeRules;
{ The rule is extreme people prefer similar people }
begin
  if Master.E >= 17 then Vote(E,6);
  if Master.I >= 17 then Vote(I,4);
  if Master.S >= 16 then Vote(S,6);
  if Master.N >= 16 then Vote(N,6);
  if Master.T >= 18 then Vote(T,5);
  if Master.F >= 18 then Vote(F,5);
  if Master.J >= 17 then Vote(J,5);
  if Master.P >= 17 then Vote(P,5);
end;

procedure EIRules;
{ Rules dealing with extraversion }
begin
  if Master.E = 20 then
    begin
    Mate.E := 12;
    Mate.I := 9;
    end;

  if Question('Do you often worry about loosing your mate to another person? [Y/N] ')
    then Vote(I,3);

  if QuestionAB('Do you enjoy someone who',
                ' (a) is the life of the party',' (b) is more reserved')
    then Vote(E,3)
    else Vote(I,3);

  if Master.I >= 17 then begin
    Vote(E,3);
    Vote(N,3);
    Vote(T,-5);
    end;
end;

procedure NSRules;
{ Rules dealing with Sensation }
begin
  if QuestionAB('What is more important in child development?',
                ' (a) vivid imagination',' (b) usefullness')
    then Vote(N,3)
    else Vote(S,3);

  if isN and QuestionAB('Are you happier with a decision that',
                        ' (a) feels right',' (b) makes sense')
    then Vote(N,3)
    else Vote(S,2);

  if QuestionAB('When buying something for yourself, do you idealy opt for',
                ' (a) something that is less logical, but feels good',
                ' (b) something practical')
    then Vote(N,4)
    else Vote(S,3);
end;

procedure TFRules;
{ Rules dealing with Thinking }
begin
  if (Master.T >= 18) or (Master.F >= 18) and (Mate.T < Mate.F)
    then Vote(T,2);

  if QuestionAB('Do you wish you were more',
                ' (a) logical',' (b) emotional')
    then Vote(T,3)
    else Vote(F,5);
end;

procedure JPRules;
{ Rules dealing with Judging }
begin
  if Master.J >= 15 then Vote(J,2);
  if Master.J >= 17 then Vote(J,3);

  if (Master.P >= 18) and (Mate.P < Mate.J)
    then Vote(P,2);

  if isJ then begin
    if isI then Vote(P,2);
    if isE then Vote(J,2);
    end;

  if isS and isP then begin
    if isE then begin
      Vote(S,-2);
      Vote(J,-2);
      end;
    if isI then begin
      Vote(S,4);
      Vote(P,2);
      Vote(J,2);
      end;
    end;
end;

procedure TemperamentRules;
{ Rules dealing with the four temperaments }
begin
  if isN then begin
    Vote(N,1);
    if isF then Vote(T,3);
    if isT then Vote(F,3);
    end;

  if isS then begin
    Vote(S,1);
    if isP then Vote(J,3);
    if isJ then Vote(P,3);
    end;

  if QuestionAB('It is acceptable to have sex with',' (a) people you date',' (b) people you love')
    then Vote(P,3)
    else Vote(J,3);

  if isN and isT and (not isF) and Question('Do you dislike long slow courtships? [Y/N] ')
    then begin
    Vote(N,-2);
    Vote(T,-2);
    end;

  if isN and isF and (not isT) and Question('Do you dislike long slow courtships? [Y/N] ')
    then begin
    Vote(I,-2);
    Vote(N,-2);
    Vote(F,-2);
    end;
end;

procedure SquareMate;
{ Raises all of the Mate's votes to the 1.5 power, thus increasing the
  distance between aspects;  this was done to reduce the number of
  X's that resulted due to round-off error }
begin
  with Mate do begin
    E := Trunc(Sqrt(E*E*E));
    I := Trunc(Sqrt(I*I*I));
    S := Trunc(Sqrt(S*S*S));
    N := Trunc(Sqrt(N*N*N));
    T := Trunc(Sqrt(T*T*T));
    F := Trunc(Sqrt(F*F*F));
    J := Trunc(Sqrt(J*J*J));
    P := Trunc(Sqrt(P*P*P));
    end;
end;

procedure PickWinner;
{ Finds the normalized MB values of the ideal mate }
begin
  SquareMate;
  with Mate do begin       { normalizes values }
    if E = I then begin
      E := 10;
      I := 10;
      end
    else if E > I then begin
      E := Round(E/(E+I)*20);
      I := 20 - E;
      end
    else begin
      I := Round(I/(E+I)*20);
      E := 20 - I;
      end;

    if S = N then begin
      S := 10;
      N := 10;
      end
    else if S > N then begin
      S := Round(S/(S+N)*20);
      N := 20 - S;
      end
    else begin
      N := Round(N/(S+N)*20);
      S := 20 - N;
      end;

    if T = F then begin
      T := 10;
      F := 10;
      end
    else if T > F then begin
      T := Round(T/(T+F)*20);
      F := 20 - T;
      end
    else begin
      F := Round(F/(T+F)*20);
      T := 20 - F;
      end;

    if J = P then begin
      J := 10;
      P := 10;
      end
    else if J > P then begin
      J := Round(J/(J+P)*20);
      P := 20 - J;
      end
    else begin
      P := Round(P/(J+P)*20);
      J := 20 - P;
      end;
  end; { with }
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
        Writeln('no parameter to use values in the file, ',TempFileName);
        Halt(1);
        end;
    end
  else begin
    if (Not GetValuesFromFile) then begin  { load values from file }
      TextColor(LightRed);
      GetValuesFromUser;
      end;
    end;

  Working;
  SetMastersFlags;
  InitializeMate;

  OppositeRules;
  ExtremeRules;
  EIRules;
  NSRules;
  TFRules;
  JPRules;
  TemperamentRules;

  PickWinner;
  MakeTypeString(MateTypeString, Mate);

  Assign(TempMateFile,TempMateFileName);
  Rewrite(TempMateFile);
  Writeln(TempMateFile,Name,' ',MateTypeString);
  if Female then Writeln(TempMateFile,'MALE')
            else Writeln(TempMateFile,'FEMALE');
  with Mate do
    Writeln(TempMateFile,E,' ',S,' ',T,' ',J);
  Close(TempMateFile);

  TextColor(LightCyan);
  ClrScr;
  Writeln('You are: ',MasterTypeString);
  TextColor(Cyan);
  WriteValues(Master);
  Writeln;
  TextColor(LightGreen);
  Writeln('The mate should be: ',MateTypeString);
  TextColor(Green);
  WriteValues(Mate);

  TextColor(White);
  Writeln;
  Writeln('Would you like a characters description of the typical ',MateTypeString,'? [Y/N]');
  Ch := YesNo;
  GotoXY(1,WhereY-1);
  Writeln(BlankLine);
  if Ch = 'Y' then begin
    SwapVectors;
    Exec('DESCRIBE.EXE',MateTypeString);
    SwapVectors;
    end;
end.
