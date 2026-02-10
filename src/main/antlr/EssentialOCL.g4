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
grammar EssentialOCL;
import Base;

// Converted from EssentialOCL.xtext
// Naming: parser=lowerCamelCase, lexer=UPPER_SNAKE_CASE

// from: Model
// returns ContextCS
model:
    expCs
    ;



/** <<<This is a join point for derived grammars - replace with a more disciplined grammar extensibility>>> */

// from: EssentialOCLReservedKeyword
essentialOclReservedKeyword:
    'and'
    	| 'and2'
    	| 'else'
    	| 'endif'
    	| 'if'
    	| 'implies'
    	| 'implies2'
    	| 'in'
    	| 'let'
    	| 'not'
    	| 'not2'
    	| 'or'
    	| 'or2'
    	| 'then'
    	| 'with'
    	| 'xor'
    	| 'xor2'
    ;



/** <<<This is a join point for derived grammars - replace with a more disciplined grammar extensibility>>> */

// from: EssentialOCLUnaryOperatorName
essentialOclUnaryOperatorName:
    '-' | 'not' | 'not2'
    ;



/** <<<This is a join point for derived grammars - replace with a more disciplined grammar extensibility>>> */

// from: EssentialOCLInfixOperatorName
essentialOclInfixOperatorName:
    '*' | '/' | '+' | '-' | '>' | '<' | '>=' | '<=' | '=' | '<>' | 'and' | 'and2' | 'implies' | 'implies2' | 'or' | 'or2' | 'xor' | 'xor2'
    ;



/** <<<This is a join point for derived grammars - replace with a more disciplined grammar extensibility>>> */

// from: EssentialOCLNavigationOperatorName
essentialOclNavigationOperatorName:
    '.' | '->' | '?.' | '?->'
    ;

// from: BinaryOperatorName
binaryOperatorName:
    infixOperatorName | navigationOperatorName
    ;

// from: InfixOperatorName
infixOperatorName:
    // Intended to be overrideable
    	essentialOclInfixOperatorName
    ;

// from: NavigationOperatorName
navigationOperatorName:
    // Intended to be overrideable
    	essentialOclNavigationOperatorName
    ;

// from: UnaryOperatorName
unaryOperatorName:
    // Intended to be overrideable
    	essentialOclUnaryOperatorName
    ;



//---------------------------------------------------------------------
//  Names
//---------------------------------------------------------------------
/** <<<This is a join point for derived grammars - replace with a more disciplined grammar extensibility>>> */

// from: EssentialOCLUnrestrictedName
// returns ecore::EString
essentialOclUnrestrictedName:
    identifier
    ;

// @Override

// from: UnrestrictedName
// returns ecore::EString
unrestrictedName:
    // Intended to be overridden
    	essentialOclUnrestrictedName
    ;



/** <<<This is a join point for derived grammars - replace with a more disciplined grammar extensibility>>> */

// from: EssentialOCLUnreservedName
// returns ecore::EString
essentialOclUnreservedName:
    unrestrictedName
    |	collectionTypeIdentifier
    |	primitiveTypeIdentifier
    |	'Map'
    |	'Tuple'
    ;

// @Override

// from: UnreservedName
// returns ecore::EString
unreservedName:
    // Intended to be overridden
    	essentialOclUnreservedName
    ;

// from: URIPathNameCS
// returns base::PathNameCS
uriPathNameCs:
    uriFirstPathElementCs ('::' nextPathElementCs)*
    ;

// from: URIFirstPathElementCS
// returns base::PathElementCS
uriFirstPathElementCs:
    unrestrictedName /* xref: pivot::NamedElement */ | /* action: base::PathElementWithURICS */  uri /* xref: pivot::Namespace */
    ;

// from: SimplePathNameCS
// returns base::PathNameCS
simplePathNameCs:
    firstPathElementCs
    ;


//---------------------------------------------------------------------
//  Types
//---------------------------------------------------------------------

// from: PrimitiveTypeIdentifier
primitiveTypeIdentifier:
    'Boolean'
    	| 'Integer'
    	| 'Real'
    	| 'String'
    	| 'UnlimitedNatural'
    	| 'OclAny'
    	| 'OclInvalid'
    	| 'OclVoid'
    ;

