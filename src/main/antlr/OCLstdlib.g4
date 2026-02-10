/*******************************************************************************
 * Copyright (c) 2010 Willink Transformations and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v2.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v20.html
 *
 * Contributors:
 *   E.D.Willink - initial API and implementation
 * 	 E.D.Willink (Obeo) - Bug 416287 - tuple-valued constraints
 *******************************************************************************/
grammar OCLstdlib;
import EssentialOCL;

// Converted from OCLstdlib.xtext
// Naming: parser=lowerCamelCase, lexer=UPPER_SNAKE_CASE

// from: Library
// returns LibRootPackageCS
library:
    (importCs ';')*
    	(libPackageCs)*
    ;

// @Override

// from: Identifier
identifier:
    id
    |	restrictedKeywords
    ;

// from: RestrictedKeywords
restrictedKeywords:
    'abstract'
    |	'annotation'
    |	'conformsTo'
    |	'documentation'
    |	'extends'
    |	'import'
    |	'inv'
    |	'invalidating'
    |	'iteration'
    |	'left'
    |	'library'
    |	'operation'
    |	'opposite'
    |	'package'
    |	'post'
    |	'pre'
    |	'precedence'
    |	'property'
    |	'right'
    |	'static'
    |	'type'
    //|	'typeof'
    |	'validating'
    //|	'Lambda'
    //|	'Tuple'
    ;

// from: Name
name:
    identifier
    |	DOUBLE_QUOTED_STRING
    |	essentialOclReservedKeyword
    |	primitiveTypeIdentifier
    |	collectionTypeIdentifier
    ;

// from: AnyName
anyName:
    name
    |	'Lambda'
    |	'Map'
    |	'Tuple'
    ;

// from: LibPathNameCS
// returns base::PathNameCS
libPathNameCs:
    libPathElementCs ('::' libPathElementCs)*
    ;

// from: LibPathElementCS
// returns base::PathElementCS
libPathElementCs:
    name /* xref: pivot::NamedElement */
    ;

// from: AccumulatorCS
// returns base::ParameterCS
accumulatorCs:
    identifier ':' typedMultiplicityRefCs
    ;

// from: AnnotationCS
// returns base::AnnotationCS
annotationCs:
    'annotation' (identifier|SINGLE_QUOTED_STRING)
    	('(' detailCs (',' detailCs)* ')')?
    	(('{' annotationElementCs '}')
    	|';'
    	)
    ;

// from: AnnotationElementCS
// returns base::AnnotationElementCS
annotationElementCs:
    annotationCs | documentationCs
    ;

// from: LibClassCS
// returns LibClassCS
libClassCs:
    ('abstract')? 'type' anyName
    	(templateSignatureCs)?
    	(':' anyName /* xref: MetaclassNameCS */)?
    	('conformsTo' typedRefCs (',' typedRefCs)*)?
    	('=>' SINGLE_QUOTED_STRING /* xref: JavaClassCS */)?
    	'{' (operationCs
    	   | libPropertyCs
    	   | invCs
    	   | annotationElementCs)* '}'
    ;

// from: ClassCS
// returns base::ClassCS
classCs:
    libClassCs
    ;

// from: DetailCS
// returns base::DetailCS
detailCs:
    (name|SINGLE_QUOTED_STRING) '=' (SINGLE_QUOTED_STRING|ML_SINGLE_QUOTED_STRING)*
    ;

// from: DocumentationCS
// returns base::DocumentationCS
documentationCs:
    /* action: base::DocumentationCS */  'documentation' SINGLE_QUOTED_STRING?
    	('(' detailCs (',' detailCs)* ')')?
    	 ';'
    ;

// from: ImportCS
// returns base::ImportCS
importCs:
    'import' (identifier ':')? uriPathNameCs ('::*')?
    ;

// from: InvCS
// returns LibConstraintCS
invCs:
    'inv' (unrestrictedName ('(' specificationCs ')')?)? ':' specificationCs ';'
    ;

// from: LibCoercionCS
// returns LibCoercionCS
libCoercionCs:
    'coercion' name '(' ')' ':' typedMultiplicityRefCs
    	('=>' SINGLE_QUOTED_STRING /* xref: JavaClassCS */)?
    	(('{' (annotationElementCs
    	     | postCs
    	     | preCs)* '}')
    	|';'
    	)
    ;

// from: LibIterationCS
// returns LibIterationCS
libIterationCs:
    'iteration' name
    	(templateSignatureCs)?
    	'(' iteratorCs (',' iteratorCs)*
    	(';' accumulatorCs (',' accumulatorCs)*)?
    	('|' parameterCs (',' parameterCs)*)?
    	')'
    	':' typedMultiplicityRefCs
    	('invalidating')?
    	('validating')?
    	('=>' SINGLE_QUOTED_STRING /* xref: JavaClassCS */)?
    	(('{' (annotationElementCs
    	     | postCs
    	     | preCs)* '}')
    	|';'
    	)
    ;

// from: IteratorCS
// returns base::ParameterCS
iteratorCs:
    identifier ':' typedMultiplicityRefCs
    ;

// from: LambdaTypeCS
// returns base::LambdaTypeCS
lambdaTypeCs:
    'Lambda' (templateSignatureCs)? lambdaContextTypeRefCs
    	'(' (typedMultiplicityRefCs (',' typedMultiplicityRefCs)*)? ')'
    	':' typedRefCs
    ;

