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
grammar CompleteOCL;
import EssentialOCL;

// Converted from CompleteOCL.xtext
// Naming: parser=lowerCamelCase, lexer=UPPER_SNAKE_CASE

// from: CompleteOCLDocumentCS
// returns CompleteOCLDocumentCS
completeOclDocumentCs:
    importCs*
    	(packageDeclarationCs | contextDeclCs)*
    ;

// from: UNQUOTED_STRING
UNQUOTED_STRING:
    // Never forward parsed; just provides a placeholder
    	'拢$%^拢$%^'				//  for reverse serialisation of embedded OCL
    ;

// from: CompleteOCLNavigationOperatorName
completeOclNavigationOperatorName:
    '^' | '^^'
    ;

// from: ClassifierContextDeclCS
// returns ClassifierContextDeclCS
classifierContextDeclCs:
    'context' (templateSignatureCs)? (unrestrictedName)?
    	unreservedPathNameCs
    	(('inv' constraintCs)
    	| defCs
    	)+
    ;



/*
 * A Constraint such as
 *
 * oclText[IsNull('should be null') : self = null]
 *
 * comprises at least the OCL specification of the constraint. The constraint may
 * additionally have a name which may be followed by a parenthesized expression defining an OCL
 * expression to be evaluated to provide an error message.
 */

// from: ConstraintCS
// returns base::ConstraintCS
constraintCs:
    (unrestrictedName ('(' specificationCs ')')?)? ':' specificationCs
    ;



/*
 * A Context declaration can be a Classifier, Operation of Property Context declaration.
 */

// from: ContextDeclCS
// returns ContextDeclCS
contextDeclCs:
    propertyContextDeclCs
    	| classifierContextDeclCs
    	| operationContextDeclCs
    ;



/*
 * A definition can be an, Operation or Property definition.
 */

// from: DefCS
// returns DefCS
defCs:
    defOperationCs|defPropertyCs
    ;



/*
 * An operation definition provides an additional operation for its classifier context.
 *
 * oclText[static def redundantName: isEven(i : Integer) : Boolean = i mod 2 = 0]
 *
 * comprises at least an operation name, return type and an OCL expression that evaluates the operation value.
 * The operation may have parameters and may be declared static in which case there is no oclText[self].
 *
 * For compatibility with invariants the definition may have a name that is never used.
 */

// from: DefOperationCS
// returns DefOperationCS
defOperationCs:
    ('static')? 'def' unrestrictedName? ':' (templateSignatureCs)?
    		unrestrictedName '(' (defParameterCs (',' defParameterCs)*)? ')' ':' (typeExpCs)?
    		 '=' specificationCs
    ;

// from: DefParameterCS
// returns base::ParameterCS
defParameterCs:
    unrestrictedName ':' typeExpCs
    ;



/*
 * A property definition provides an additional property for its classifier context.
 *
 * oclText[static def redundantName: upperCaseName : Boolean = name.toUpperCase()]
 *
 * comprises at least a property name, type and an OCL expression that evaluates the property value.
 * The property may be declared static in which case there is no oclText[self].
 *
 * For compatibility with invariants the definition may have a name that is never used.
 */

// from: DefPropertyCS
// returns DefPropertyCS
defPropertyCs:
    ('static')? 'def' unrestrictedName? ':' unrestrictedName ':' typeExpCs
    		'=' specificationCs
    ;

// from: ImportCS
// returns base::ImportCS
importCs:
    ('import' | 'include' | 'library') (identifier ':')? uriPathNameCs ('::*')?
    ;



/*
 * An operation context declaration complements an existing operation with additional details.
 *
 * oclText[context (T) Stack::pop() : T]
 * oclText[pre NotEmptyPop: size() > 0]
 * oclText[post: size()@pre = size() + 1]
 *
 * The operation declaration comprises at least an operation name, which must be qualified with at least a
 * class name. If used outside a package declaration, package name qualification is also needed.
 * If the return type is omitted OclVoid is used.
 * The operation may also have operation parameters and template parameters.
 * The declaration may be followed by any number of preconditions,
 * and/or postconditions. It may also be followed by a body expression that defines the evaluation.
 *
 * For compatibility with invariants the body expression may have a name that is never used.
 */

// from: OperationContextDeclCS
// returns OperationContextDeclCS
operationContextDeclCs:
    'context' (templateSignatureCs)? unreservedPathNameCs
    	'(' (parameterCs (',' parameterCs)*)? ')' ':' (typeExpCs)?
    	(('pre' constraintCs)
    	| ('post' constraintCs)
    	| ('body' unrestrictedName? ':' specificationCs)
    	)*
    ;