// from: PrimitiveTypeCS
// returns base::PrimitiveTypeRefCS
primitiveTypeCs:
    primitiveTypeIdentifier
    ;

// from: CollectionTypeIdentifier
// returns ecore::EString
collectionTypeIdentifier:
    'Set'
    	| 'Bag'
    	| 'Sequence'
    	| 'Collection'
    	| 'OrderedSet'
    ;

// from: CollectionTypeCS
// returns CollectionTypeCS
collectionTypeCs:
    collectionTypeIdentifier ('(' typeExpWithoutMultiplicityCs multiplicityCs? ')')?
    ;

// from: MapTypeCS
// returns MapTypeCS
mapTypeCs:
    'Map' ('(' typeExpCs ',' typeExpCs ')')?
    ;

// from: TupleTypeCS
// returns base::TupleTypeCS
tupleTypeCs:
    'Tuple' ('(' (tuplePartCs (',' tuplePartCs)*)? ')')?
    ;

// from: TuplePartCS
// returns base::TuplePartCS
tuplePartCs:
    unrestrictedName ':' typeExpCs
    ;



//---------------------------------------------------------------------
//  Literals
//---------------------------------------------------------------------

// from: CollectionLiteralExpCS
// returns CollectionLiteralExpCS
collectionLiteralExpCs:
    collectionTypeCs
    	'{' (collectionLiteralPartCs
    	(',' collectionLiteralPartCs)*)?
    	'}'
    ;

// from: CollectionLiteralPartCS
// returns CollectionLiteralPartCS
collectionLiteralPartCs:
    (expCs ('..' expCs)?) | patternExpCs
    ;

// from: CollectionPatternCS
// returns CollectionPatternCS
collectionPatternCs:
    collectionTypeCs
    	'{' (patternExpCs
    	(',' patternExpCs)*
    	('++' identifier))?
    	'}'
    ;

// from: ShadowPartCS
// returns ShadowPartCS
shadowPartCs:
    // PatternPartCS
    	(unrestrictedName /* xref: pivot::Property */ '='(expCs|patternExpCs))
    	| stringLiteralExpCs
    ;

// from: PatternExpCS
patternExpCs:
    unrestrictedName? ':' typeExpCs
    ;

// from: LambdaLiteralExpCS
// returns LambdaLiteralExpCS
lambdaLiteralExpCs:
    'Lambda' '{' expCs '}'
    ;

// from: MapLiteralExpCS
// returns MapLiteralExpCS
mapLiteralExpCs:
    mapTypeCs '{' (mapLiteralPartCs (',' mapLiteralPartCs)*)? '}'
    ;

// from: MapLiteralPartCS
// returns MapLiteralPartCS
mapLiteralPartCs:
    expCs ('with'|'<-') expCs
    ;

		// <- is deprecated see Bug 577614

// from: PrimitiveLiteralExpCS
// returns PrimitiveLiteralExpCS
primitiveLiteralExpCs:
    numberLiteralExpCs
    	| stringLiteralExpCs
    	| booleanLiteralExpCs
    	| unlimitedNaturalLiteralExpCs
    	| invalidLiteralExpCs
    	| nullLiteralExpCs
    ;

// from: TupleLiteralExpCS
// returns TupleLiteralExpCS
tupleLiteralExpCs:
    'Tuple' '{' tupleLiteralPartCs (',' tupleLiteralPartCs)* '}'
    ;

// from: TupleLiteralPartCS
// returns TupleLiteralPartCS
tupleLiteralPartCs:
    unrestrictedName (':' typeExpCs)? '=' expCs
    ;

// from: NumberLiteralExpCS
// returns NumberLiteralExpCS
numberLiteralExpCs:
    numberLiteral
    ;

// from: StringLiteralExpCS
// returns StringLiteralExpCS
stringLiteralExpCs:
    stringLiteral+
    ;

// from: BooleanLiteralExpCS
// returns BooleanLiteralExpCS
booleanLiteralExpCs:
    'true'
    	| 'false'
    ;

