/*******************************************************************************
 * Copyright (c) 2010 Willink Transformations and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v2.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v20.html
 *
 * Contributors:
 *     E.D.Willink - initial API and implementation
 *******************************************************************************/
grammar Base;

// Converted from Base.xtext
// Naming: parser=lowerCamelCase, lexer=UPPER_SNAKE_CASE

// from: MultiplicityBoundsCS
// returns MultiplicityBoundsCS
multiplicityBoundsCs:
    lower ('..' upper)?
    ;

// from: MultiplicityCS
// returns MultiplicityCS
multiplicityCs:
    '[' (multiplicityBoundsCs | multiplicityStringCs) ('|?' | '|1')? ']'
    ;

// from: MultiplicityStringCS
// returns MultiplicityStringCS
multiplicityStringCs:
    ('*'|'+'|'?')
    ;

// from: PathNameCS
// returns PathNameCS
pathNameCs:
    firstPathElementCs ('::' nextPathElementCs)*
    ;

// from: UnreservedPathNameCS
// returns PathNameCS
unreservedPathNameCs:
    nextPathElementCs ('::' nextPathElementCs)*
    ;

// from: FirstPathElementCS
// returns PathElementCS
firstPathElementCs:
    unrestrictedName /* xref: pivot::NamedElement */
    ;

// from: NextPathElementCS
// returns PathElementCS
nextPathElementCs:
    unreservedName /* xref: pivot::NamedElement */
    ;

// from: TemplateBindingCS
// returns TemplateBindingCS
templateBindingCs:
    templateParameterSubstitutionCs (',' templateParameterSubstitutionCs)* (multiplicityCs)?
    ;

// from: TemplateParameterSubstitutionCS
// returns TemplateParameterSubstitutionCS
templateParameterSubstitutionCs:
    typeRefCs
    ;

// from: TemplateSignatureCS
// returns TemplateSignatureCS
templateSignatureCs:
    '(' typeParameterCs (',' typeParameterCs)* ')'
    ;

// from: TypeParameterCS
// returns TypeParameterCS
typeParameterCs:
    unrestrictedName
    	('extends' typedRefCs ('&&' typedRefCs)*)?
    ;

// from: TypeRefCS
// returns TypeRefCS
typeRefCs:
    typedRefCs | wildcardTypeRefCs
    ;

// from: TypedRefCS
// returns TypedRefCS
typedRefCs:
    typedTypeRefCs
    ;

// from: TypedTypeRefCS
// returns TypedTypeRefCS
typedTypeRefCs:
    pathNameCs ('(' templateBindingCs ')')?
    ;

// from: UnreservedName
// returns ecore::EString
unreservedName:
    // Intended to be overridden
    	unrestrictedName
    ;

// from: UnrestrictedName
// returns ecore::EString
unrestrictedName:
    // Intended to be overridden
    	identifier
    ;

// from: WildcardTypeRefCS
// returns WildcardTypeRefCS
wildcardTypeRefCs:
    /* action: WildcardTypeRefCS */  '?' ('extends' typedRefCs)?
    ;

// from: ID
id:
    SIMPLE_ID | ESCAPED_ID
    ;

// from: Identifier
identifier:
    id
    ;



/* A lowerbounded integer is used to define the lowerbound of a collection multiplicity. The value may not be the unlimited value. */

// from: LOWER
// returns ecore::EInt
lower:
    INT
    ;



/* A number may be an integer or floating point value. The declaration here appears to be that for just an integer. This is to avoid
 * lookahead conflicts in simple lexers between a dot within a floating point number and the dot-dot in a CollectionLiteralPartCS. A
 * practical implementation should give high priority to a successful parse of INT ('.' INT)? (('e' | 'E') ('+' | '-')? INT)? than
 * to the unsuccessful partial parse of INT '..'. The type of the INT terminal is String to allow the floating point syntax to be used.
 */

// from: NUMBER_LITERAL
// returns BigNumber
numberLiteral:
    // Not terminal to allow parser backtracking to sort out "5..7"
    	INT
    ;

 // EssentialOCLTokenSource pieces this together ('.' INT)? (('e' | 'E') ('+' | '-')? INT)?;