// from: PackageDeclarationCS
// returns PackageDeclarationCS
packageDeclarationCs:
    'package' unreservedPathNameCs ('inv' constraintCs)* (contextDeclCs)* 'endpackage'
    ;

// from: ParameterCS
// returns base::ParameterCS
parameterCs:
    (unrestrictedName ':')? typeExpCs
    ;



/*
 * A property context declaration complements an existing property with additional details.
 *
 * oclText[context (T) Stack::isEmpty : Boolean]
 * oclText[derive IsEmpty: size() = 0]
 *
 * The property declaration comprises at least a property name and type.
 * The type must be qualified with at least a class name.
 * If used outside a package declaration, package name qualification is also needed.
 * The declaration may be followed by a derive constraint and/or an init expression.
 *
 * A derive constraint provides an alternate mechanism for defining a class invariant;
 * the only difference is that the property is identified as a constrainedElement. As an
 * invariant the constraint provides an OCL expression that should always be true.
 *
 * For a non-derived property, an init expression defines the value to be assigned to the property
 * when its containing object is first created.
 *
 * For a derived property, an init expression defines the evaluation of the property, which
 * may vary from access to access even for read-only properties.
 *
 * NB. RoyalAndLoyal gratuitously names its derived values.
 */

// from: PropertyContextDeclCS
// returns PropertyContextDeclCS
propertyContextDeclCs:
    'context' unreservedPathNameCs ':' typeExpCs
    	(('derive' unrestrictedName? ':' specificationCs)
    	| ('init' unrestrictedName? ':' specificationCs)
    	)*
    ;

// from: SpecificationCS
// returns essentialocl::ExpSpecificationCS
specificationCs:
    expCs | UNQUOTED_STRING
    ;



//---------------------------------------------------------------------------------
//	Base overrides
//---------------------------------------------------------------------------------
// @Override

// from: TemplateSignatureCS
// returns base::TemplateSignatureCS
templateSignatureCs:
    ('(' typeParameterCs (',' typeParameterCs)* ')')
    |	('<' typeParameterCs (',' typeParameterCs)* '>')
    ;

// @Override

// from: TypedRefCS
// returns base::TypedRefCS
typedRefCs:
    typeLiteralCs | typedTypeRefCs
    ;

// @Override

// from: UnrestrictedName
// returns ecore::EString
unrestrictedName:
    essentialOclUnrestrictedName
    	//| 'body'
    	//| 'context'
    	//| 'def'
    	//| 'derive'
    	//|	'endpackage'
    	| 'import'
    	| 'include'
    	//| 'init'
    	//| 'inv'
    	| 'library'
    	//|	'package'
    	//|	'post'
    	//|	'pre'
    	//|	'static'
    ;



//---------------------------------------------------------------------------------
//	EssentialOCL overrides
//---------------------------------------------------------------------------------
// @Override

// from: NavigatingArgExpCS
// returns essentialocl::ExpCS
navigatingArgExpCs:
    (/* action: OCLMessageArgCS */  '?')
    	| expCs
    ;

// @Override

// from: NavigationOperatorName
navigationOperatorName:
    essentialOclNavigationOperatorName | completeOclNavigationOperatorName
    ;

// @Override

// from: PrimitiveTypeIdentifier
primitiveTypeIdentifier:
    'Boolean'
    	| 'Integer'
    	| 'Real'
    	| 'String'
    	| 'UnlimitedNatural'
    	| 'OclAny'
    	| 'OclInvalid'
    	| 'OclMessage'
    	| 'OclState'
    	| 'OclVoid'
    ;

// Rule mapping (original -> generated)
// CompleteOCLDocumentCS -> completeOclDocumentCs
// UNQUOTED_STRING -> UNQUOTED_STRING
// CompleteOCLNavigationOperatorName -> completeOclNavigationOperatorName
// ClassifierContextDeclCS -> classifierContextDeclCs
// ConstraintCS -> constraintCs
// ContextDeclCS -> contextDeclCs
// DefCS -> defCs
// DefOperationCS -> defOperationCs
// DefParameterCS -> defParameterCs
// DefPropertyCS -> defPropertyCs
// ImportCS -> importCs
// OperationContextDeclCS -> operationContextDeclCs
// PackageDeclarationCS -> packageDeclarationCs
// ParameterCS -> parameterCs
// PropertyContextDeclCS -> propertyContextDeclCs
// SpecificationCS -> specificationCs
// TemplateSignatureCS -> templateSignatureCs
// TypedRefCS -> typedRefCs
// UnrestrictedName -> unrestrictedName
// NavigatingArgExpCS -> navigatingArgExpCs
// NavigationOperatorName -> navigationOperatorName
// PrimitiveTypeIdentifier -> primitiveTypeIdentifier

