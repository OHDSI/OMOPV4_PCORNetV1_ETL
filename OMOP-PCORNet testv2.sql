

-- Person -> Demographic WITHOUT Biobank_flag
select distinct 
	cast(p.person_id as text) as pat_id,
	cast(year_of_birth as text)||(case when month_of_birth is null OR day_of_birth is null then '' else '-'||lpad(cast(month_of_birth as text),2,'0')||'-'||lpad(cast(day_of_birth as text),2,'0') end) as birth_date,	
	null as birth_time,
	coalesce (m1.target_concept,'OT') as Sex,
	coalesce (m2.target_concept,'OT') as Hispanic,
	coalesce (m3.target_concept,'OT') as Race,
	null,
	gender_source_value,
	ethnicity_source_value,
	race_source_value
from
	omop.person p
	left join cz.cz_omop_pcornet_concept_map m1 on case when p.gender_concept_id is null AND m1.source_concept_id is null then true else p.gender_concept_id = m1.source_concept_id end and m1.source_concept_class='Gender'
	left join cz.cz_omop_pcornet_concept_map m2 on case when p.ethnicity_concept_id is null AND m2.source_concept_id is null then true else p.ethnicity_concept_id = m2.source_concept_id end and m2.source_concept_class='Hispanic'
	left join cz.cz_omop_pcornet_concept_map m3 on case when p.race_concept_id is null AND m3.source_concept_id is null then true else p.race_concept_id = m3.source_concept_id end and m3.source_concept_class = 'Race';

-- Person -> Demographic WITH Biobank_flag

select distinct 
	cast(p.person_id as text) as pat_id,
	cast(year_of_birth as text)||(case when month_of_birth is null OR day_of_birth is null then '' else '-'||lpad(cast(month_of_birth as text),2,'0')||'-'||lpad(cast(day_of_birth as text),2,'0') end) as birth_date,	
	null as birth_time,
	coalesce (m1.target_concept,'OT') as Sex,
	coalesce (m2.target_concept,'OT') as Hispanic,
	coalesce (m3.target_concept,'OT') as Race,
	coalesce (m4.target_concept,'OT') as Biobank_flag,
	gender_source_value,
	ethnicity_source_value,
	race_source_value
from
	omop.person p
	left join omop.observation o on p.person_id = o.person_id and observation_concept_id = 4001345
	left join cz.cz_omop_pcornet_concept_map m1 on case when p.gender_concept_id is null AND m1.source_concept_id is null then true else p.gender_concept_id = m1.source_concept_id end and m1.source_concept_class='Gender'
	left join cz.cz_omop_pcornet_concept_map m2 on case when p.ethnicity_concept_id is null AND m2.source_concept_id is null then true else p.ethnicity_concept_id = m2.source_concept_id end and m2.source_concept_class='Hispanic'
	left join cz.cz_omop_pcornet_concept_map m3 on case when p.race_concept_id is null AND m3.source_concept_id is null then true else p.race_concept_id = m3.source_concept_id end and m3.source_concept_class = 'Race'
	left join cz.cz_omop_pcornet_concept_map m4 on case when o.value_as_concept_id is null AND m4.value_as_concept_id is null then true else o.value_as_concept_id=m4.value_as_concept_id end and m4.source_concept_class = 'Biobank flag'

-- Payer_plan_period -> Enrollment

select distinct 
	cast(ppp.person_id as text) as pat_id,
	cast(date_part('year', payer_plan_period_start_date) as text)||'-'||lpad(cast(date_part('month', payer_plan_period_start_date) as text),2,'0')||'-'||lpad(cast(date_part('day', payer_plan_period_start_date) as text),2,'0') as enr_start_date,
	cast(date_part('year', payer_plan_period_end_date) as text)||'-'||lpad(cast(date_part('month', payer_plan_period_end_date) as text),2,'0')||'-'||lpad(cast(date_part('day', payer_plan_period_end_date) as text),2,'0') as enr_end_date,
	coalesce(m1.target_concept,'OT') as chart_avaiability,
	'I' as ENR_basis
from
	omop.payer_plan_period ppp
	left join omop.observation o on ppp.person_id = o.person_id and observation_concept_id = 4030450
	left join cz.cz_omop_pcornet_concept_map m1 on case when o.value_as_concept_id is null AND m1.value_as_concept_id is null then true else o.value_as_concept_id = m1.value_as_concept_id end and m1.source_concept_class = 'Chart availability'


select '1234'~'^[0-9]{0,3}$';
-- Visit occurrence -> encounter
select distinct 
	cast(v.person_id as text) as pat_id,
	cast(v.visit_occurrence_id as text) as encounterid,
	cast(date_part('year', visit_start_date) as text)||'-'||lpad(cast(date_part('month', visit_start_date) as text),2,'0')||'-'||lpad(cast(date_part('day', visit_start_date) as text),2,'0') as admit_date,
	null as admit_time,
	cast(date_part('year', visit_end_date) as text)||'-'||lpad(cast(date_part('month', visit_end_date) as text),2,'0')||'-'||lpad(cast(date_part('day', visit_end_date) as text),2,'0') as discharge_date,
	null as discharge_time,
	x_provider_id as providerid,
	left(l.zip,3) as facility_location,
	coalesce(m1.target_concept,'OT') as enc_type,
	v.care_site_id as facilityid,
	coalesce(m2.target_concept,'OT') as discharge_disposition,
	coalesce(m4.target_concept,'OT') as discharge_status,
	case when coalesce(m1.target_concept,'OT') in ('AV','OA') then null else case when o2.observation_source_value~'^[0-9]{0,3}$' then lpad(o2.observation_source_value,3,'0') else 'OT' end end as drg,
	case when coalesce(m1.target_concept,'OT') in ('AV','OA') then null else case when visit_start_date<'2007-10-01' then '01' else '02' end end as drg_type,
	coalesce(m5.target_concept,'OT') as admitting_source,
	v.place_of_service_concept_id as raw_enc_type,
	o1.value_as_concept_id as raw_discharge_disposition,
	o3.value_as_concept_id as raw_discharge_status,
	null as raw_drg_type,
	o4.value_as_concept_id as raw_admitting_source