// from: UnlimitedNaturalLiteralExpCS
// returns UnlimitedNaturalLiteralExpCS
unlimitedNaturalLiteralExpCs:
    /* action: UnlimitedNaturalLiteralExpCS */  '*'
    ;

// from: InvalidLiteralExpCS
// returns InvalidLiteralExpCS
invalidLiteralExpCs:
    /* action: InvalidLiteralExpCS */  'invalid'
    ;

// from: NullLiteralExpCS
// returns NullLiteralExpCS
nullLiteralExpCs:
    /* action: NullLiteralExpCS */  'null'
    ;

// from: TypeLiteralCS
// returns base::TypedRefCS
typeLiteralCs:
    primitiveTypeCs
    	| collectionTypeCs
    	| mapTypeCs
    	| tupleTypeCs
    ;

// from: TypeLiteralWithMultiplicityCS
// returns base::TypedRefCS
typeLiteralWithMultiplicityCs:
    typeLiteralCs multiplicityCs?
    ;

// from: TypeLiteralExpCS
// returns TypeLiteralExpCS
typeLiteralExpCs:
    typeLiteralWithMultiplicityCs
    ;

// from: TypeNameExpCS
// returns TypeNameExpCS
typeNameExpCs:
    pathNameCs (curlyBracketedClauseCs ('{' expCs '}')?)?
    ;

// from: TypeExpWithoutMultiplicityCS
// returns base::TypedRefCS
typeExpWithoutMultiplicityCs:
    (typeNameExpCs | typeLiteralCs | collectionPatternCs)
    ;

// from: TypeExpCS
// returns base::TypedRefCS
typeExpCs:
    typeExpWithoutMultiplicityCs multiplicityCs?
    ;



//---------------------------------------------------------------------
//  Expressions
//---------------------------------------------------------------------
// An ExpCS permits a LetExpCS only in the final term to ensure
//  that let is right associative, whereas infix operators are left associative.
//   a = 64 / 16 / let b : Integer in 8 / let c : Integer in 4
// is
//   a = (64 / 16) / (let b : Integer in 8 / (let c : Integer in 4 ))
/* An expression elaborates a prefixed expression with zero or more binary operator and expression suffixes.
 * An optionally prefixed let expression is permitted except when suffixed with further expressions.*/

// from: ExpCS
// returns ExpCS
expCs:
    //	({InfixExpCS} PrefixedExpCS BinaryOperatorName ExpCS)
    //| 	PrefixedExpCS
    // the above takes exponential or worse time for backtracking, below is fast
    	(prefixedPrimaryExpCs (/* action: InfixExpCS.current */  binaryOperatorName expCs)?)
    | 	prefixedLetExpCs
    ;



/* A prefixed let expression elaborates a let expression with zero or more unary prefix operators. */

// from: PrefixedLetExpCS
// returns ExpCS
prefixedLetExpCs:
    (/* action: PrefixExpCS */  unaryOperatorName prefixedLetExpCs)
    | 	letExpCs
    ;



/* A prefixed primary expression elaborates a primary expression with zero or more unary prefix operators. */

// from: PrefixedPrimaryExpCS
// returns ExpCS
prefixedPrimaryExpCs:
    (/* action: PrefixExpCS */  unaryOperatorName prefixedPrimaryExpCs)
    | 	primaryExpCs
    ;



/* A primary expression identifies the basic expressions from which more complex expressions may be constructed. */

// from: PrimaryExpCS
// returns ExpCS
primaryExpCs:
    nestedExpCs
    |	ifExpCs
    | 	selfExpCs
    | 	primitiveLiteralExpCs
    | 	tupleLiteralExpCs
    | 	mapLiteralExpCs
    | 	collectionLiteralExpCs
    | 	lambdaLiteralExpCs
    | 	typeLiteralExpCs
    | 	nameExpCs
    ;



/* A name expression is a generalised rule for expressions that start with a name and which may be followed by square, round or
 * curly bracket clauses and optionally an @pre as well.*/

// from: NameExpCS
// returns NameExpCS
nameExpCs:
    pathNameCs squareBracketedClauseCs*
    	roundBracketedClauseCs? curlyBracketedClauseCs? ('@' 'pre')?
    ;



/* A curly bracket clause is a generalized rule for the literal arguments of collections, maps, tuples and shadows.*/

