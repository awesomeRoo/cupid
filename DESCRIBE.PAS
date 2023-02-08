{****************************************************************************}
{*                 EE 4524 Artificall Intelligence - Term Project           *}
{*                             CUPID Version 1.0                            *}
{*                                                                          *}
{*                                Ray Zeisz                                 *}
{*                            December 4, 1990                              *}
{****************************************************************************}
{* Module:      DESCRIBE.PAS                                                *}
{* Date:        December 2, 1990                                            *}
{* Function:    Gives a brief description of the various Myers-Briggs types *}
{*              and temperaments indicated on the command line.             *}
{* Usage:       DESCRIBE /f - the /f parameter causes the program to read   *}
{*              the CUPIDTMP.DAT file to find the Myers-Briggs type to      *}
{*              describe.                                                   *}
{*              DESCRIBE xxxx - where x is a valid Myers-Briggs type letter;*}
{*              will describe each type which matches the type given.  For  *}
{*              example DESCRIBE estx would descripbe both ESTJ and ESTP.   *}
{*                                                                          *}
{* File Usage:  CUPIDTMP.DAT may be used as input for the Myers-Briggs type.*}
{****************************************************************************}
program Describer;

uses
  Crt;

const
  TempFileName = 'CUPIDTMP.DAT';
  BlankLine    = '                                                                                ';

var
  Describe : array[0..15] of boolean;
  TypeDes  : array[0..15] of array[1..6] of string[80];
  TempDesc : array[0..3]  of boolean;
  TempDes  : array[0..3]  of array[1..11] of string[80];
  TempFile : text;
  Ch : char;
  Name,
  TypeString : string;
  i, j : integer;

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
  Writeln('  Myers-Briggs Type Describer');
  Writeln;
  qu := 0;
  repeat
    Delay(100);
    Inc(qu);
  until KeyPressed or (qu = 5);
  while KeyPressed do
    Ch := ReadKey;
end;

