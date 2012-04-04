the zen of c
============

c has always had a special place in my heart, probably due to the fact
that i started doing assembly at a young age (even if i didn't keep up on
it). i was later exposed to c, although i didn't start writing anything serious
until my 20s. what stuck with me was how intimate c is with the hardware, and
it is from c that i began to understand what i call the first axiom of 
computation: all of computation is simply the structure and interpretation of
data.

what i'd like to write about now are some of the things i've been learning as i
look back on my progress over the past couple of years. in 2011, i started a
job writing c and doing security auditing. as a beginning c coder, this
was immensely useful for learning to code better. i began to write a lot more
code, and i learned several langauges decently well.

i'd like to compare two examples from knr. in january 2011, a buddy of mine and
i decided to get together to work through the examples in knr. i'd never
bothered with the exercises before, so this would be interesting. as both of
us weren't new to c programming, we decided to skip the in-chapter problems and
jump straight to the end of the chapter, namely to the detab program. the
premise of detab is quite simple: convert tabs in the input to spaces in the
output. as the age-old adage goes, a litle knowledge is a dangerous thing and
i think you will see quite clearly that i fell into this trap.

what's interesting to note is we never finished knr that time. i think the 
attempt lasted less than a week.

so, here is my january 19, 2011 (according to the git logs) version of detab:

detab.h:

    /**************************************************************************
     * detab.h                                                                *
     * 4096R/B7B720D6  "Kyle Isom <coder@kyleisom.net>"                       *
     * 2011-01-18                                                             *
     *                                                                        *
     * knr exercise 1-20                                                      *
     *                                                                        *
     * detab replaces tabs in the input with the proper number of spaces.     *
     *                                                                        *
     **************************************************************************/
    
    #include <stdlib.h>     /* for size_t */
    
    /***********/
    /* defines */
    /***********/
    
    #define     TABSTOP         4
    #define     INPUT_SIZE      110     /* number of chars for input */
    
    
    /***********/
    /* structs */
    /***********/
    
    struct string {
        char *data;     /*  character buffer  */
        size_t nm;      /* number of members  */
        size_t pos;     /* position in buffer */
    };
    
    typedef struct string string_t; 
    
    
    /***********************/
    /* function prototypes */
    /***********************/
    
    /* lookahead: check the next character in the string to look for a specific
     * character.
     *      arguments:  string_t containing the string to search
     *                  char containing the target character to find
     *                  int set to nonzero if the position should be updated
     *      returns: EXIT_SUCCESS if the character was found
     *               EXIT_FAILURE if the character was not found
     */
    int lookahead(string_t *buf, char target, int update);
    
    void string_init(string_t *buffer, size_t nm);
    int sub_tabs(string_t *buf, size_t index, size_t tab_n) ;
    
    
detab.c:

    /**************************************************************************
     * detab.c                                                                *
     * 4096R/B7B720D6  "Kyle Isom <coder@kyleisom.net>"                       *
     * 2011-01-18                                                             *
     *                                                                        *
     * knr exercise 1-20                                                      *
     *                                                                        *
     * detab replaces tabs in the input with the proper number of spaces.     *
     *                                                                        *
     **************************************************************************/
    
    #include <stdlib.h>
    #include <stdio.h>
    
    #include "detab.h"
    
    int main(int argc, char **argv) {
        string_t *buffer = calloc(1, sizeof *buffer);
        string_init(buffer, INPUT_SIZE);
        size_t cur = 0;
        size_t tab = 0;
    
        printf("input> ");
        fgets(buffer->data, INPUT_SIZE - 1, stdin);
    
        while ('\x00' != buffer->data[buffer->pos]) {
            printf("pos: %u char: 0x%x\n", (unsigned int) buffer->pos,
                   (unsigned int) buffer->data[buffer->pos]);
            if ('\t' == buffer->data[buffer->pos] ) { 
                cur = buffer->pos;
                tab++; 
                while (EXIT_SUCCESS == lookahead(buffer, '\t', 1)) {
                    tab++;
                }
            }
    
            if (tab) {
                if (! sub_tabs(buffer, cur, tab)) { }
            }
            buffer->pos++;
        }
    
        printf("%u tabs detected...\n", (unsigned int) tab);
    
        return EXIT_SUCCESS;
    }
    
    
    /* int lookahead() */
    int lookahead(string_t *buf, char target, int update) {
        int result = EXIT_FAILURE;
        if ( buf->pos < (buf->nm - 1) ) { 
            if ( buf->data[buf->pos + 1] == target ) { 
                printf("lookahead: success!\n");
                result = EXIT_SUCCESS;
            } else {
                printf("lookahead: failed!\n");
            }
    
            if (update) { 
                printf("update fired!\n");
                buf->pos++; 
            }
        }
    
        return result;
    }
    
    void string_init(string_t *buffer, size_t nm) {
        buffer->data = calloc(nm, sizeof *buffer->data);
        buffer->nm   = nm;
        buffer->pos  = 0;
    }
    
    int sub_tabs(string_t *buf, size_t index, size_t tab_n) {
        return 0;
    }
    
