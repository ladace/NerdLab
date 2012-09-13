define program
        [packageDefinition]
    |   [classDefinitionWithImport]
end define

keys
    import package
    class function var static
    public protected private
    if else while for
    null
end keys

compounds
    == != >= <=
    += -= *= /=
    || &&
end compounds

comments
    //
    /* */
end comments

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

include "expression.txl"

define packageDefinition
    'package [id?] '{
        [classDefinitionWithImport]
    '}
end define

define classDefinitionWithImport
    [importDeclaration*]
    [classDefinition]
end define

define importDeclaration
    'import [id] [dotLibField*] [dotStar?]';
end define

define dotLibField
    '. [id]
end define

define dotStar
    '. '*
end define

define classDefinition
    [modifiers?] 'class [id] '{
        [memberDefinition*]
    '}
end define

define memberDefinition
        [memberFuncDefinition]
    |   [memberVarDefinition]
end define

define memberFuncDefinition
    [modifiers?] 'function [id] ([formal,]) [typeDeclaration?] '{
        [statement*]
    '}
end define

define memberVarDefinition
    [modifiers?] [staticModifiers?] 'var [id] [typeDeclaration?] [evaluation?] ';
end define

define modifiers
        'public
    |   'protected
    |   'private
end define

define staticModifiers
    'static
end define

define typeDeclaration
    ': [id]
end define

define formal
    [id] [typeDeclaration?] [evaluation?]
end define

define statement
        [primaryStatement?]';
    |   [ifStatement]
end define

define primaryStatement
        [varDefinition]
    |   [assignment]
    |   [funcCall]
    |   [returnStatement]
end define

define varDefinition
    'var [id] [typeDeclaration?] [evaluation?]
end define

define assignment
    [leftValue] [evalop] [expression]
end define

define leftValue
    [attainField*] [id]
end define

define evaluation
    '= [expression]
end define

define funcCall
        [attainField?] [id] ([expression,])
    |   ([funcDefinition]) ([expression,])
end define

define funcDefinition
    'function [id?] ([formal,]) '{
        [statement?]
    '}
end define

define attainField
    [id] '.
end define

define primary
        [number]
    |   [stringlit]
    |   [attainField*] [id]
    |   'null
    |   [arraylit]
    |   [funcCall]
    |   [newInstance]
    |   ( [expression] )
end define

define newInstance
        'new [id] ([expression,])
    |   'new [id]
end define

define arraylit
    '[ [expression,] ']
end define

% some statement
define ifStatement
        'if ([expression]) '{
            [statement*]
        '} [elseStatement?]
    |   'if ([expression]) [statement]
        [elseStatement?]
end define

define elseStatement
        'else '{ [statement*] '}
    |   'else [statement]
end define

define returnStatement
    'return [expression]
end define

