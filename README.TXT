Welcome to CUPID                                    Ray Zeisz

Introduction

    This is Computer Programmed Intelligent Dating.  Research by
Isabell Myers has found that we each have a certain personality
temperament, and this temperament can be found and quantitized by
answering question about one's preferences.  The Myers-Briggs
Type Indicator was developed just for that purpose.  Much
research has been done in what the various types look for in
mates.  Surprisingly, opposite (or complement) types are
attracted.  This program attempts to find a user's type and then
calculate which type the user is best suited to date.  There is
NOT a one to correspondence between opposites.  Many rules have
been developed to handle many different situations.  

    There are sixteen basic types.  They are named by four-letter
names such as INFP of ENTJ.  The first letter (E or I) measures
Extraversion vs. Introversion.  The second letter (S or N)
measures Sensation vs. iNtutition.  The third (T or F) measures
Thinking vs. Feeling.  And the fourth (J or P) measures Judging
vs. Perceiving.  There are also four temperaments, one of which
each person has.  They are NT, NF, SP, and SJ.  These factors are
also taken into account when looking for a mate, although not as
strongly as the types.

    This program is not to be used to find the perfect mate.  It
is possible that a mate of completely different type than that
suggested by CUPID is a great mate; however, if you find a mate
with the Myers-Briggs values that are indicated as the ideal
mate, this person will most probably be an excellent mate.

    This brings up an important point.  While opposites attract,
so do birds of a feather flock together.  This is not a paradox
as it might at first seem.  The fact is that opposite types are
most definitely attracted, but people with SIMILAR interest are
also attracted.  You may find a mate that is exactly what CUPID
says is your ideal, but if you love to scuba dive and visit Rio,
and the mate is afraid of water and like Kansas, then obviously
there will be some problems, (starting with where to go on the
honeymoon.)

    This program does not take into account the interests, since
only a simple matching algorithm is needed to find similar
people.  However, to find a ideally typed mate, about forty rules
are used in an extensive heuristic.

    A real computer dating program (CUPID 2.0?) should not only
find mates based on the Myers-Briggs type, but also on interests,
hobbies, educational background, personal appearance, and
personal preferences.  These items should be MATCHED as closely
as possible.



Usage of CUPID

    To begin, you may invoke the complete CUPID system by running
RUNME.BAT; however, if you wish only to use a part of the system,
it has been designed with modularity and instructions follow.

INTRO.EXE
    This program simply displays an introduction logo.

FINDTYPE.EXE
    This program runs the Myers-Briggs type indicator.  The
program will ask for some simple personal data, then seventy
questions about your personality.  A type will be determined and
your data added to the data base of prospective mates.

DESCRIBE.EXE
    This program will simply describe the typical Myers-Brigs
type that you request information about.
    For example, DESCRIBE ESTJ would give a character description
for an average ESTJ.  DESCRIBE ESTX would describe both ESTJ and
ESTP.  DESCRIBE XXXX would describe all sixteen different types.
    Also, the /f parameter used with this program will describe
the type of the person to last run FINDTYPE.EXE.

CUPID.EXE
    The soul of the dating program.  This program will ask a few
more questions of the user to find exactly what the ideal mate
would be given a certain type.
    The ? parameter will allow for the type to be specified via
the keyboard.  If no ? parameter is used, then the default is the
type that last ran the FINDTYPE program.
    This program does not actually look for a mate, but rather,
calculates the values of the ideal mate.

FINDER.EXE
    This program performs a heuristic search of the data base to
find the person closest to your ideal mate, and opposite in sex.
    This is a difficult task, and it is very unlikely that a
perfect match will exist in the data base since there are 160,000
different combinations of types.
    A file is generated which has the names and data for all
mates that appear to be good matches.
    A ? parameter may be specified to enter the values of the
ideal mate from the keyboard rather than the defaults found in
the mate file.


For details on how the program calculates mates and searches the
data base, please read the file README.AI


For more information on the Myers-Briggs test, see:

Please Understand Me; David Keirsey; INTJ Books, Solana Beach CA.
Library of Congress BF 698 K357 1984
