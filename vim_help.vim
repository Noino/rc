                                =========================
                                =                       =
                                =       Vim help        =
                                =                       =
                                =========================

Custom keys
-----------

        F1              -   This help screen
        F3              -   Hide search highlighting
        F4              -   Toggle line numbers. Rotate; nonumbers -> numbers -> relativenumbers
        F5              -   Toggle auto indentation
        F7              -   Auto-format (indent) the whole file according to filetype
        F9              -   Enter insert in paste mode, toggle between paste and nopaste
        F12             -   Quit



Command-mode Commands
=====================

        Misc Commands
        -------------

        :q              -   Quit
        :w              -   Write
        :w!!            -   sudo write
        :wq             -   Write & Quit
        :q!             -   Force quit
        =               -   Auto-indent
        :set *          -   Set vi variable/attribute *
            opts list   -   http://vimdoc.sourceforge.net/htmldoc/options.html


        Commands to Insert Text
        -----------------------

        a               -   Append after the currect cursor position
        A               -   Append after end of current line
        i               -   Insert at current cursor position
        I               -   Insert at beginning of line
        o               -   Open a new line below the current line
        O               -   Open a new line above the current line (capital o)


        Cutting and Pasting Commands
        ----------------------------

        v               -   Enter visual mode (selection)
        Ctrl+v          -   Enter visual block mode (column selection)
        d               -   Cut selected text in -- VISUAL MODE --
        y               -   Copy selceted text in -- VISUAL MODE --
        Ctrl+y          -   Copy selected text to buffer file

        x               -   Cut the character at current cursor position
        dd              -   Cut the current line
        ndd             -   Cut the next 'n' lines, including the current line
        d$              -   Cut from the current position to the end of the current line
        yy              -   Copy the current line in normal mode
        nyy             -   Copy the next 'n' lines, including current line in normal mode
        p               -   Paste
        Ctrl+p          -   Paste content of the buffer file 


        Movement Commands
        -----------------

        0               -   Move to beginning of current line (zero)
        $               -   Move to the end of the current line
        b               -   Move backwards one word in the current file
        w               -   Move forward to the next word
        G               -   Move to the end of current file
        nG              -   Move to line 'n'


        ADVANCED SHIT
        ================

        "<char> + (cut/copy)    - Copy selected text into memory slot "<char>
        "<char> + (paste)       - Paste text from memory slot "<char>
        ''                      - Go to previous lineish
        m<char>                 - Set mark at line
        '<char>                 - Go to mark

        
        PLUGIN MAGIXS
        =================

        cursor on word:
        cs + <from> + <to>      - change surround
             t=htmltag
        viw                     - select word
        S + <input>             - surround selection with input
