
rule main
    replace [classDefinition]
        C [classDefinition]
    construct newC [number]
        1
    where not
        newC [= C]
    by
        newC
end rule
