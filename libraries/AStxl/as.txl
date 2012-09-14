include "as.grm"

rule main
    replace [classDefinition]
        C [classDefinition]
    construct newC [classDefinition]
        C
    where not
        newC [= C]
    by
        newC
end rule
