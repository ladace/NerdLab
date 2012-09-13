define expression
        [arithExp]
    |   [expression] [compop] [arithExp]
    |   [expression] [logicop] [arithExp]
    |   [questionExp]
end define

define arithExp
        [term]
    |   [arithExp] [addop] [term]
end define

define term
        [primary]
    |   [term] [mulop] [primary]
end define

define questionExp
    [expression] '? [expression] ': [expression]
end define

define addop
        '+
    |   '-
end define

define mulop
        '*
    |   '/
end define

define compop
        '==
    |   '!=
    |   '>=
    |   '<=
end define

define evalop
        '=
    |   '+=
    |   '-=
    |   '*=
    |   '/=
end define

define logicop
        '||
    |   '&&
end define