// from: CurlyBracketedClauseCS
curlyBracketedClauseCs:
    /* action: CurlyBracketedClauseCS */  '{' ((shadowPartCs (',' shadowPartCs)*))? '}'
    ;



/* A curly bracket clause is a generalized rule for template specialisations and operations arguments.*/

// from: RoundBracketedClauseCS
roundBracketedClauseCs:
    /* action: RoundBracketedClauseCS */  '(' (navigatingArgCs ((navigatingCommaArgCs|navigatingSemiArgCs|navigatingBarArgCs))*)? ')'
    ;



/* A square bracket clause is a generalized rule for association class qualifiers and roles.*/

// from: SquareBracketedClauseCS
squareBracketedClauseCs:
    '[' expCs (',' expCs)* ']'
    ;



/* A navigating argument is a generalized rule for the first argument in a round bracket clause. This is typically the first operation
 * parameter or an iterator. */

// from: NavigatingArgCS
// returns NavigatingArgCS
navigatingArgCs:
    (navigatingArgExpCs ((('with'|'<-') coIteratorVariableCs ('=' expCs)?)
    											|(':' typeExpCs (('with'|'<-') coIteratorVariableCs)? ('=' expCs)?)
    											| ((':' typeExpCs)? (('with'|'<-') coIteratorVariableCs)? 'in' expCs)
    											)?
    	)
    	| (':' typeExpCs)
    ;

	// Type-less init is an illegal infix expression

/* A navigating bar argument is a generalized rule for a bar-prefixed argument in a round bracket clause. This is typically the body of an iteration. */

// from: NavigatingBarArgCS
// returns NavigatingArgCS
navigatingBarArgCs:
    '|' navigatingArgExpCs (':' typeExpCs ('=' expCs)?)?
    ;

	// Type-less init is an illegal infix expression

/* A navigating comma argument is a generalized rule for non-first argument in a round bracket clause. These are typically non-first operation
 * parameters or a second iterator. */

// from: NavigatingCommaArgCS
// returns NavigatingArgCS
navigatingCommaArgCs:
    ',' navigatingArgExpCs ((('with'|'<-') coIteratorVariableCs ('=' expCs)?)
    													  |(':' typeExpCs (('with'|'<-') coIteratorVariableCs)? ('=' expCs)?)
    													  | ((':' typeExpCs)? (('with'|'<-') coIteratorVariableCs)? 'in' expCs)
    													  )?
    ;

	// Type-less init is an illegal infix expression

/* A navigating semi argument is a generalized rule for a semicolon prefixed argument in a round bracket clause. This is typically an iterate accumulator. */

// from: NavigatingSemiArgCS
// returns NavigatingArgCS
navigatingSemiArgCs:
    ';' navigatingArgExpCs (':' typeExpCs ('=' expCs)?)?
    ;

	// Type-less init is an illegal infix expression

// from: NavigatingArgExpCS
// returns ExpCS
navigatingArgExpCs:
    // Intended to be overridden
    	expCs
    	//	'?'	-- defined by Complete OCL
    ;

// from: CoIteratorVariableCS
// returns VariableCS
coIteratorVariableCs:
    unrestrictedName (':' typeExpCs)?
    ;

// from: IfExpCS
// returns IfExpCS
ifExpCs:
    'if' (expCs|patternExpCs)
    	'then' expCs
    //	IfThenExpCS
    	(elseIfThenExpCs)*
    	'else' expCs
    	'endif'
    ;


//IfThenExpCS returns IfThenExpCS:
//	'if' condition=ExpCS
//	'then' thenExpression=ExpCS
//;

// from: ElseIfThenExpCS
// returns IfThenExpCS
elseIfThenExpCs:
    'elseif' expCs
    	'then' expCs
    ;

// from: LetExpCS
// returns LetExpCS
letExpCs:
    'let' letVariableCs (',' letVariableCs)*
    	'in' expCs
    ;

// from: LetVariableCS
// returns LetVariableCS
letVariableCs:
    unrestrictedName roundBracketedClauseCs? (':' typeExpCs)? '=' expCs
    ;

// from: NestedExpCS
// returns NestedExpCS
nestedExpCs:
    '(' expCs ')'
    ;