procedure InitTypeDes;
{ Stores all of the text so no external file is needed }
begin
  TypeDes[00][01] := 'I N F P    Questor                                             1 % of population';
  TypeDes[00][02] := '     Full of enthusiasms and loyalties, but seldom talk of these until they know';
  TypeDes[00][03] := 'you well.  Care about learning, ideas, language, and independent projects.  Do  ';
  TypeDes[00][04] := 'their own.  Tend to undertake too much, then somehow get it done.  Friendly, but';
  TypeDes[00][05] := 'often too absorbed in what they are doing to be sociable.  Little concern with  ';
  TypeDes[00][06] := 'possessions or physical surroundings.                                           ';

  TypeDes[01][01] := 'I N F J    Author                                              1 % of population';
  TypeDes[01][02] := '     Succeed by perseverance, originality and desire to do whatever is needed or';
  TypeDes[01][03] := 'wanted.  Put their best efforts into their work.  Quietly forceful,             ';
  TypeDes[01][04] := 'conscientious, concerned for others.  Respected for their firm principles.      ';
  TypeDes[01][05] := 'Likely to be honored and followed for their clear convictions as to how best to ';
  TypeDes[01][06] := 'serve the common good.                                                          ';

  TypeDes[02][01] := 'I N T P    Architect                                           1 % of population';
  TypeDes[02][02] := '     Quiet, reserved, impersonal.  Enjoy especially theoretical or scientific   ';
  TypeDes[02][03] := 'subjects.  Logical to the point of hair-splitting.  Usually interested mainly in';
  TypeDes[02][04] := 'ideas, with little liking for parties or small talk.  Tend to have sharply      ';
  TypeDes[02][05] := 'defined interests.  Need careers where some strong interest can be used and be  ';
  TypeDes[02][06] := 'useful.                                                                         ';

  TypeDes[03][01] := 'I N T J    Scientist                                           1 % of population';
  TypeDes[03][02] := '     Usually have original minds and great drive for their own ideas and        ';
  TypeDes[03][03] := 'purposes.  In fields that appeal to them, they have a fine power to organize    ';
  TypeDes[03][04] := 'a job and carry it through with or without help.  Skeptical, critical,          ';
  TypeDes[03][05] := 'independent, determined, often stubborn.  Must learn to yield to less important ';
  TypeDes[03][06] := 'points in order to win the most important.                                      ';

  TypeDes[04][01] := 'I S F P    Artist                                              5 % of population';
  TypeDes[04][02] := '     Retiring, quietly friendly, sensitive, kind, modest about their abilities. ';
  TypeDes[04][03] := 'Shun disagreements, do not force their opinions or values on others.  Usually do';
  TypeDes[04][04] := 'not care to lead but are often loyal followers.  Often relaxed about getting    ';
  TypeDes[04][05] := 'things done, because they enjoy the present moment and do not want to spoil it  ';
  TypeDes[04][06] := 'by undue haste or exertion.                                                     ';

  TypeDes[05][01] := 'I S F J    Conservator                                         6 % of population';
  TypeDes[05][02] := '     Quiet, friendly, responsible, and conscientious.  Work devotedly to meet   ';
  TypeDes[05][03] := 'their obligations.  Lend stability to any project or group.  Thorough,          ';
  TypeDes[05][04] := 'painstakingly accurate.  May need time to master technical subjects, as their   ';
  TypeDes[05][05] := 'interests are usually not technical.  Patient with detail and routine.  Loyal,  ';
  TypeDes[05][06] := 'considerate, concerned with how other people feel.                              ';

  TypeDes[06][01] := 'I S T P    Artisan/Craftsman                                   7 % of population';
  TypeDes[06][02] := '     Cool onlookers - quiet, reserved, observing and analyzing life with        ';
  TypeDes[06][03] := 'detached curiosity and unexpected flashes of original humor.  Usually interested';
  TypeDes[06][04] := 'in impersonal principles, cause and effect, how and why mechanical things work. ';
  TypeDes[06][05] := 'Exert themselves no more than they think necessary, because any waste of energy ';
  TypeDes[06][06] := 'would be inefficient.                                                           ';

  TypeDes[07][01] := 'I S T J    Trustee                                             6 % of population';
  TypeDes[07][02] := '    Serious, quiet, earn success by concentration and thoroughness.  Practical, ';
  TypeDes[07][03] := 'orderly, matter-of-fact, logical, realistic, and dependable.  See to it that    ';
  TypeDes[07][04] := 'everything is well-organized.  Take responsibility.  Make up their own minds as ';
  TypeDes[07][05] := 'to what should be accomplished and work toward it steadily, regardless of       ';
  TypeDes[07][06] := 'protests or distractions.                                                       ';

  TypeDes[08][01] := 'E N F P    Journalist                                          5 % of population';
  TypeDes[08][02] := '     Warmly enthusiastic, high-spirited, ingenious, imaginative.  Able to do    ';
  TypeDes[08][03] := 'almost anyhing that interests them.  Quick with a solution for any difficulty   ';
  TypeDes[08][04] := 'and ready to help anyone with a problem.  Often rely on their ability to        ';
  TypeDes[08][05] := 'improvise instead of preparing in advance.  Can usually find compelling reasons ';
  TypeDes[08][06] := 'for whatever they want.                                                         ';

  TypeDes[09][01] := 'E N F J    Pedagogue/Teacher                                   5 % of population';
  TypeDes[09][02] := '     Responsive and responsible.  Generally feel real concern for what others   ';
  TypeDes[09][03] := 'think or want, and try to handle things with due regard for other people''s      ';
  TypeDes[09][04] := 'feelings.  Can present a proposal or lead a group discussion with ease and tact.';
  TypeDes[09][05] := 'Sociable, popular, sympathetic.  Responsive to praise and criticism.            ';
  TypeDes[09][06] := '                                                                                ';

  TypeDes[10][01] := 'E N T P    Inventor                                            5 % of population';
  TypeDes[10][02] := '     Quick, ingenious, good at many things.  Stimulating company, alert and     ';
  TypeDes[10][03] := 'outspoken.  May argue for fun on either side of a question.  Resourceful in     ';
  TypeDes[10][04] := 'solving new and challenging problems, but may neglect routine assignments.      ';
  TypeDes[10][05] := 'Apt to turn to one new interest after another.  Skillful in finding logical     ';
  TypeDes[10][06] := 'reasons for what they want.                                                     ';

  TypeDes[11][01] := 'E N T J    Fieldmarshal                                        5 % of population';
  TypeDes[11][02] := '     Hearty, frank, decisive, leaders in activities.  Usually good in anything  ';
  TypeDes[11][03] := 'that requires reasoning and intelligent talk, such as public speaking.  Are     ';
  TypeDes[11][04] := 'usually well-informed and enjoy adding to their fund of knowledge.  May         ';
  TypeDes[11][05] := 'sometimes be more positive and confident than their experience in an area       ';
  TypeDes[11][06] := 'warrants.                                                                       ';

  TypeDes[12][01] := 'E S F P    Entertainer                                        13 % of population';
  TypeDes[12][02] := '     Outgoing, easygoing, accepting, friendly, enjoy everything and make things ';
  TypeDes[12][03] := 'more fun for others by their enjoyment.  Like sports and making things.  Know   ';
  TypeDes[12][04] := 'what''s going on and join in eagerly.  Find remembering facts easier than        ';
  TypeDes[12][05] := 'mastering theories.  Are best in situations that need sound common sense and    ';
  TypeDes[12][06] := 'practical ability with people as well as with things.                           ';

  TypeDes[13][01] := 'E S F J    Seller                                             13 % of population';
  TypeDes[13][02] := '     Warm-hearted, talkative, popular, conscientious, born cooperators, active  ';
  TypeDes[13][03] := 'committee members.  Need harmony and may be good at creating it.  Always doing  ';
  TypeDes[13][04] := 'something nice for someone.  Work best with encouragement and praise.  Little   ';
  TypeDes[13][05] := 'interest in abstract thinking or technical subjects.  Main interest is in things';
  TypeDes[13][06] := 'that directly and visibly affect people''s lives.                                ';

  TypeDes[14][01] := 'E S T P    Promotor                                           13 % of population';
  TypeDes[14][02] := '     Matter-of-fact, do not worry or hurry, enjoy whatever comes along.  Tend   ';
  TypeDes[14][03] := 'to like mechanical things and sports, with friends on the same side.  May be a  ';
  TypeDes[14][04] := 'bit blunt or insensitive.  Adaptable, tolerant, generally conservative in       ';
  TypeDes[14][05] := 'values.  Dislike long explanations.  Are best with real things that can be      ';
  TypeDes[14][06] := 'worked, handled, taken apart or put together.                                   ';

  TypeDes[15][01] := 'E S T J    Administrator                                      13 % of population';
  TypeDes[15][02] := '     Practical, realistic, matter-of-fact, with a natural head for business     ';
  TypeDes[15][03] := 'or mechanics.  Not interested in subjects they see no use for, but can apply    ';
  TypeDes[15][04] := 'themselves when necessary.  Like to organize and run activities.  May make good ';
  TypeDes[15][05] := 'administrators, especially if they remember to consider other''s feelings and    ';
  TypeDes[15][06] := 'point of view.                                                                  ';

  TempDes[00][01] := 'SP  The Dionysian Temperament                                 38 % of population';
  TempDes[00][02] := '    The SP must be free to do as he wishes when he wishes.  Impulsive, thrive on';
  TempDes[00][03] := 'situations where the outcome is unknown, exciting, optimistic, cheerful.  SPs   ';
  TempDes[00][04] := 'are able to handle discomfort well.  SPs have no desire for closure or          ';
  TempDes[00][05] := 'completion.  Although the SP is the master of the grand gesture - the dozen     ';
  TempDes[00][06] := 'roses or mink coat; he can forget a promised telephone call or neglect a small  ';
  TempDes[00][07] := 'word of affection.  An SP may be seen as a bedroom virtuoso who voices an avid  ';
  TempDes[00][08] := 'interest in experimentation.  SPs may at times be unware or potential dangers   ';
  TempDes[00][09] := 'in their relationships; they tend to rush in where angels feared to tread -     ';
  TempDes[00][10] := 'sexually, socially, and economically.  Have an strong feeling that living is to ';
  TempDes[00][11] := 'be enjoyed.  Variety in all things is likely to appeal to the SP.               ';

  TempDes[01][01] := 'SJ  The Epimethean Temperament                                38 % of population';
  TempDes[01][02] := '    The SJ tends to be bound and obligated in anything he takes on.  The SJ must';
  TempDes[01][03] := 'have a feeling of membership to be completely happy.  SJs tend to worry about   ';
  TempDes[01][04] := 'things, too much sometimes.  Society''s natural historians, and caretakers.  The ';
  TempDes[01][05] := 'SJ is a stabilizer of the social and economic world, not to do one''s duty is    ';
  TempDes[01][06] := 'offensive to the SJ.  More solemn about their sexual activities; sex is serious.';
  TempDes[01][07] := 'SJs need to be of service and to belong to established institutions; faithful,  ';
  TempDes[01][08] := 'steady, responsible, reliable mates who are predictable and dependable.  SJs may';
  TempDes[01][09] := 'have trouble understanding the emotional needs of other types especially NFs and';
  TempDes[01][10] := 'NTs.  An SJ could give way to biting criticizime and then expect a mate to      ';
  TempDes[01][11] := 'separate these behaviors from the sexuall relationship.                         ';

  TempDes[02][01] := 'NT  The Promethean Temperament                                12 % of population';
  TempDes[02][02] := '    Power over nature fascinates the NT; to be able to understand, control and  ';
  TempDes[02][03] := 'predict realities.  Scratch an NT and find a scientist.  NTs become upset with  ';
  TempDes[02][04] := 'statements of the obvious.  NTs tend not to communicate as well as the other    ';
  TempDes[02][05] := 'temperaments; this could be due to the fact that NTs are so rare.  Unfortunatly,';
  TempDes[02][06] := 'the NT may project a sense to those around him that they are intellectually     ';
  TempDes[02][07] := 'inadequate.  Because the NT is so serios about the knowledge he must have to be ';
  TempDes[02][08] := 'competent, he does, in fact, frequently gain outstanding proficiency in his     ';
  TempDes[02][09] := 'field.  NTs are not affectionate in public, nor are they playfull outside of the';
  TempDes[02][10] := 'bedroom.  They tend to have a dry sense of humor also.  NTs tend to develop     ';
  TempDes[02][11] := 'intimate relationships slowly, but are responsible in their family matters.     ';

  TempDes[03][01] := 'NF  The Apollonian Temperament                                12 % of population';
  TempDes[03][02] := '    The NF is often found asking, "How can I become the person I really am?"    ';
  TempDes[03][03] := 'The NFs search for oneself is circular, thus perpetual.  Living a life of       ';
  TempDes[03][04] := 'significance, making a difference in the world, this will satisfy the NF''s      ';
  TempDes[03][05] := 'hunger for unique identity. NFs tend to romanticize their experiences and lives.';
  TempDes[03][06] := 'NFs prefer the word love over sex.  They are romantic and good communicators.   ';
  TempDes[03][07] := 'Often the NF feels that there is only one true love in a lifetime; this may     ';
  TempDes[03][08] := 'cause the NF to always wonder if things would have been better with a different ';
  TempDes[03][09] := 'mate.  NFs are likely to be charming mates, and a source of continuing warmth   ';
  TempDes[03][10] := 'and support.  NFs are probably the most loving, dedicated, affectionate mates.  ';
  TempDes[03][11] := 'The NF can be extravagent and symbolic in expressing love in private.           ';