// from: StringLiteral
stringLiteral:
    SINGLE_QUOTED_STRING
    ;



/* An upperbounded integer is used to define the upperbound of a collection multiplicity. The value may be the unlimited value. */

// from: UPPER
// returns ecore::EInt
upper:
    INT | '*'
    ;

// from: URI
uri:
    SINGLE_QUOTED_STRING
    ;

// from: ESCAPED_CHARACTER
fragment ESCAPED_CHARACTER:
    '\\' ('b' | 't' | 'n' | 'f' | 'r' | 'u' | '"' | '\'' | '\\')
    ;

// from: LETTER_CHARACTER
fragment LETTER_CHARACTER:
    'a'..'z' | 'A'..'Z' | '_'
    ;

// from: DOUBLE_QUOTED_STRING
DOUBLE_QUOTED_STRING:
    '"' (ESCAPED_CHARACTER | ~('\\' | '"'))* '"'
    ;

// from: SINGLE_QUOTED_STRING
SINGLE_QUOTED_STRING:
    '\'' (ESCAPED_CHARACTER | ~('\\' | '\''))* '\''
    ;

// from: ML_SINGLE_QUOTED_STRING
ML_SINGLE_QUOTED_STRING:
    '/' '\'' .*? '\'' '/'
    ;

// from: SIMPLE_ID
SIMPLE_ID:
    LETTER_CHARACTER (LETTER_CHARACTER | ('0'..'9'))*
    ;

// from: ESCAPED_ID
ESCAPED_ID:
    '_' SINGLE_QUOTED_STRING
    ;

// from: INT
INT:
    // String to allow diverse re-use
    	('0'..'9')+
    ;

		// multiple leading zeroes occur as floating point fractional part

/* A multi-line comment supports a comment that may span more than one line using familiar slash-star...star-slash comment delimiters */

// from: ML_COMMENT
ML_COMMENT:
    '/*' .*? '*/' -> skip
    ;



/* A single-line comment supports a comment that terminates at the end of the line */

// from: SL_COMMENT
SL_COMMENT:
    '--' ~('\n' | '\r')* ('\r'? '\n')? -> skip
    ;



/* Whitespace may occur between any pair of tokens */

// from: WS
WS:
    (' ' | '\t' | '\r' | '\n')+ -> skip
    ;

// from: ANY_OTHER
ANY_OTHER:
    .
    ;

// Rule mapping (original -> generated)
// MultiplicityBoundsCS -> multiplicityBoundsCs
// MultiplicityCS -> multiplicityCs
// MultiplicityStringCS -> multiplicityStringCs
// PathNameCS -> pathNameCs
// UnreservedPathNameCS -> unreservedPathNameCs
// FirstPathElementCS -> firstPathElementCs
// NextPathElementCS -> nextPathElementCs
// TemplateBindingCS -> templateBindingCs
// TemplateParameterSubstitutionCS -> templateParameterSubstitutionCs
// TemplateSignatureCS -> templateSignatureCs
// TypeParameterCS -> typeParameterCs
// TypeRefCS -> typeRefCs
// TypedRefCS -> typedRefCs
// TypedTypeRefCS -> typedTypeRefCs
// UnreservedName -> unreservedName
// UnrestrictedName -> unrestrictedName
// WildcardTypeRefCS -> wildcardTypeRefCs
// ID -> id
// Identifier -> identifier
// LOWER -> lower
// NUMBER_LITERAL -> numberLiteral
// StringLiteral -> stringLiteral
// UPPER -> upper
// URI -> uri
// ESCAPED_CHARACTER -> ESCAPED_CHARACTER
// LETTER_CHARACTER -> LETTER_CHARACTER
// DOUBLE_QUOTED_STRING -> DOUBLE_QUOTED_STRING
// SINGLE_QUOTED_STRING -> SINGLE_QUOTED_STRING
// ML_SINGLE_QUOTED_STRING -> ML_SINGLE_QUOTED_STRING
// SIMPLE_ID -> SIMPLE_ID
// ESCAPED_ID -> ESCAPED_ID
// INT -> INT
// ML_COMMENT -> ML_COMMENT
// SL_COMMENT -> SL_COMMENT
// WS -> WS
// ANY_OTHER -> ANY_OTHER