what i find quite telling is that i have a file called `detab.design` in the
directory:

    design notes for detab:
    
    1. would it be easier to scan L->R or R->L?
    2. how to handle increased size of set?
    3. use struct string
    4. inserting in
    
    
    
    lookahead: 
        check to see if the next character matches the current character
    
lookaheads and structs and scanning and holy shit, batman, this quickly
degenerates into quite the mess. no wonder it was never finished. see, what
i think i got into here was overthinking: i even started my own string
implementation, a sure sign of trouble. the fact that i needed a design document
for such a simple program is another red flag.

just for kicks, i decided to run david a. wheeler's
[sloccount](http://dwheeler.com/sloccount) program to estimate the cost of
this code. this is the result:

    Totals grouped by language (dominant language first):
    ansic:           64 (100.00%)
    
    Total Estimated Cost to Develop                           = $ 1,507
    
the metrics are debatable, but this will become interesting later.

fast-forward to late march, early april of 2012. this was a time where i very
much hated my life, and i used c to relieve stress and keep my mind focused.
i decided to finish what i had started and work through the exercises, but this
time i would work through all them. here is the final version of detab:

    /**********************************************************************
     * file: chapter01/detab.c                                            *
     * author: kyle isom <coder@kyleisom.net                              *
     *                                                                    *
     * Exercise 1.20:                                                     *
     * =============                                                      *
     * Write a program detab that replaces tabs in the input with the     *
     * proper number of blanks to space to the next tab stop. Assume a    *
     * fixed set of tab stops, say every n columns. Should n be a variable*
     * or a symbolic parameter?                                           *
     **********************************************************************/
    
    #include <stdio.h>
    
    #define MAXLINE     1000
    #define TABSTOP     4
    
    int
    main(void)
    {
        int c, i;
    
        while ((c = getchar()) != EOF) {
            if (c == '\t') {
                for (i = 0; i < TABSTOP; ++i)
                    printf("%c", 0x20);
            } else {
                printf("%c", c);
            }
        }
    }
    
notice how much simpler this is - no lookaheads, no structs. in fact, this only
uses two ints for storage, requiring far less resources than the last attempt
did. the whole program is damn simple. this may be as close to bugless software
as i will ever get. let's compare the output of `sloccount` on this:

    Totals grouped by language (dominant language first):
    ansic:           16 (100.00%)
    
    Total Estimated Cost to Develop                           = $ 352

this has literally a quarter of the lines of code, works, is easy to 
understand, and is complete. remember that the previous version of detab
wasn't even finished. the sloccount output here is interesting - depending on
how you interpret the results, fewer lines of code results in lower costs or
more lines of code results in a more valuable codebase (because you invested
more in developing it). any developer worth a damn can tell you the second
is patently false, but how many civilians / suits think like that? 

so, lessons learned:

* simplicity over complexity
* don't over engineer



2011.04.03