end;

function ValidType(var s : string): boolean;
{ Returns TRUE if s is a valid Myers-Briggs type, eg. INFP or ESTX }
begin
  s[1] := UpCase(s[1]);
  s[2] := UpCase(s[2]);
  s[3] := UpCase(s[3]);
  s[4] := UpCase(s[4]);
  if (Not (s[1] IN ['E','I','X'])) OR
     (Not (s[2] IN ['S','N','X'])) OR
     (Not (s[3] IN ['T','F','X'])) OR
     (Not (s[4] IN ['J','P','X']))
  then ValidType := False
  else ValidType := True;
end;

procedure SeparateTypes(s : string);
{ Sets the flags for the appropriate types to be describe. eg. ESTX needs
  to describe ESTJ AND ESTP }
begin
  for i := 0 to 15 do
    Describe[i] := True;

  if s[1] <> 'X' then
    if s[1] = 'I' then
      for i := 8 to 15 do
        Describe[i] := False
    else
      for i := 0 to 7 do
        Describe[i] := False;

  if s[2] <> 'X' then
    if s[2] = 'N' then begin
      for i := 4 to 7 do
        Describe[i] := False;
      for i := 12 to 15 do
        Describe[i] := False;
      end
    else begin
      for i := 0 to 3 do
        Describe[i] := False;
      for i := 8 to 11 do
        Describe[i] := False;
      end;

  if s[3] <> 'X' then
    if s[3] = 'F' then begin
      Describe[2] := False;
      Describe[3] := False;
      Describe[6] := False;
      Describe[7] := False;
      Describe[10]:= False;
      Describe[11]:= False;
      Describe[14]:= False;
      Describe[15]:= False;
      end
    else begin
      Describe[0] := False;
      Describe[1] := False;
      Describe[4] := False;
      Describe[5] := False;
      Describe[8] := False;
      Describe[9] := False;
      Describe[12]:= False;
      Describe[13]:= False;
      end;

  if s[4] <> 'X' then
    if s[4] = 'P' then begin
      Describe[1] := False;
      Describe[3] := False;
      Describe[5] := False;
      Describe[7] := False;
      Describe[9] := False;
      Describe[11]:= False;
      Describe[13]:= False;
      Describe[15]:= False;
      end
    else begin
      Describe[0] := False;
      Describe[2] := False;
      Describe[4] := False;
      Describe[6] := False;
      Describe[8] := False;
      Describe[10]:= False;
      Describe[12]:= False;
      Describe[14]:= False;
      end;

  for i := 0 to 3 do        { SP SJ NT NF }
    TempDesc[i] := False;
  if (s[2] IN ['S','X']) and (s[4] in ['P','X']) then TempDesc[0] := True;
  if (s[2] IN ['S','X']) and (s[4] in ['J','X']) then TempDesc[1] := True;
  if (s[2] IN ['N','X']) and (s[3] in ['T','X']) then TempDesc[2] := True;
  if (s[2] IN ['N','X']) and (s[3] in ['F','X']) then TempDesc[3] := True;
