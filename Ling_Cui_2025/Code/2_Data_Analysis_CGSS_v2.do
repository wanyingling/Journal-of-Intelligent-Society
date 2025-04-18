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


graph set print fontface "SimSun"
graph set eps fontface "SimSun"

log using $logfiles\IntelSoc_LLMs_v2.log, replace

use $working_data\llms_cgss_v2.dta, clear

**### 表2. 分析样本的描述性统计 & 附表1. 分析样本的描述性统计

table () () () , statistic(mean age )
table () () () , statistic(sd age )
eststo sum_all: prop medconf medconf_qwen_v1 medconf_deepseek_v1 medconf_gpt4o_v1 medconf_qwen_v2 medconf_deepseek_v2 medconf_gpt4o_v2  gender residtype hukou education work marrstatus child  prov medinsur health notgetmed illness chinesemed westernmed 
esttab sum_all ///
 using $tables/Table1.rtf, ///
 title ("表2. 分析样本的描述性统计") ///
 mtitles( ) scalars(N) b(4) wide nonumber nogaps nobaselevels nostar label replace

table () () () [pweight = weight], statistic(mean age )
table () () () [pweight = weight], statistic(sd age )
eststo sum_all_weight : prop medconf medconf_qwen_v1 medconf_deepseek_v1 medconf_gpt4o_v1 medconf_qwen_v2 medconf_deepseek_v2 medconf_gpt4o_v2  gender residtype hukou education work marrstatus child  prov medinsur health notgetmed illness chinesemed westernmed  [pweight = weight] 
 
 
table () () () [pweight = weight_raking], statistic(mean age )
table () () () [pweight = weight_raking], statistic(sd age )
eststo sum_all_weight_raking : prop medconf medconf_qwen_v1 medconf_deepseek_v1 medconf_gpt4o_v1 medconf_qwen_v2 medconf_deepseek_v2 medconf_gpt4o_v2  gender residtype hukou education work marrstatus child  prov medinsur health notgetmed illness chinesemed westernmed  [pweight = weight_raking] 

esttab sum_all sum_all_weight sum_all_weight_raking ///
 using $tables/TableS1.rtf, ///
 title ("附表1. 分析样本的描述性统计") ///
 mtitles( ) scalars(N) b(4) wide nonumber nogaps nobaselevels nostar label replace
 

**### 图3. 人类样本与硅基样本的个体应答上的差异

tab medconf medconf_deepseek_v1, gamma

tab medconf medconf_gpt4o_v1, gamma

tab medconf medconf_qwen_v1, gamma

tab medconf medconf_deepseek_v2, gamma

tab medconf medconf_gpt4o_v2, gamma

tab medconf medconf_qwen_v2, gamma

tab medconf_deepseek_v1 medconf_deepseek_v2, gamma

tab medconf_gpt4o_v1 medconf_gpt4o_v2, gamma

tab medconf_qwen_v1 medconf_qwen_v2, gamma



**### 图4. 人类样本与硅基样本在因变量分布上的差异

prop medconf medconf_qwen_v1 medconf_qwen_v2 medconf_deepseek_v1 medconf_deepseek_v2 medconf_gpt4o_v1 medconf_gpt4o_v2


ttest medconf==medconf_deepseek_v1

ttest medconf==medconf_gpt4o_v1

ttest medconf==medconf_qwen_v1

ttest medconf==medconf_deepseek_v2

ttest medconf==medconf_gpt4o_v2

ttest medconf==medconf_qwen_v2

ttest medconf_deepseek_v1==medconf_deepseek_v2

ttest medconf_gpt4o_v1==medconf_gpt4o_v2

ttest medconf_qwen_v1==medconf_qwen_v2


**### 图5. 人类样本与硅基样本在变量关系上的差异 & 附表2. 回归模型估计结果

center age
gen age2= c_age* c_age

recode chinesemed (1/2 = 1 "没有或很少") (3/5 = 2 "有时、经常或频繁"), gen(chinesemedfreq)
recode westernmed (1/2 = 1 "没有或很少") (3/5 = 2 "有时、经常或频繁"), gen(westernmedfreq)

