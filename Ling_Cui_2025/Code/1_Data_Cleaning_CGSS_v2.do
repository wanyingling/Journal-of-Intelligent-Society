/* ========================================================================
 * Program: 复现的限度："硅基样本"的可能与可为
 * Data:	CGSS
 * Author:  Wanying Ling, Sizha Cui
 * Created: 2/10/2025
 * Revised: 4/12/2025
 * ======================================================================= */
 
clear all
set matsize 10000
set more off

global root= "D:\Research\Submitted_intelsoc"
global logfiles= "$root\Logfiles"
global raw_data= "E:\CGSS\Data"
global working_data= "$root\Working_data"
global tables= "$root\Tables"
global figures= "$root\Figures"

*======================*
** Cleaning datasets **
*======================*


// 今年是[年份]，您是一位 [年龄] 岁的[性别]。目前您居住在 [所在省份] 的 [居住地类型]，户口类型为 [户口类型]。
/// 您的最高学历为 [教育水平]，当前的工作状态是 [工作状况]，婚姻状况为 [婚姻状况]，[是否有孩子]。
// 在健康与医疗方面，您认为自己的总体健康状况 [总体健康状况]，并且您 [是否长期生病、或有慢性病或残疾]。
/// 过去12个月中，您 [过去12个月是否经常看中医] 看中医，[过去12个月是否经常看西医] 看西医。
/// 此外，您[过去12个月是否因付不起钱/无法请假或脱不开身/需要等待太久没得到必要的医疗]。
/// 目前，您拥有的医疗保险类型是 [医疗保险类型]。
// 基于以上背景信息，请回答以下单选题：
// Q1：总的来说，您对中国的医疗卫生有多大的信心？
// 选项：
// 1.	完全有信心
// 2.	有很大信心
// 3.	有一些信心
// 4.	几乎没信心
// 5.	完全没有信心


**********
** 2011 **
**********

use $raw_data/CGSS2011.dta, clear 

* 年份
gen year = 2011

* 年龄
gen age = 2011 - a3a

* 性别
recode a2 (1=1 "男性") (2=2 "女性") (else=. )  , gen(gender) /// 1 - 男性，2 - 女性

* 所在省份
recode s41 (4=11 "北京") (7=12 "天津") (17=13 "河北") (11=14 "山西") (3=15 "内蒙古") (27=21 "辽宁") ///
 (5=22 "吉林") (31=23 "黑龙江") (1=31 "上海") (15=32 "江苏") (19=33 "浙江") (9=34 "安徽") (24=35 "福建") ///
 (16=36 "江西") (10=37 "山东") (18=41 "河南") (21=42 "湖北") (22=43 "湖南") (12=44 "广东") (13=45 "广西") ///
 (20=46 "海南") (28=50 "重庆") (6=51 "四川") (26=52 "贵州") (2=53 "云南") (25=54 "西藏") ///
 (29=61 "陕西") (23=62 "甘肃") (30=63 "青海") (8=64 "宁夏") (14=65 "新疆") (else=. )  , gen(prov)

* 居住地类型
recode s5a (1/4 = 1 "城镇") (5=2 "农村") (else=. )  , gen(residtype)

* 户口类型
recode a18 (1=1 "农业户口") (2/5= 2 "非农业或统一居民户口") (else=. )  , gen(hukou)

* 教育水平
recode a7a (1/3=1 "小学及以下") (4=2 "初中") (5/8=3 "高中或技校") (9/13=4 "大学专科及以上") (else=. )  , gen(education)

* 工作状况
recode  a53 (1=1 "在工作") (2/3 = 2 "休假") (4= 3 "未工作") (else=. )  , gen(work)

* 婚姻状况
recode a69 (1/2=1 "未婚") (3/5=2 "已婚") (6=3 "离异") (7=4 "丧偶") (else=. )  , gen(marrstatus)

* 是否有孩子
gen childnum = a681 + a682 if a681>=0 & a682>=0
recode childnum (0=0 "无子女") (1/15=1 "有子女") (else=. )  , gen(child)

* 总体健康状况
recode d26 (1=1 "非常好") (2=2 "很好") (3=3 "好") (4=4 "一般") (5=5 "差") (else=. )  , gen(health)

* 是否长期生病、或有慢性病或残疾
recode d27 (1=1 "长期生病或慢性病或残疾") (2=2 "没有长期生病或慢性病或残疾") (else=. )  , gen(illness)

* 过去12个月是否经常看中医
recode d18b (1=1 "从来没有") (2=2 "很少") (3=3 "有时") (4=4 "经常") (5=5 "非常频繁") (else=. )  , gen(chinesemed)

