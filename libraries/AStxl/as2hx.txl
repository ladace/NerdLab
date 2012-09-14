include "haxeAddons.grm"

rule main
    replace [program]
        C [program]
    construct newC [program]
        C [classConstructorReplace] [castFix] [reflectNewInstanceFix] [reflectNewInstanceFixWithoutArgs]
    where not
        newC [= C]
    by
        newC
end rule

rule classConstructorReplace
    replace $ [classDefinition]
        C [classDefinition]
    deconstruct * [classHeader] C
        _ [modifiers] 'class Name [id]
    by
        C [constructorReplace Name]
end rule

rule constructorReplace Name [id]
    replace $ [memberFuncHeader]
        Modifiers [modifiers] 'function Name (Formals[formalList])
    by
        Modifiers 'function 'new (Formals)
end rule

rule castFix
    replace [funcCall]
        ClassName [id] (arg[expression])
    construct first [id]
        ClassName [: 1 1]
    where all
        ClassName [>= "A"] [<= "Z"]
    by
        cast (arg, ClassName)
end rule

rule reflectNewInstanceFix
    replace [funcCall]
        'new ClassObject [id] (Args [expression,])
    construct first [id]
        ClassObject [: 1 1]
    where all
        ClassObject [>= "a"] [<= "z"]
    by
        Type'.createInstance(classObject, '[Args'])
end rule

rule reflectNewInstanceFixWithoutArgs
    replace [funcCall]
        'new ClassObject [id]
    construct first [id]
        ClassObject [: 1 1]
    where all
        ClassObject [>= "a"] [<= "z"]
    by
        Type'.createInstance(ClassObject, '['])
end rule