* 估计各模型
eststo model_human: reg medconf i.year i.notgetmed i.medinsur i.illness  i.health  i.chinesemedfreq i.westernmedfreq age age2 i.gender i.prov i.residtype i.hukou i.education i.work i.marrstatus i.child

eststo model_deepseek_1: reg medconf_deepseek_v1 i.year i.notgetmed i.medinsur  i.illness i.health  i.chinesemedfreq i.westernmedfreq age age2 i.gender i.prov i.residtype i.hukou i.education i.work i.marrstatus i.child

eststo model_deepseek_2: reg medconf_deepseek_v2 i.year i.notgetmed i.medinsur i.illness  i.health  i.chinesemedfreq i.westernmedfreq age age2 i.gender i.prov i.residtype i.hukou i.education i.work i.marrstatus i.child

eststo model_gpt4o_1: reg medconf_gpt4o_v1 i.year i.notgetmed i.medinsur i.illness i.health  i.chinesemedfreq i.westernmedfreq   age age2 i.gender i.prov i.residtype i.hukou i.education i.work i.marrstatus i.child

eststo model_gpt4o_2: reg medconf_gpt4o_v2 i.year i.notgetmed i.medinsur  i.illness i.health  i.chinesemedfreq i.westernmedfreq  age age2 i.gender i.prov i.residtype i.hukou i.education i.work i.marrstatus i.child

eststo model_qwen_1: reg medconf_qwen_v1 i.year i.notgetmed i.medinsur  i.illness i.health  i.chinesemedfreq i.westernmedfreq  age age2 i.gender i.prov i.residtype i.hukou i.education i.work i.marrstatus i.child

eststo model_qwen_2: reg medconf_qwen_v2 i.year i.notgetmed i.medinsur  i.illness i.health  i.chinesemedfreq i.westernmedfreq age age2 i.gender i.prov i.residtype i.hukou i.education i.work i.marrstatus i.child