// from: LambdaContextTypeRefCS
// returns base::TypedTypeRefCS
lambdaContextTypeRefCs:
    libPathNameCs
    ;

// from: OperationCS
// returns base::OperationCS
operationCs:
    libCoercionCs|libIterationCs|libOperationCs
    ;

// from: LibOperationCS
// returns LibOperationCS
libOperationCs:
    ('static')? 'operation' name
    	(templateSignatureCs)?
    	'(' (parameterCs (',' parameterCs)*)? ')'
    	':' typedMultiplicityRefCs
    	('validating')?
    	('invalidating')?
    	('precedence' '=' name /* xref: pivot::Precedence */)?
    	('=>' SINGLE_QUOTED_STRING /* xref: JavaClassCS */)?
    	(('{' (annotationElementCs
    	     | ('body' unrestrictedName? ':' specificationCs ';')
    	     | postCs
    	     | preCs)* '}')
    	|';'
    	)
    ;

// from: LibOppositeCS
// returns LibOppositeCS
libOppositeCs:
    'opposite' name ':' typedMultiplicityRefCs
    ;

// from: LibPackageCS
// returns LibPackageCS
libPackageCs:
    'library' name
    	(':' identifier '=' uri)?
    	'{' (packageCs
    		| ('precedence' (precedenceCs)+ ';')
    	    | classCs
    		| annotationElementCs)*
    	'}'
    ;

// from: PackageCS
// returns base::PackageCS
packageCs:
    'package' name
    	(':' identifier '=' uri)?
    	'{'
    		(packageCs
    	   | classCs
    	   | annotationElementCs)*
    	'}'
    ;

// from: ParameterCS
// returns base::ParameterCS
parameterCs:
    identifier ':' typedMultiplicityRefCs
    ;

// from: LibPropertyCS
// returns LibPropertyCS
libPropertyCs:
    ('static')? 'property' name
    	':' typedMultiplicityRefCs
    	libOppositeCs?
    	('=>' SINGLE_QUOTED_STRING /* xref: JavaClassCS */)?
    	(	('{' (annotationElementCs)* '}')
    	|	';'
    	)
    ;

// from: PostCS
// returns LibConstraintCS
postCs:
    'post' (unrestrictedName ('(' specificationCs ')')?)? ':' specificationCs ';'
    ;

// from: PreCS
// returns LibConstraintCS
preCs:
    'pre' (unrestrictedName ('(' specificationCs ')')?)? ':' specificationCs ';'
    ;

// from: PrecedenceCS
// returns PrecedenceCS
precedenceCs:
    ('left'|'right') ':' name
    ;

// from: SpecificationCS
// returns essentialocl::ExpSpecificationCS
specificationCs:
    expCs
    ;

// from: TypedMultiplicityRefCS
// returns base::TypedRefCS
typedMultiplicityRefCs:
    (mapTypeCs | tupleTypeCs | typedTypeRefCs | lambdaTypeCs) (multiplicityCs)?
    ;



//---------------------------------------------------------------------------------
//	Base overrides
//---------------------------------------------------------------------------------
// @Override

// from: TypedRefCS
// returns base::TypedRefCS
typedRefCs:
    mapTypeCs | tupleTypeCs | typedTypeRefCs | lambdaTypeCs
    ;

// @Override

// from: TypedTypeRefCS
// returns base::TypedTypeRefCS
typedTypeRefCs:
    ('typeof' '(' libPathNameCs ')')
      | (libPathNameCs ('(' templateBindingCs ')')?)
    ;



//---------------------------------------------------------------------------------
//	EssentialOCL overrides
//---------------------------------------------------------------------------------
// @Override

// from: TuplePartCS
// returns base::TuplePartCS
tuplePartCs:
    identifier ':' typedMultiplicityRefCs
    ;

// Rule mapping (original -> generated)
// Library -> library
// Identifier -> identifier
// RestrictedKeywords -> restrictedKeywords
// Name -> name
// AnyName -> anyName
// LibPathNameCS -> libPathNameCs
// LibPathElementCS -> libPathElementCs
// AccumulatorCS -> accumulatorCs
// AnnotationCS -> annotationCs
// AnnotationElementCS -> annotationElementCs
// LibClassCS -> libClassCs
// ClassCS -> classCs
// DetailCS -> detailCs
// DocumentationCS -> documentationCs
// ImportCS -> importCs
// InvCS -> invCs
// LibCoercionCS -> libCoercionCs
// LibIterationCS -> libIterationCs
// IteratorCS -> iteratorCs
// LambdaTypeCS -> lambdaTypeCs
// LambdaContextTypeRefCS -> lambdaContextTypeRefCs
// OperationCS -> operationCs
// LibOperationCS -> libOperationCs
// LibOppositeCS -> libOppositeCs
// LibPackageCS -> libPackageCs
// PackageCS -> packageCs
// ParameterCS -> parameterCs
// LibPropertyCS -> libPropertyCs
// PostCS -> postCs
// PreCS -> preCs
// PrecedenceCS -> precedenceCs
// SpecificationCS -> specificationCs
// TypedMultiplicityRefCS -> typedMultiplicityRefCs
// TypedRefCS -> typedRefCs
// TypedTypeRefCS -> typedTypeRefCs
// TuplePartCS -> tuplePartCs