// from: SelfExpCS
// returns SelfExpCS
selfExpCs:
    /* action: SelfExpCS */  'self'
    ;

// Rule mapping (original -> generated)
// Model -> model
// EssentialOCLReservedKeyword -> essentialOclReservedKeyword
// EssentialOCLUnaryOperatorName -> essentialOclUnaryOperatorName
// EssentialOCLInfixOperatorName -> essentialOclInfixOperatorName
// EssentialOCLNavigationOperatorName -> essentialOclNavigationOperatorName
// BinaryOperatorName -> binaryOperatorName
// InfixOperatorName -> infixOperatorName
// NavigationOperatorName -> navigationOperatorName
// UnaryOperatorName -> unaryOperatorName
// EssentialOCLUnrestrictedName -> essentialOclUnrestrictedName
// UnrestrictedName -> unrestrictedName
// EssentialOCLUnreservedName -> essentialOclUnreservedName
// UnreservedName -> unreservedName
// URIPathNameCS -> uriPathNameCs
// URIFirstPathElementCS -> uriFirstPathElementCs
// SimplePathNameCS -> simplePathNameCs
// PrimitiveTypeIdentifier -> primitiveTypeIdentifier
// PrimitiveTypeCS -> primitiveTypeCs
// CollectionTypeIdentifier -> collectionTypeIdentifier
// CollectionTypeCS -> collectionTypeCs
// MapTypeCS -> mapTypeCs
// TupleTypeCS -> tupleTypeCs
// TuplePartCS -> tuplePartCs
// CollectionLiteralExpCS -> collectionLiteralExpCs
// CollectionLiteralPartCS -> collectionLiteralPartCs
// CollectionPatternCS -> collectionPatternCs
// ShadowPartCS -> shadowPartCs
// PatternExpCS -> patternExpCs
// LambdaLiteralExpCS -> lambdaLiteralExpCs
// MapLiteralExpCS -> mapLiteralExpCs
// MapLiteralPartCS -> mapLiteralPartCs
// PrimitiveLiteralExpCS -> primitiveLiteralExpCs
// TupleLiteralExpCS -> tupleLiteralExpCs
// TupleLiteralPartCS -> tupleLiteralPartCs
// NumberLiteralExpCS -> numberLiteralExpCs
// StringLiteralExpCS -> stringLiteralExpCs
// BooleanLiteralExpCS -> booleanLiteralExpCs
// UnlimitedNaturalLiteralExpCS -> unlimitedNaturalLiteralExpCs
// InvalidLiteralExpCS -> invalidLiteralExpCs
// NullLiteralExpCS -> nullLiteralExpCs
// TypeLiteralCS -> typeLiteralCs
// TypeLiteralWithMultiplicityCS -> typeLiteralWithMultiplicityCs
// TypeLiteralExpCS -> typeLiteralExpCs
// TypeNameExpCS -> typeNameExpCs
// TypeExpWithoutMultiplicityCS -> typeExpWithoutMultiplicityCs
// TypeExpCS -> typeExpCs
// ExpCS -> expCs
// PrefixedLetExpCS -> prefixedLetExpCs
// PrefixedPrimaryExpCS -> prefixedPrimaryExpCs
// PrimaryExpCS -> primaryExpCs
// NameExpCS -> nameExpCs
// CurlyBracketedClauseCS -> curlyBracketedClauseCs
// RoundBracketedClauseCS -> roundBracketedClauseCs
// SquareBracketedClauseCS -> squareBracketedClauseCs
// NavigatingArgCS -> navigatingArgCs
// NavigatingBarArgCS -> navigatingBarArgCs
// NavigatingCommaArgCS -> navigatingCommaArgCs
// NavigatingSemiArgCS -> navigatingSemiArgCs
// NavigatingArgExpCS -> navigatingArgExpCs
// CoIteratorVariableCS -> coIteratorVariableCs
// IfExpCS -> ifExpCs
// ElseIfThenExpCS -> elseIfThenExpCs
// LetExpCS -> letExpCs
// LetVariableCS -> letVariableCs
// NestedExpCS -> nestedExpCs
// SelfExpCS -> selfExpCs