from
	omop.visit_occurrence v
	left join omop.care_site c on v.care_site_id = c.care_site_id
	left join omop.location l on c.location_id = l.location_id
	left join omop.observation o1 on v.person_id = o1.person_id and o1.observation_concept_id = 58020
	left join omop.observation o2 on v.person_id = o2.person_id and o2.observation_concept_id = 3040464  
	left join omop.observation o3 on v.person_id = o3.person_id and o3.observation_concept_id = 4137274
	left join omop.observation o4 on v.person_id = o4.person_id and o4.observation_concept_id = 4145666
	left join cz.cz_omop_pcornet_concept_map m1 on case when v.place_of_service_concept_id is null AND m1.source_concept_id is null then true else v.place_of_service_concept_id = m1.source_concept_id end and m1.source_concept_class='Encounter type'
	left join cz.cz_omop_pcornet_concept_map m2 on case when o1.value_as_concept_id is null AND m2.value_as_concept_id is null then true else o1.value_as_concept_id = m2.value_as_concept_id end and m2.source_concept_class='Discharge disposition'
	left join cz.cz_omop_pcornet_concept_map m4 on case when o3.value_as_concept_id is null AND m4.value_as_concept_id is null then true else o3.value_as_concept_id = m4.value_as_concept_id end and m4.source_concept_class='Discharge status'
	left join cz.cz_omop_pcornet_concept_map m5 on case when o4.value_as_concept_id is null AND m5.value_as_concept_id is null then true else o4.value_as_concept_id = m5.value_as_concept_id end and m4.source_concept_class='Admitting source'

-- condition_occurrence --> Diagnosis

select distinct 
	cast(person_id as text) as patid,
	cast(visit_occurrence_id as text) encounterid,
	enc.enc_type,
	enc.admit_date,
	enc.providerid,
	condition_concept_id as dx,
	'SM' as dx_type,
	null as dx_source,
	null as pdx,
	null as raw_dx,
	null as raw_dx_type,
	null as raw_dx_source,
	null as raw_pdx
from
	omop.condition_occurrence co
	join pcornet.encounter enc on cast(co.visit_occurrence_id as text)=enc.encounterid; 

-- procedure_occurrence -> procedure

select distinct 
	cast(person_id as text) as patid,
	cast(visit_occurrence_id as text) as encounterid,
	enc.enc_type,
	enc.admit_date,
	enc.providerid,
	procedure_concept_id as px,
	'SM' as px_type,
	null as raw_px,
	null as raw_px_type
from
	omop.procedure_occurrence po
	join pcornet.encounter enc on cast(po.visit_occurrence_id as text)=enc.encounterid;

-- observation --> vital

select distinct 
	cast(ob.person_id as text) as patid,
	cast(ob.visit_occurrence_id as text) as encounterid,
	cast(date_part('year', ob.observation_date) as text)||'-'||lpad(cast(date_part('month', ob.observation_date) as text),2,'0')||'-'||lpad(cast(date_part('day', ob.observation_date) as text),2,'0') as measure_date,
	lpad(cast(date_part('hour', ob.observation_time) as text),2,'0')||':'||lpad(cast(date_part('minute', ob.observation_time) as text),2,'0') as measure_time,
	null as vital_source,
	ob_ht.value_as_number as ht,
	ob_wt.value_as_number as wt,
	ob_dia.value_as_number as diastolic,
	ob_sys.value_as_number as systolic,
	ob_bmi.value_as_number as original_bmi,
	null as bp_position,
	null as raw_vital_source,
	null as raw_diastolic,
	null as raw_systolic,
	null as raw_bp_position
from
	omop.observation ob 
	left join omop.observation ob_ht on ob.visit_occurrence_id = ob_ht.visit_occurrence_id and ob_ht.observation_concept_id='3036277'
	left join omop.observation ob_wt on ob.visit_occurrence_id = ob_wt.visit_occurrence_id and ob_wt.observation_concept_id='3025315'
	left join omop.observation ob_dia on ob.visit_occurrence_id = ob_dia.visit_occurrence_id and ob_dia.observation_concept_id='3012888' 
	left join omop.observation ob_sys on ob.visit_occurrence_id = ob_sys.visit_occurrence_id and ob_sys.observation_concept_id='3004249'
	left join omop.observation ob_bmi on ob.visit_occurrence_id = ob_bmi.visit_occurrence_id and ob_bmi.observation_concept_id='3038553'
	where ob.observation_concept_id IN ('3036277','3025315','3012888','3004249','3038553')
