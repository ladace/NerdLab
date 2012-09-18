include "haxeAddons.grm"

rule main
    replace $ [program]
        C [program]
    construct newC [program]
        C [replaceKey 'Number 'Float] [replaceKey 'void 'Void] [replaceKey 'int 'Int] [replaceKey 'uint 'UInt] [replaceKey 'Function 'Dynamic]
        [classConstructorReplace] [castFix] [castAsFix] [reflectNewInstanceFix] [reflectNewInstanceFixWithoutArgs] [addConstructorSuper] [moveMemberVarInit] [isInstanceFix] [newFix]
        [generateClassDefFile] [generateTypeUsedFile] [generateImportStarLines]
    where not
        newC [= C]
    by
        newC
end rule

rule replaceKey T [id] N [id]
    replace [id]
        T
    by
        N
end rule

rule classConstructorReplace
    replace $ [classDefinition]
        C [classDefinition]
    deconstruct * [classHeader] C
        _ [modifier?] 'class Name [id]
    by
        C [constructorReplace Name]
end rule

rule constructorReplace Name [id]
    replace $ [memberFuncHeader]
        Modifiers [modifiers?] 'function Name (Formals[formalList])
    by
        Modifiers 'function 'new (Formals)
end rule

rule castFix
    replace [funcCall]
        ClassName [id] (Arg [expression])
    construct first [id]
        ClassName [: 1 1]
    where all
        ClassName [>= "A"] [<= "Z"]
    by
        cast (Arg, ClassName)
end rule

rule castAsFix
    replace [expression]
        E [expression] 'as Class [id]
    by
        cast(E, Class)
end rule

rule reflectNewInstanceFix
    replace [primary]
        'new ClassObject [id] (Args [expression,])
    construct first [id]
        ClassObject [: 1 1]
    where all
        ClassObject [>= "a"] [<= "z"]
    by
        Type'.createInstance(classObject, '[Args'])
end rule

rule reflectNewInstanceFixWithoutArgs
    replace [primary]
        'new ClassObject [id]
    construct first [id]
        ClassObject [: 1 1]
    where all
        ClassObject [>= "a"] [<= "z"]
    by
        Type'.createInstance(ClassObject, '['])
end rule

rule addConstructorSuper
    replace [memberFuncDefinition]
        M [modifiers?] 'function 'new (F [formalList]) Body [memberFuncBody]
    deconstruct not * [statement] Body
        super Args [arguments] ';
    deconstruct Body
        '{
            Stats [statement*]
        '}
    by
        M 'function 'new (F) '{ 
            super() ';
            Stats 
        '}
end rule

rule moveMemberVarInit
    replace [classBody]
        Body [classBody]
    deconstruct * [memberVarDefinition] Body
        M [modifiers?] 'var Name [id] T [typeDeclaration] Eval [evaluation] ';
    by
        Body [removeInit Name] [addInit Name Eval]
end rule

function removeInit Name [id]
    replace * [memberVarDefinition]
        M [modifiers?] 'var Name T [typeDeclaration] Eval [evaluation] ';
    by
        M 'var Name T ';
end function

function addInit Name [id] Eval [evaluation]
    replace * [memberFuncDefinition]
        M [modifiers?] 'function 'new (F [formalList]) '{
            Stats [statement*]
        '}
    deconstruct Eval
        '= E [expression]
    by
        M 'function 'new (F) '{
            Name '= E ';
            Stats
        '}
end function

rule isInstanceFix
    replace [expression]
        E [expression] 'is C [id]
    by
        Std '. is(E, C)
end rule

rule newFix
    replace [newInstance]
        'new C [id]
    by
        'new C ()
end rule

define varEntry
    [id] ': [type]
end define

rule generateClassDefFile
    replace $ [memberVarDefinition]
        M [memberVarDefinition]
    deconstruct M
        MD [modifiers?] 'var Name [id] ': T [type]';
    construct V [varEntry]
        Name ': T 
    construct _ [varEntry]
        V [fput "class.def"]
    by
        M
end rule

rule generateTypeUsedFile
    replace $ [type]
        T [type]
    by
        T [fput "types.used"]
end rule

rule generateImportStarLines
    replace $ [importDeclaration]
        'import A [id] B [dotLibField*] C [dotStar] ';
    construct I [importDeclaration]
        'import A B C ';
    by
        I [fput "import.stars"]
end rule
