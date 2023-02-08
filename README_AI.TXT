Information on CUPID                                Ray Zeisz

How does CUPID work?

    CUPID is a rule based expert system.  Listed below are some
rules used in finding a mate.  These rules are then quantitized
and used in a voting system.

    Some of the CUPID Rules:

    Opposites Types Attract
    Extreme Aspects Prefer Less Opposite in Aspect
    NT <-> NF
    SP <-> SJ
    NF open to sex -> SP
    NF not open to sex -> SJ
    extreme E -> slight E
    extreme I -> ENF, NF, NT-  (unvote for NT)
    extreme J -> J
    extreme P -> slight P
    IJ -> P
    EJ -> J
    ESP -> SJ-
    ISP -> SP, SJ
    INF dislikes long courtship -> NT-
    NT dislikes long courtship -> INF-
    extreme S -> slight S
    extreme N -> slight S
    extreme T -> slight T
    extreme F -> slight T
    worried about loosing mate -> I
    vivid imagination -> N
    usefulness -> S

    It works like this.  Each aspect E, I, S, N, T, F, J, and P
are "voted" for.  The rules are fired and each rule can add or
subtract votes for any number of aspects.  For example the rule
NF -> NT might add four votes to T aspect and one to the N.

    After all of the rules are fired, and any additional
questions answered, the votes are scaled to fall in a range of
zero to twenty.  Note that NONE of the questions ask about
preferences in mates; this would defeat the purpose of the
program.  Rather, one's answers and type imply what is preferred
in a mate.  There is where the real AI and a lot of thinking
about psychology come in.  (My best friend (who is female) talked
many many hours as to which rules are more important and about
our own preferences in hopes of making this program as accurate
as possible.)

    The scaled numbers represent an ideal mate.  But since there
are 160,000 different combinations, it is unlikely that anyone in
the data base is an exact match.  This is where FINDER comes in.


How does FINDER Work?

    FINDER is the second piece of AI found in the CUPID system.  
If performs a fuzzy search on the data base.

    Each record in the data base (for the correct sex) is
analyzed as follows.  Each of the type variables, E or I, S or N,
T or F, J or P is given a level of importance; a number between
1.0 and 2.0.  The variables, in order of importance are SN, JP,
TF, and EI.  This importance level is multiplied by the
absolute value of the difference between the record being
analyzed and the ideal mate.  This number (for each of the four
variables) is then squared and summed to the total for that
record.  Thus, each record is given a value based on the sum of
four squared numbers.  The record with the lowest score and any
records within 20 points from the low score are said to be
acceptable matches.

    This heuristic is based on the idea that someone who is
fairly close, but not exactly matching, in all four of the
aspects is a better match than someone with exact matches in
three of the aspects and completely wrong in the fourth.  The
squaring greatly amplifies these differences and makes them
unlikely matches.