* 过去12个月是否经常看西医
recode d18a (1=1 "从来没有") (2=2 "很少") (3=3 "有时") (4=4 "经常") (5=5 "非常频繁") (else=. )  , gen(westernmed)

* 过去12个月是否因付不起钱/无法请假或脱不开身/需要等待太久没得到必要的医疗
gen notgetmed = 0 
replace notgetmed = 1 if d20a==1 | d20b ==1 |d20c==1 
replace notgetmed = . if d20a<0 | d20b< 0| d20a<0
label define notgetmed_lab 0 "没有因无力支付，无法请假或等待太久而没有得到必要治疗" ///
                      1 "有因无力支付，无法请假或等待太久而没有得到必要治疗" , replace
label values notgetmed notgetmed_lab

* 医疗保险
recode d291 (0=1 "有医疗保险") (1=0 "无医疗保险") (else=. )  , gen(medinsur)

* 总的来说，您对中国的医疗卫生有多大的信心？ 1- 完全有信心, 2- 有很大信心, 3- 有一些信心, 4- 几乎没信心, 5- 完全没有信心
recode   d2b (1=1 "完全有信心") (2=2 "有很大信心") (3=3 "有一些信心") (4=4 "几乎没信心") (5=5 "完全没有信心") (else=. )   , gen (medconf)

keep id year age gender prov residtype hukou education work marrstatus child health illness chinesemed westernmed notgetmed medinsur medconf weight weight_raking

egen mis = rowmiss(_all)
drop if mis
drop mis

tostring id, replace
gen ID  = "SY2011"+ "ID" + id

keep ID year age gender prov residtype hukou education work marrstatus child health illness chinesemed westernmed notgetmed medinsur medconf weight weight_raking


save $working_data/df2011_cgss.dta, replace


**********
** 2021 **
**********

use $raw_data/CGSS2021.dta, clear 

* 年份
gen year = 2021

* 年龄
gen age = 2021 - A3_1

* 性别
recode A2 (1=1 "男性") (2=2 "女性") (else=. )  , gen(gender) /// 1 - 男性，2 - 女性

* 所在省份
gen prov = 11 if provinces=="北京市"
replace prov = 12 if provinces=="天津市"
replace prov = 13 if provinces=="河北省"
replace prov = 14 if provinces=="山西省"
replace prov = 15 if provinces=="内蒙古自治区"
replace prov = 21 if provinces=="辽宁省"
replace prov = 22 if provinces=="吉林省"
replace prov = 23 if provinces=="黑龙江省"
replace prov = 31 if provinces=="上海市"
replace prov = 32 if provinces=="江苏省"
replace prov = 33 if provinces=="浙江省"
replace prov = 34 if provinces=="安徽省"
replace prov = 35 if provinces=="福建省"
replace prov = 36 if provinces=="江西省"
replace prov = 37 if provinces=="山东省"
replace prov = 41 if provinces=="河南省"
replace prov = 42 if provinces=="湖北省"
replace prov = 43 if provinces=="湖南省"
replace prov = 44 if provinces=="广东省"
replace prov = 44 if provinces=="深圳市"
replace prov = 45 if provinces=="广西壮族自治区"
replace prov = 46 if provinces=="海南省"
replace prov = 50 if provinces=="重庆市"
replace prov = 51 if provinces=="四川省"
replace prov = 52 if provinces=="贵州省"
replace prov = 53 if provinces=="云南省"
replace prov = 54 if provinces=="西藏自治区"
replace prov = 61 if provinces=="陕西省"
replace prov = 62 if provinces=="甘肃省"
replace prov = 63 if provinces=="青海省"
replace prov = 64 if provinces=="宁夏回族自治区"
replace prov = 65 if provinces=="新疆自治区"

* 居住地类型
recode type (1 = 1 "城镇") (2=2 "农村") (else=. )  , gen(residtype)

* 户口类型
recode A18 (1=1 "农业户口") (2/5= 2 "非农业或统一居民户口") (else=. )  , gen(hukou)

* 教育水平
recode A7a (1/3=1 "小学及以下") (4=2 "初中") (5/8=3 "高中或技校") (9/13=4 "大学专科及以上") (else=. )  , gen(education)

* 工作状况
recode  A53 (4=1 "在工作") (2/3 = 2 "休假") (1= 3 "未工作") (else=. )  , gen(work)

* 婚姻状况
recode A69 (1/2=1 "未婚") (3/5=2 "已婚") (6=3 "离异") (7=4 "丧偶") (else=. )  , gen(marrstatus)

* 是否有孩子
gen childnum = A68_1 + A68_2  if A68_1>=0 & A68_2 >=0
recode childnum (0=0 "无子女") (1/15=1 "有子女") (else=. )  , gen(child)