end;

function YesNo: char;
{ Returns TRUE if a 'y' is pressed; ignores all other letters and case }
var
  c : char;
begin
  repeat
    c := UpCase(ReadKey);
  until (c = 'Y') or (c = 'N');
  YesNo := c;
end;

begin    { main }
  Intro;
  Name := '';
  TypeString := '';

  if (ParamCount = 1) and ((ParamStr(1) = '/F') or (ParamStr(1) = '/f')) then begin
    {$I-}
    Assign(TempFile,TempFileName);
    Reset(TempFile);
    Readln(TempFile, Name);
    Readln(TempFile, TypeString);
    Close(TempFile);
    {$I+}
    if IOResult <> 0 then begin
      TextColor(LightRed);
      Writeln('Error reading Cupid Temporary File: ',TempFileName);
      Writeln;
      Halt(1);
      end;
    end
  else if ParamCount < 1
    then TypeString := '    '
    else TypeString := ParamStr(1);

  if Not ValidType(TypeString) then begin
    TextColor(LightRed);
    Writeln('Invalid type encountered: ',TypeString);
    Writeln;
    TextColor(White);
    Writeln('Please specify a valid Myers-Briggs type on the command line.');
    Writeln('Valid types are: INFP INFJ INTP INTJ ISFP ISFJ ISTP ISTJ');
    Writeln('                 ENFP ENFJ ENTP ENTJ ESFP ESFJ ESTP ESTJ');
    Halt(1);
    end;

  SeparateTypes(TypeString);

  TextColor(LightGreen);
  Writeln('Description for ',Name,'  ',TypeString);
  Writeln;

  InitTypeDes;

  for i := 0 to 15 do
    if Describe[i] then begin
      TextColor(White);
      Write(TypeDes[i][1]);
      TextColor(LightCyan);
      for j := 2 to 6 do
        Write(TypeDes[i][j]);
      Writeln;
      TextColor(Cyan);
      Write('Press any key...');
      Ch := ReadKey;
      GotoXY(1,WhereY);
      Write(BlankLine);
      GotoXY(1,WhereY-1);
      end;

  for i := 0 to 3 do
    if TempDesc[i] then begin
      TextColor(Yellow);
      Write(TempDes[i][1]);
      TextColor(LightCyan);
      for j := 2 to 11 do
        Write(TempDes[i][j]);
      Writeln;
      TextColor(Cyan);
      Write('Press any key...');
      Ch := ReadKey;
      GotoXY(1,WhereY);
      Write(BlankLine);
      GotoXY(1,WhereY-1);
      end;
end.
