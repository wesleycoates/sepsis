
/*
Based on
Adult Sepsis data dictionary, from the NYS DOH Adult Sepsis and COVID-19 Data Dictionary, Digitalized Data Collection, D3.0
Data Dictionary. As of 3/18/2022 is located at https://ny.sepsis.ipro.org/files/documents/adult/D3-0/dictionary.pdf

## Description
The New York State Department of Health (NHSDOH) seeks the collection of data for all
severe sepsis, septic shock, and COVID-19 inpatients, emergency department (ED) patients
and Observation patients who meet the case inclusion definition provided in this dictionary.

Inclusion criteria is summarized below:
Adult cases with specific ICD-10-CM codes that describe severe sepsis, septic shock, and severe COVID-19.
//Need to include logic detailing COVID-19 reporting. If Severe Sepsis / Septic Shock cases are present, Then report all COVID-19 cases.

//Quick side note from Matt -- I want to make sure we include a diagram/algorithm that illustrates the criteria, akin to an eCQM Flow
//We will likely need to include all supportive info from the "Key points to remember during data extraction" page.

## Inclusion Criteria
*Adult populations of 21 years of age or older
*Inpatient hospital encounters //Is this necessary or assumed via ICD-10 codes?
*Cases with the following ICD-10-CM codes.
*Cases should only be reported if one of the codes is a final diagnosis:
At least one of the following:
R6520
R6521
T8112XA

OR

At least two of these codes, one of which must be either U071 OR U072 OR J1282 as well as one or more of the following:
J80
J9600
J9601
J9602
J9690
J9691
J9692
R0600
R0609
R092
J1289
R0902
J9620
J9621
J9622
R0603
R602
N170
N171
N172
N178
N179
K7111
K7200
K7201
K7290
K7291
K762
K763
D65
D688
D689
D6951
D6959
D696
F05
G931
G9340
G9341
G9349
R4020
I462
I468
I469
I951
I9589
I959
R031
R570
R571
R578
R579
R6520
R6521
T8112XA

NOTE: This is a work in progress.
It should in no way be considered a final specification or recommendation for guidance.

//<copyright value="This material contains content from LOINC (http://loinc.org ). LOINC is copyright © 1995-2020, Regenstrief Institute, Inc.
and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license
at http://loinc.org/license . LOINC® is a registered United States trademark of Regenstrief Institute, Inc."/>


*/

library version '0.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include FHIRCommon version '4.0.1' called FHIRCommon

codesystem "SNOMEDCT:2022-03": 'http://snomed.info/sct/731000124108' version 'http://snomed.info/sct/731000124108/version/20220301'
codesystem "LOINC:2.72": 'https://loinc.org' version '2.72'
codesystem "RxNorm" 'https://www.nlm.nih.gov/research/umls/rxnorm/'
codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'

//ADD RxNorm version details above; can download MySQL DB for Windows
//RxNorm versioning: should be the date of release, encoded as in the download files, e.g. "07092014"

valueset "Severe Sepsis": '2.16.840.1.113883.3.666.5.2601'
valueset "Septic Shock": '2.16.840.1.113883.3.666.5.2100'
valueset "ONC SNOMEDCT COVID-19": '2.16.840.1.113762.1.4.1114.7'
valueset "Inpatient": '2.16.840.1.113762.1.4.1182.287'

context Unfiltered

define "Get Setting from the Encounter Declaration""
[Encounter: "Inpatient"]

define "Get Condition from the Code Declaration":
[Condition: code ~ "Severe Sepsis Code"]
//either we need a Condition statement like the above for each area of the Inclusion Crieria or we need our own Valueset that
//we use in our retrieve statement. Can be get from code declaration or get from codeset declaration (i.e. ICD-10-CM)


## Demographic Variables

define "AdmissionDateTime":
    code '8656-1' from "LOINC:2.72" display "Hospital admission Datetime"
    //Hospital admission date:TmStp:Pt:^Patient:Qn (8656-1) LOINC Concept
    //Note from Matt: this above concept (Datetime stamp) might be this FHIR resource? Encounter.plannedStartDate
    //Note from Matt: per E.B. Brant et al (Digital Medicine, 2022), "Admit Time" could map directly to FHIR data element Encounter.period.start

//[Condition: "Severe Sepsis"] C where C.admitDateTime during MeasurementPeriod
//Note the above line of code gets at retrieving Severe Sepsis (only) cases according to Admit Date (only), within the Measurement Period (only)
