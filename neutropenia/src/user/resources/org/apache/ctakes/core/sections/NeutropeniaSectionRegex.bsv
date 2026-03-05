// Neutropenia pathology report specific start - \h+ to match on horizontal whitespace, \s+ to match on whitespace including linebreaks ( some section headers have them )
// $ = end of line
// since there's so much variation I'm trying to use \s* as the space qualifier after the section header text just in case
// targeted sections
RELEVANT Pathogenic||PATHOGENIC\s+SINGLE\s+NUCLEOTIDE\s+VARIANTS\s+AND\s+SMALL\s+INSERTIONS/DELETIONS[\:\*]\s*
RELEVANT Potential Germline Pathogenic||POTENTIAL\s+GERMLINE\s+PATHOGENIC\s+SINGLE\s+NUCLEOTIDE\s+VARIANTS\s+AND\s+SMALL\s+INSERTIONS/DELETIONS\:\s*
RELEVANT Potential Germline VUS||POTENTIAL\s+GERMLINE\s+VARIANTS\s+OF\s+UNKNOWN\s+SIGNIFICATION\s+\(VUS\)\:\s*
RELEVANT Other VUS||OTHER\s+VARIANTS\s+OF\s+UNKNOWN\s+SIGNIFICANCE\s+\(VUS\)\*\:\s*
// To handle mispellings of ( -> { and ) -> }
RELEVANT Other VUS||OTHER\s+VARIANTS\s+OF\s+UNKNOWN\s+SIGNIFICANCE\s+[^\:]+\:\s*
// non-targeted sections typically after targeted sections for filtering
RELEVANT Potential Germline with Possible Secondary Somatic Variants||POTENTIAL\s+GERMLINE\s+\(WITH\s+POSSIBLE\s+SECONDARY\s+SOMATIC\)\s+VARIANTS\s+\(SBDS,\s+TERC,\s+TERT,\s+DKC[L1],\s+AND\s+DDX41\s+ONLY\)\*\:\s*
Copy Number Analysis||COPY\h+NUMBER\h+ANALYSIS\*\:\s*
RELEVANT FLT3-ITD Analysis||FLT3\-ITD\s+ANALYSIS\s*
// In lots of Genzyme notes
RELEVANT Interpretation||INTERPRETATION\:\s*
// allowing for no colon provided there's a newline
RELEVANT Interpretation||INTERPRETATION\s*$
// No $ since in Invitae notes there are things that follow it
// on the same line sometimes
RELEVANT Result||RESULT\:\s*
// allowing for no colon provided there's a newline
RELEVANT Result||RESULT\s*$
// Invitae notes specifically
RELEVANT Clinical Summary||CLINICAL\s+SUMMARY\h*$
RELEVANT VUS||(ADDITIONAL\s+)?VARIANT(\(S\))?\s+OF\s+UNCERTAIN\s+SIGNIFICANCE\s+IDENTIFIED\.\h*$
RELEVANT Variant Details||VARIANT\s+DETAILS\h*$
RELEVANT Requested Variants||VARIANT\s+DETAILS\h*$
IRRELEVANT Genes Analyzed||GENES\s+ANALYZED\h*$
IRRELEVANT Methods||METHODS\h*$
IRRELEVANT Limitations||LIMITATIONS\h*$
IRRELEVANT Disclaimer||DISCLAIMER\h*$
IRRELEVANT Header Footer||INVITAE\s+DIAGNOSTIC\s+TESTING\s+RESULTS\h*$
IRRELEVANT Gene Transcript||GENE\h+TRANSCRIPT\h*$
IRRELEVANT Signature||THIS\h+REPORT\h+HAS\h+BEEN\h+REVIEWED\h+AND\h+APPROVED\h+BY\:
//  BWH Pathology Reports -- doing the optional whitespace before colons bc sometimes tesseract hallucinates them
IRRELEVANT Targeted Gene Exon List||TARGETED\s+GENE/EXON\s+LIST\s+(\(GENOMIC\s+COORDINATES\s+AVAILABLE\s+UPON\s+REQUEST\))?\s*\:\s*
IRRELEVANT Insufficient Sequence Reads||THE\s+FOLLOWING\s+REGIONS\s+HAVE\s+INSUFFICIENT\s+NUMBER\s+OF\s+SEQUENCE\s+READS\s+\(\<100X\)\s+FOR\s+EVALUATION\.\s+
IRRELEVANT Test Information||TEST\s+INFORMATION\s*\:\s*
IRRELEVANT Wild Type Only Codons||THE\s+FOLLOWING\s+RECURRENTLY\s+MUTATED\s+CODONS\s+HAVE\s+WILD\s+TYPE\s+SEQUENCES\s+ONLY\s*\:\s*
IRRELEVANT Insufficient Coverage Codons||THE\s+FOLLOWING\s+RECURRENTLY\s+MUTATED\s+CODONS\s+HAVE\s+INADEQUATE\s+COVERAGE\s+\(\<100X\)\s*\:
// Integrated oncology
RELEVANT Findings||FINDINGS\:\s*
// Neutropenia pathology report specific end 
// from cTAKES default sections
History of Present Illness||^[\t ]*(?:(?:CC\/HPI:)|(?:S:)|(?:(?:HISTORY OF (?:THE )?(?:PRESENT |PHYSICAL )?ILLNESS)(?: \(HPI(?:, PROBLEM BY PROBLEM)?\))?[\t ]*:?))[\t ]*$
Past Medical History||^[\t ]*(?:(?:PMHX?)|(?:HISTORY OF (?:THE )?PAST ILLNESS)|(?:PAST MEDICAL HISTORY))[\t ]*:?[\t ]*$
Chief Complaint||^[\t ]*(?:CHIEF|PRIMARY) COMPLAINTS?[\t ]*:?[\t ]*$
Patient History||^[\t ]*(?:(?:PERSONAL|PATIENT) (?:(?:AND )?SOCIAL )?HISTORY)|(?:(?:PSYCHO)?SOC(?:IAL)? HISTORY)|(?:HISTORY (?:OF )(?:OTHER )?SOCIAL (?:FUNCTIONs?|FACTORS?))|(?:PSO)|(?:P?SHX)|(?:HISTORY:)[\t ]*:?[\t ]*$
Review of Systems||^[\t ]*(?:(?:ROS:)|(?:(?:REVIEW (?:OF )?SYSTEMS?)|(?:SYSTEMS? REVIEW)[\t ]*:?))[\t ]*$
Family Medical History||^[\t ]*(?:FAMILY (?:MEDICAL )?HISTORY)|(?:HISTORY (?:OF )?FAMILY MEMBER DISEASES?)|(?:FAM HX)|FH|FMH|FMHX|FHX[\t ]*:?[\t ]*$
Medications||^[\t ]*(?:CURRENT )?MEDICATIONS?[\t ]*:?[\t ]*$
Allergies||^[\t ]*ALLERGIES[\t ]*:?[\t ]*$
General Exam||^[\t ]*(?:(?:PE:)|(?:O:)|(?:(?:REVIEW (?:OF )?)?(?:GENERAL(?: PHYSICAL)?|PHYSICAL) (?:EXAM(?:INATION)?|STATUS|APPEARANCE|CONSTITUTIONAL)S?(?: SYMPTOMS?)?[\t ]*:?))[\t ]*$
Vital Signs||^[\t ]*VITAL(?:S|(?: (?:SIGNS|NOTES)))[\t ]*:?[\t ]*$
Identifying Data||^[\t ]*IDENTIFYING DATA[\t ]*:?[\t ]*$
Clinical History||^[\t ]*CLINICAL HISTORY[\t ]*:?[\t ]*$
Current Health||^[\t ]*CURRENT HEALTH(?: STATUS)?[\t ]*:?[\t ]*$
Narrative History||^[\t ]*NARRATIVE HISTORY[\t ]*:?[\t ]*$
Analysis of Problem||^[\t ]*(?:(?:A\/P:)|(?:ANALYSIS (?:OF )?(?:ADMIT(?:TING)? |IDENTIF(?:Y|IED) )?PROBLEMS?[\t ]*:?))[\t ]*$
Telemetry||^[\t ]*TELE(?:METRY)?[\t ]*:?[\t ]*$
Technical Comment||^[\t ]*TECHNICAL COMMENT[\t ]*:?[\t ]*$
Discharge Activity||^[\t ]*DISCHARGE ACTIVITY[\t ]*:?[\t ]*$
Occupational Environmental History||^[\t ]*OCCUPATION(?:AL)? ENVIRONMENT(?:AL)? HISTORY[\t ]*:?[\t ]*$
Immunosuppressants Medications||^[\t ]*(?:CYTOTOXIC )?IMMUN(?:OSUPPRESSANT|IZATION)S?(?: MEDICATIONS?)?(?: ADMINISTRATION HISTORY)?[\t ]*:?[\t ]*$
Medications Outside Hospital||^[\t ]*MEDICATIONS? (?:AT )?OUTSIDE HOSPITAL[\t ]*:?[\t ]*$
Reason for Consult||^[\t ]*REASON (?:FOR )?(?:CONSULT(?:ATION)?|REFERRAL)(?: ?\/? ?QUESTIONS?)?[\t ]*:?[\t ]*$
Problem List||^[\t ]*(?:SIGNIFICANT )?PROBLEMS?(?: LIST)?[\t ]*:?[\t ]*$
Living Situation||^[\t ]*LIV(?:E|ING) SITUATION[\t ]*:?[\t ]*$
Cytologic Diagnosis||^[\t ]*CYTOLOGIC (?:DIAGNOSIS|DX)[\t ]*:?[\t ]*$
Discharge Instructions||^[\t ]*DISCHARGE INSTRUCTIONS?[\t ]*:?[\t ]*$
Body Surface Area||^[\t ]*(?:(?:BODY SURFACE AREA)|BSA)[\t ]*:?[\t ]*$
Discharge Condition||^[\t ]*(?:(?:DISCHARGE CONDITION)|(?:CONDITION (?:(?:AT|ON) )?DISCHARGE))[\t ]*:?[\t ]*$
Diagnosis at Death||^[\t ]*(?:(?:DIAGNOSIS|DX|CAUSE) (?:AT |OF )?DEATH)|COD[\t ]*:?[\t ]*$
Adverse Reactions||^[\t ]*(?:HISTORY (?:OF )?)?(?:(?:ALLERG(?:Y|IES)(?:(?:\/| AND )?ADVERSE REACTIONS?)?)|(?:ADVERSE REACTIONS?(?:(?:\/| AND )?ALLERG(?:Y|IES)?)?))( DISORDERS?)?(?: HISTORY)?[\t ]*:?[\t ]*$
Emergency Department Course||^[\t ]*(?:EMERGENCY|ED) (?:DEPARTMENT|ROOM) (?:COURSE|MANAGEMENT)[\t ]*:?[\t ]*$
Consultation Attending||^[\t ]*CONSULTATION ATTENDING[\t ]*:?[\t ]*$
Body Length||^[\t ]*(?:BODY )?LENGTH[\t ]*:?[\t ]*$
Past Surgical History||^[\t ]*(?:PAST|PREVIOUS|PRIOR)? ?(?:SURG(?:ERY|ICAL)?|OPERATIVE|SIGNIFICANT) (?:HISTORY|HX|PROCEDURES?)[\t ]*:?[\t ]*$
Height||^[\t ]*(?:HEIGHT|HT)[\t ]*:?[\t ]*$
Principle Diagnosis||^[\t ]*(?:PRINCI(?:PLE|PAL)|MAIN|PRIMARY) (?:DIAGNOSI?E?S|DX)[\t ]*:?[\t ]*$
Oxygen Saturation||^[\t ]*(?:OXYGEN|O2) ?SAT(?:URATION)?[\t ]*:?[\t ]*$
Principal Procedures||^[\t ]*(?:PRINCIPAL|PRIMARY) PROCEDURES?[\t ]*:?[\t ]*$
Psychological Stressors||^[\t ]*(?:PSYCHOLOGICAL )?STRESS(?:ORS?| LEVEL)[\t ]*:?[\t ]*$
Pathologic Data||^[\t ]*(?:(?:BIOPS(?:Y|IES))|BX|(?:PATHOLOGIC DATA))[\t ]*:?[\t ]*$
Medication History||^[\t ]*(?:(?:MEDICATION ?(?:TREATMENT|USE)? HISTORY)|(?:HISTORY (?:OF )?MEDICATION ?(?:TREATMENT|USE)?))[\t ]*:?[\t ]*$
Treatment Goals||^[\t ]*(?:TREATMENT )?GOALS?[\t ]*:?[\t ]*$
Input Fluids||^[\t ]*INPUT FLUIDS?[\t ]*:?[\t ]*$
Admission Date||^[\t ]*ADMISSION DATE[\t ]*:?[\t ]*$
History Source||^[\t ]*(?:HISTORY|HX) (?:SOURCES?|(?:(?:OBTAIN(?:ED)?(?: FROM)?)))[\t ]*:?[\t ]*$
Current Pregnancy||^[\t ]*CURRENT PREGNANCY[\t ]*:?[\t ]*$
Special Procedures||^[\t ]*SPECIAL PROCEDURES?[\t ]*:?[\t ]*$
Operative Findings||^[\t ]*OPERATIVE FINDINGS?[\t ]*:?[\t ]*$
Fluid Balance||^[\t ]*(?:(?:FLUID BALANCE)|(?:I(?:NPUT)? ?\/? ?O(?:UTPUT)?))[\t ]*:?[\t ]*$
Blood Pressure||^[\t ]*(?:BLOOD PRESSURE|BP)[\t ]*:?[\t ]*$
Post Procedure Diagnosis||^[\t ]*POST\-?(?:PROCEDURE|OP|OPERATIVE) DIAGNOSIS[\t ]*:?[\t ]*$
Final Diagnosis||^[\t ]*FINAL DIAGNOSIS[\t ]*:?[\t ]*$
Cancer Risk Factors||^[\t ]*CANCER RISK FACTORS?[\t ]*:?[\t ]*$
Invasive Diagnostic Procedure History||^[\t ]*INVASIVE DIAGNOSTIC PROCEDURE HISTORY[\t ]*:?[\t ]*$
Technique||^[\t ]*TECHNIQUE[\t ]*:?[\t ]*$
Medications By Type||^[\t ]*MEDICATIONS? (?:BY )?TYPE[\t ]*:?[\t ]*$
Hematologic History||^[\t ]*(?:HEME|HEMATOLOGIC) (?:HISTORY|HX)[\t ]*:?[\t ]*$
Respiratory Rate||^[\t ]*RESP(?:IRAT(?:ORY|IONS?))?(?: RATE)?[\t ]*:?[\t ]*$
Attending Addendum||^[\t ]*ATTENDING ADDENDUM[\t ]*:?[\t ]*$
Gross Description||^[\t ]*GROSS DESC(?:RIPTION)?[\t ]*:?[\t ]*$
Microscopic Description||^[\t ]*MICROSCOPIC DESC(?:RIPTION)?[\t ]*:?[\t ]*$
Substance Abuse Treatment||^[\t ]*(?:TREATMENT (?:FOR|OF)? ?)?(?:SUBSTANCE|DRUG|ALCOHOL) (?:ABUSE|ADDICTION)(?: TREATMENT)?[\t ]*:?[\t ]*$
Hospital Course||^[\t ]*(?:BRIEF|HISTORY|HX)? ?HOSPITAL COURSE[\t ]*:?[\t ]*$
Histology Summary||^[\t ]*HISTO(?:LOGY)? (?:TISSUE )?SUMMARY[\t ]*:?[\t ]*$
Addendum||^[\t ]*ADDEND(?:A|UM)[\t ]*:?[\t ]*$
Medications at Transfer||^[\t ]*MEDICATIONS?(?: AT)? TRANSFER[\t ]*:?[\t ]*$
Findings||^[\t ]*(?:(?:DIAGNOSTIC )?(?:INDICATIONS? ?\/? )?FINDINGS?(?: (?:AT )?SURGERY)?)|(?:INDICATIONS?:)[\t ]*:?[\t ]*$
Instructions||^[\t ]*INSTRUCTIONS?[\t ]*:?[\t ]*$
Current Antibiotics||^[\t ]*CURRENT ANTIBIOTICS?[\t ]*:?[\t ]*$
Ethanol Use||^[\t ]*(?:HISTORY (?:OF )?)?(?:ALCOHOL|ETHANOL|ETOH)(?: USE)?[\t ]*:?[\t ]*$
Maximum Temperature||^[\t ]*MAX(?:IMUM)? TEMP(?:ERATURE)?[\t ]*:?[\t ]*$
Smoking Use||^[\t ]*(?:SMOKING|CIGAR(?:ETTE)?)(?: USE)?[\t ]*:?[\t ]*$
Admission Condition||^[\t ]*(?:(?:CONDITION(?:ON |AT )? ADMISSION)|(?:ADMISSION CONDITION))[\t ]*:?[\t ]*$

// The following are incomplete
Other Systems Reviewed||^[\t ]*OTHER SYSTEMS REVIEWED[\t ]*:?[\t ]*$
Objective||^[\t ]*OBJECTIVE[\t ]*:?[\t ]*$
Impression||^[\t ]*IMPRESSION[\t ]*:?[\t ]*$
Diagnosis||^[\t ]*DIAGNOS(?:I|E)S[\t ]*:?[\t ]*$
Plan||^[\t ]*(?:ASSESSMENT AND )?PLAN[\t ]*:?[\t ]*$
Labs||^[\t ]*LABS?\/(?:ANC(?:ILLARY)?|STUDIES)[\t ]*:?[\t ]*$
Diet||^[\t ]*DIET[\t ]*:?[\t ]*$
Vaccinations||^[\t ]*VACCINATIONS?[\t ]*:?[\t ]*$

// The following are not clinical document sections, but allow skipping of unwanted text
XML||\A<\?xml (?:[^>]*>)*