* 总体健康状况
recode D24 (1=1 "非常好") (2=2 "很好") (3=3 "好") (4=4 "一般") (5=5 "差") (else=. )  , gen(health)

* 是否长期生病、或有慢性病或残疾
recode D25 (1=1 "长期生病或慢性病或残疾") (2=2 "没有长期生病或慢性病或残疾") (else=. )  , gen(illness)

* 过去12个月是否经常看中医
recode D17_b (1=1 "从来没有") (2=2 "很少") (3=3 "有时") (4=4 "经常") (5=5 "非常频繁") (else=. )  , gen(chinesemed)

* 过去12个月是否经常看西医
recode D17_a (1=1 "从来没有") (2=2 "很少") (3=3 "有时") (4=4 "经常") (5=5 "非常频繁") (else=. )  , gen(westernmed)

* 过去12个月是否因付不起钱/无法请假或脱不开身/需要等待太久没得到必要的医疗
gen notgetmed = 0 
replace notgetmed = 1 if D18_a==1 | D18_b ==1 |D18_c==1 
replace notgetmed = . if D18_a<0 | D18_b< 0| D18_c<0
label define notgetmed_lab 0 "没有因无力支付，无法请假或等待太久而没有得到必要治疗" ///
                      1 "有因无力支付，无法请假或等待太久而没有得到必要治疗" , replace
label values notgetmed notgetmed_lab

* 医疗保险
recode D28  (1=0 "无医疗保险") (2/8=1 "有医疗保险")(else=. )  , gen(medinsur)

* 总的来说，您对中国的医疗卫生有多大的信心？ 1- 完全有信心, 2- 有很大信心, 3- 有一些信心, 4- 几乎没信心, 5- 完全没有信心
recode  D2 (1=1 "完全有信心") (2=2 "有很大信心") (3=3 "有一些信心") (4=4 "几乎没信心") (5=5 "完全没有信心") (else=. )   , gen (medconf)

keep id year age gender prov residtype hukou education work marrstatus child health illness chinesemed westernmed notgetmed medinsur medconf weight weight_raking

egen mis = rowmiss(_all)
drop if mis
drop mis

tostring id, replace
gen ID  = "SY2021"+ "ID" + id
 
keep ID year age gender prov residtype hukou education work marrstatus child health illness chinesemed westernmed notgetmed medinsur medconf weight weight_raking


save $working_data/df2021_cgss.dta, replace

*=================================================*
** Merging datasets **
*=================================================*

use $working_data/df2011_cgss.dta, clear
append using $working_data/df2021_cgss.dta

save $working_data/df_cgss.dta, replace

export delimited using $working_data/samples_cgss.csv, replace

use $working_data/df_cgss.dta, replace

merge 1:1 ID using  $working_data/LLMs_vars.dta
drop _merge

label define medconf_lab 1 "完全有信心" 2 "有很大信心" 3 "有一些信心" 4 "几乎没信心" 5 "完全没有信心", replace
label values medconf_deepseek_v1 medconf_deepseek_v2  medconf_gpt4o_v1 medconf_gpt4o_v2 medconf_qwen_v1  medconf_qwen_v2 medconf_lab

label variable ID "样本代码"  
label variable year "年份"
label variable age "年龄"
label variable prov "省份"  
label variable residtype "城乡类型"
label variable hukou "户口类型"
label variable education "教育水平"
label variable work  "工作状态"
label variable marrstatus "婚姻状态"
label variable child "是否有子女"
label variable health "自评健康"
label variable illness "是否长期生病、或有慢性病或残疾"
label variable chinesemed "过去12个月是否经常看中医"
label variable westernmed "过去12个月是否经常看西医"
label variable notgetmed "过去12个月是否因付不起钱/无法请假或脱不开身/需要等待太久没得到必要的医疗"
label variable medinsur "医疗保险类型"
label variable medconf "对医疗卫生的信心：人类受访者"
label variable medconf_deepseek_v1 "对医疗卫生的信心（DeepSeek-V3，2025年2月）"
label variable medconf_gpt4o_v1 "对医疗卫生的信心（GPT-4o，2025年2月）"
label variable medconf_qwen_v1 "对医疗卫生的信心（Qwen-plus，2025年2月）"
label variable medconf_deepseek_v2 "对医疗卫生的信心（DeepSeek-V3，2025年4月）"
label variable medconf_gpt4o_v2 "对医疗卫生的信心（GPT-4o，2025年4月）"
label variable medconf_qwen_v2 "对医疗卫生的信心（Qwen-plus，2025年4月）"

save $working_data/llms_cgss_v2.dta, replace