coefplot ///
    (model_human, label(人类受访者) ///
        mcolor("40 40 40") ciopts(color("40 40 40") lwidth(medium)) msymbol(D)) ///
    (model_deepseek_1, label(DeepSeek-V3 (后测1)) ///
        mcolor("80 80 80") ciopts(color("80 80 80") lwidth(medium)) msymbol(S)) ///
    (model_deepseek_2, label(DeepSeek-V3 (后测2)) ///
        mcolor("80 80 80") ciopts(color("80 80 80") lwidth(medium) lpattern(dash)) msymbol(T)) ///
    (model_gpt4o_1, label(GPT-4o (后测1)) ///
        mcolor("120 120 120") ciopts(color("120 120 120") lwidth(medium)) msymbol(S)) ///
    (model_gpt4o_2, label(GPT-4o (后测2)) ///
        mcolor("120 120 120") ciopts(color("120 120 120") lwidth(medium) lpattern(dash)) msymbol(T)) ///
    (model_qwen_1, label(Qwen-plus (后测1)) ///
        mcolor("160 160 160") ciopts(color("160 160 160") lwidth(medium)) msymbol(S)) ///
    (model_qwen_2, label(Qwen-plus (后测2)) ///
        mcolor("160 160 160") ciopts(color("160 160 160") lwidth(medium) lpattern(dash)) msymbol(T)) ///
    || , ///
    keep(*.year *.notgetmed *.medinsur *.chinesemedfreq *.westernmedfreq *.illness *.health) /// 只保留医疗相关变量
    drop(_cons) xline(0, lcolor(black) lpattern(dash)) norecycle /// 
    headings( ///
        2021.year = `""{bf: 调查年份}" "{it: (参考组: 2011年)}""' ///
        1.notgetmed = `""{bf: 未获得医疗服务}" "{it: (参考组: 否)}""' ///
        1.medinsur = `""{bf: 医疗保险}" "{it: (参考组: 无)}""' ///
        2.illness = `""{bf: 是否长期生病}" "{it: (参考组: 否)}""' ///
		2.health = `""{bf: 自评健康状况}" "{it: (参考组: 非常好)}""' ///
		2.chinesemedfreq = `""{bf: 中医使用频率}" "{it: (参考组: 没有或很少)}""' ///
		2.westernmedfreq = `""{bf: 西医使用频率}" "{it: (参考组: 没有或很少)}""' ///
        , gap(0.4) labsize(small)) /// 
    msize(medium) ///
    legend(off) ///
    grid(between glpattern(dot) glwidth(*0.4) glcolor(gs12)) ///
    graphregion(margin(zero) color(white)) plotregion(margin(zero) color(white)) ///
	legend(row(2) position(bottom) size(small) region(lstyle(none)) symxsize(5) symysize(3)) ///
    title("(a) 医疗相关变量", size(medium)) ///
    xtitle("回归系数", size(small)) ///
    xscale(range(-0.5 1.25)) xlabel(-0.5(0.25)1.28, labsize(small)) ///
    ylabel(, labsize(small)) ///
    coeflabels( ///
        2021.year = "2021年" ///
        1.notgetmed = "是" ///
        1.medinsur = "是" ///
        2.illness = "是" ///
        2.health = "很好" /// 
		3.health = "好" ///
		4.health = "一般" ///
		5.health = "差" ///
        2.chinesemedfreq = "有时、经常或频繁" /// 
        2.westernmedfreq = "有时、经常或频繁" /// 
    ) ///
    name(fig4_1_medical, replace)
    
* 生成图2：社会人口学特征
coefplot ///
    (model_human, label(人类受访者) ///
        mcolor("40 40 40") ciopts(color("40 40 40") lwidth(medium)) msymbol(D)) ///
    (model_deepseek_1, label(DeepSeek-V3 (后测1)) ///
        mcolor("80 80 80") ciopts(color("80 80 80") lwidth(medium)) msymbol(S)) ///
    (model_deepseek_2, label(DeepSeek-V3 (后测2)) ///
        mcolor("80 80 80") ciopts(color("80 80 80") lwidth(medium) lpattern(dash)) msymbol(T)) ///
    (model_gpt4o_1, label(GPT-4o (后测1)) ///
        mcolor("120 120 120") ciopts(color("120 120 120") lwidth(medium)) msymbol(S)) ///
    (model_gpt4o_2, label(GPT-4o (后测2)) ///
        mcolor("120 120 120") ciopts(color("120 120 120") lwidth(medium) lpattern(dash)) msymbol(T)) ///
    (model_qwen_1, label(Qwen-plus (后测1)) ///
        mcolor("160 160 160") ciopts(color("160 160 160") lwidth(medium)) msymbol(S)) ///
    (model_qwen_2, label(Qwen-plus (后测2)) ///
        mcolor("160 160 160") ciopts(color("160 160 160") lwidth(medium) lpattern(dash)) msymbol(T)) ///
    || , ///
    keep(age age2 1.gender *.residtype *.hukou *.education *.work *.marrstatus *.child) /// 社会人口学特征
    drop(_cons) xline(0, lcolor(black) lpattern(dash)) norecycle /// 
    headings( 1.gender = `""{bf: 性别}" "{it: (参考组: 男性)}""' ///
        2.residtype = `""{bf: 居住地类型}" "{it: (参考组: 城镇)}""' ///
        2.hukou = `""{bf: 户口类型}" "{it: (参考组: 农业户口)}""' ///
        2.education = `""{bf: 教育程度}" "{it: (参考组: 小学及以下)}""' ///
        2.work = `""{bf: 工作状况}" "{it: (参考组: 在工作)}""' ///
        2.marrstatus = `""{bf: 婚姻状况}" "{it: (参考组: 未婚)}""' ///
        1.child = `""{bf: 子女情况}" "{it: (参考组: 无子女)}""' ///
        , gap(0.4) labsize(small)) /// 
    msize(medium) ///
    legend(off) ///
    grid(between glpattern(dot) glwidth(*0.4) glcolor(gs12)) ///
    graphregion(margin(zero) color(white)) plotregion(margin(zero) color(white)) ///
	legend(row(2) position(bottom) size(small) region(lstyle(none)) symxsize(5) symysize(3)) ///
    title("(b) 社会人口学特征", size(medium)) ///
    xtitle("回归系数", size(small)) ///
    xscale(range(-0.5 0.5)) xlabel(-0.5(0.25)0.78, labsize(small)) ///
    ylabel(, labsize(small)) ///
    coeflabels( ///
		age = "{bf:年龄}" ///
        age2 = "{bf:年龄的平方}" ///
        1.gender = "女性" ///
        2.residtype = "农村" ///
        2.hukou = "非农业户口" ///
        2.education = "初中" ///
        3.education = "高中或技校" ///
        4.education = "大专及以上" ///
        2.work = "休假" ///
        3.work = "未工作" ///
        2.marrstatus = "已婚" ///
        3.marrstatus = "离婚" ///
        4.marrstatus = "丧偶" ///
        1.child = "有子女" ///
    ) ///
    name(fig4_2_socio, replace)


* 合并图表（使用grc1leg命令）
grc1leg fig4_1_medical fig4_2_socio, ///
    legendfrom(fig4_1_medical) ///
    position(bottom) ///
    rows(1) ///
    note("                                                                                               注：显示回归系数及95%置信区间，除上述变量外，模型还控制了省份。", size(vsmall)) ///
    graphregion(margin(zero) color(white)) ///
    ysize(16) xsize(8)

* 保存合并后的图
graph export $figures/figure5.png, replace 

esttab model_human model_deepseek_1 model_gpt4o_1 model_qwen_1 model_deepseek_2 model_gpt4o_2 model_qwen_2  using $tables/TableS2.rtf, replace b(2) ///
		ci(2) la obslast nobaselevels drop() starlevels(* 0.05 ** 0.01 *** 0.001)  /// 
		 refcat( 2021.year "调查年份 (参考组：2011年)" 1.notgetmed "过去12个月是否因费用、时间或等待原因未获医疗 (参考组：否)" ///
           1.medinsur "是否有医疗保险 (参考组：无)" ///
           2.illness "是否长期生病、或有慢性病或残疾 (参考组：是)" ///
           2.gender "性别 (参考组：男性)" ///
		   12.prov "省份 (参考组：北京)" ///
		   age2 "年龄的平方" ///
           2.residtype "居住地类型 (参考组：城镇)" ///
           2.hukou "户口类型 (参考组：农业户口)" ///
           2.education  "教育水平 (参考组：小学及以下)" ///
           2.work  "工作状况 (参考组：在工作)" ///
           2.marrstatus  "婚姻状况 (参考组：未婚)" ///
           1.child "是否有子女 (参考组：无子女)" ///
		   2.chinesemedfreq "中医使用频率(参考组: 没有或很少)" ///
		   2.westernmedfreq  "西医使用频率(参考组: 没有或很少)") ///
		 title("附表2. 各类应答来源的回归估计结果")   ///
		 mlabels("前测：人类样本" "后测一：硅基样本 DeepSeek-V3" "后测一：硅基样本 GPT-4o" "后测一：硅基样本 Qwen-plus" "后测二：硅基样本 DeepSeek-V3" "后测二：硅基样本 GPT-4o" "后测二：硅基样本 Qwen-plus") ///
		  note("注：模型控制了性别，年龄，年龄的平方，省份，城乡类型，户口类型，教育水平，工作状态，婚姻状态，是否有子女，自评健康，是否长期生病、或有慢性病或残疾，是否有医疗保险，过去12个月是否经常看中医，是否经常看西医，过去12个月是否因付不起钱/无法请假或脱不开身/需要等待太久没得到必要的医疗。方括号内为95%置信区间。")
		  
log close