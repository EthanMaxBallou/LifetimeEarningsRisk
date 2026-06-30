





use "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma_withDemographics.dta", clear


* FHWAGE

* GAMMA TABLES


* Create occupation importance table (Gamma) - LASSO SHAP, NN SHAP, RF SHAP from Python CSVs
tempfile occ_lasso_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_occupation_shap_gamma.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    destring occ_code, replace force
    gsort -avg_shap
    gen lasso_shap_order = _n
    keep occ_code lasso_shap_order
    save `occ_lasso_shap', replace
restore

tempfile occ_nn_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/occupation_shap_gamma.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    gsort -avg_shap
    gen nn_shap_order = _n
    keep occ_code nn_shap_order
    save `occ_nn_shap', replace
restore

tempfile occ_rf_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_occupation_shap_gamma.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    destring occ_code, replace force
    gsort -avg_shap
    gen rf_shap_order = _n
    keep occ_code rf_shap_order
    save `occ_rf_shap', replace
restore

preserve
    local occ_vl : value label occ
    keep occ
    duplicates drop occ, force
    rename occ occ_code
    if "`occ_vl'" != "" {
        label values occ_code `occ_vl'
        decode occ_code, gen(occ_label)
    }
    else {
        tostring occ_code, gen(occ_label) format(%9.0g)
    }

    merge 1:1 occ_code using `occ_lasso_shap', nogenerate
    merge 1:1 occ_code using `occ_nn_shap', nogenerate
    merge 1:1 occ_code using `occ_rf_shap', nogenerate

    label var occ_label "Occupation"
    label var lasso_shap_order "LASSO SHAP Order"
    label var nn_shap_order "NN SHAP Order"
    label var rf_shap_order "Random Forest SHAP Order"

    gsort nn_shap_order lasso_shap_order occ_label

    listtex occ_label lasso_shap_order nn_shap_order rf_shap_order using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_lasso_occ_selection.tex", ///
        replace ///
        head("\begin{tabular}{lccc}" ///
             "\hline\hline" ///
             "Occupation & LASSO SHAP Order & NN SHAP Order & RF SHAP Order \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)

    * Scatter plots comparing SHAP rankings across models (Gamma, Occupation)
    quietly count if !missing(lasso_shap_order) & !missing(nn_shap_order)
    local maxr = r(N)
    twoway (scatter nn_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Occupation: LASSO vs NN") ///
        xtitle("LASSO SHAP Rank") ytitle("NN SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_occ_rank_lasso_vs_nn.pdf", replace

    quietly count if !missing(nn_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order nn_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Occupation: NN vs RF") ///
        xtitle("NN SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_occ_rank_nn_vs_rf.pdf", replace

    quietly count if !missing(lasso_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Occupation: LASSO vs RF") ///
        xtitle("LASSO SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_occ_rank_lasso_vs_rf.pdf", replace
restore


* Create industry importance table (Gamma) - LASSO SHAP, NN SHAP, RF SHAP from Python CSVs
tempfile ind_lasso_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_industry_shap_gamma.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    destring ind_code, replace force
    gsort -avg_shap
    gen lasso_shap_order = _n
    keep ind_code lasso_shap_order
    save `ind_lasso_shap', replace
restore

tempfile ind_nn_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/industry_shap_gamma.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    gsort -avg_shap
    gen nn_shap_order = _n
    keep ind_code nn_shap_order
    save `ind_nn_shap', replace
restore

tempfile ind_rf_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_industry_shap_gamma.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    destring ind_code, replace force
    gsort -avg_shap
    gen rf_shap_order = _n
    keep ind_code rf_shap_order
    save `ind_rf_shap', replace
restore

preserve
    local ind_vl : value label twoind
    keep twoind
    duplicates drop twoind, force
    rename twoind ind_code
    if "`ind_vl'" != "" {
        label values ind_code `ind_vl'
        decode ind_code, gen(ind_label)
    }
    else {
        tostring ind_code, gen(ind_label) format(%9.0g)
    }

    merge 1:1 ind_code using `ind_lasso_shap', nogenerate
    merge 1:1 ind_code using `ind_nn_shap', nogenerate
    merge 1:1 ind_code using `ind_rf_shap', nogenerate

    label var ind_label "Industry"
    label var lasso_shap_order "LASSO SHAP Order"
    label var nn_shap_order "NN SHAP Order"
    label var rf_shap_order "Random Forest SHAP Order"

    gsort nn_shap_order lasso_shap_order ind_label

    listtex ind_label lasso_shap_order nn_shap_order rf_shap_order using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_lasso_ind_selection.tex", ///
        replace ///
        head("\begin{tabular}{lccc}" ///
             "\hline\hline" ///
             "Industry & LASSO SHAP Order & NN SHAP Order & RF SHAP Order \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)

    * Scatter plots comparing SHAP rankings across models (Gamma, Industry)
    quietly count if !missing(lasso_shap_order) & !missing(nn_shap_order)
    local maxr = r(N)
    twoway (scatter nn_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Industry: LASSO vs NN") ///
        xtitle("LASSO SHAP Rank") ytitle("NN SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_ind_rank_lasso_vs_nn.pdf", replace

    quietly count if !missing(nn_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order nn_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Industry: NN vs RF") ///
        xtitle("NN SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_ind_rank_nn_vs_rf.pdf", replace

    quietly count if !missing(lasso_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Industry: LASSO vs RF") ///
        xtitle("LASSO SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_ind_rank_lasso_vs_rf.pdf", replace
restore


* ALPHA TABLES


* Create occupation importance table (Alpha) - LASSO SHAP, NN SHAP, RF SHAP from Python CSVs
tempfile alpha_occ_lasso_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_occupation_shap_alpha.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    destring occ_code, replace force
    gsort -avg_shap
    gen lasso_shap_order = _n
    keep occ_code lasso_shap_order
    save `alpha_occ_lasso_shap', replace
restore

tempfile alpha_occ_nn_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/occupation_shap_alpha.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    gsort -avg_shap
    gen nn_shap_order = _n
    keep occ_code nn_shap_order
    save `alpha_occ_nn_shap', replace
restore

tempfile alpha_occ_rf_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_occupation_shap_alpha.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    destring occ_code, replace force
    gsort -avg_shap
    gen rf_shap_order = _n
    keep occ_code rf_shap_order
    save `alpha_occ_rf_shap', replace
restore

preserve
    local occ_vl : value label occ
    keep occ
    duplicates drop occ, force
    rename occ occ_code
    if "`occ_vl'" != "" {
        label values occ_code `occ_vl'
        decode occ_code, gen(occ_label)
    }
    else {
        tostring occ_code, gen(occ_label) format(%9.0g)
    }

    merge 1:1 occ_code using `alpha_occ_lasso_shap', nogenerate
    merge 1:1 occ_code using `alpha_occ_nn_shap', nogenerate
    merge 1:1 occ_code using `alpha_occ_rf_shap', nogenerate

    label var occ_label "Occupation"
    label var lasso_shap_order "LASSO SHAP Order"
    label var nn_shap_order "NN SHAP Order"
    label var rf_shap_order "Random Forest SHAP Order"

    gsort nn_shap_order lasso_shap_order occ_label

    listtex occ_label lasso_shap_order nn_shap_order rf_shap_order using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_lasso_occ_selection.tex", ///
        replace ///
        head("\begin{tabular}{lccc}" ///
             "\hline\hline" ///
             "Occupation & LASSO SHAP Order & NN SHAP Order & RF SHAP Order \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)

    * Scatter plots comparing SHAP rankings across models (Alpha, Occupation)
    quietly count if !missing(lasso_shap_order) & !missing(nn_shap_order)
    local maxr = r(N)
    twoway (scatter nn_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Occupation: LASSO vs NN") ///
        xtitle("LASSO SHAP Rank") ytitle("NN SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_occ_rank_lasso_vs_nn.pdf", replace

    quietly count if !missing(nn_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order nn_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Occupation: NN vs RF") ///
        xtitle("NN SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_occ_rank_nn_vs_rf.pdf", replace

    quietly count if !missing(lasso_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Occupation: LASSO vs RF") ///
        xtitle("LASSO SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_occ_rank_lasso_vs_rf.pdf", replace
restore


* Create industry importance table (Alpha) - LASSO SHAP, NN SHAP, RF SHAP from Python CSVs
tempfile alpha_ind_lasso_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_industry_shap_alpha.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    destring ind_code, replace force
    gsort -avg_shap
    gen lasso_shap_order = _n
    keep ind_code lasso_shap_order
    save `alpha_ind_lasso_shap', replace
restore

tempfile alpha_ind_nn_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/industry_shap_alpha.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    gsort -avg_shap
    gen nn_shap_order = _n
    keep ind_code nn_shap_order
    save `alpha_ind_nn_shap', replace
restore

tempfile alpha_ind_rf_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_industry_shap_alpha.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    destring ind_code, replace force
    gsort -avg_shap
    gen rf_shap_order = _n
    keep ind_code rf_shap_order
    save `alpha_ind_rf_shap', replace
restore

preserve
    local ind_vl : value label twoind
    keep twoind
    duplicates drop twoind, force
    rename twoind ind_code
    if "`ind_vl'" != "" {
        label values ind_code `ind_vl'
        decode ind_code, gen(ind_label)
    }
    else {
        tostring ind_code, gen(ind_label) format(%9.0g)
    }

    merge 1:1 ind_code using `alpha_ind_lasso_shap', nogenerate
    merge 1:1 ind_code using `alpha_ind_nn_shap', nogenerate
    merge 1:1 ind_code using `alpha_ind_rf_shap', nogenerate

    label var ind_label "Industry"
    label var lasso_shap_order "LASSO SHAP Order"
    label var nn_shap_order "NN SHAP Order"
    label var rf_shap_order "Random Forest SHAP Order"

    gsort nn_shap_order lasso_shap_order ind_label

    listtex ind_label lasso_shap_order nn_shap_order rf_shap_order using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_lasso_ind_selection.tex", ///
        replace ///
        head("\begin{tabular}{lccc}" ///
             "\hline\hline" ///
             "Industry & LASSO SHAP Order & NN SHAP Order & RF SHAP Order \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)

    * Scatter plots comparing SHAP rankings across models (Alpha, Industry)
    quietly count if !missing(lasso_shap_order) & !missing(nn_shap_order)
    local maxr = r(N)
    twoway (scatter nn_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Industry: LASSO vs NN") ///
        xtitle("LASSO SHAP Rank") ytitle("NN SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_ind_rank_lasso_vs_nn.pdf", replace

    quietly count if !missing(nn_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order nn_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Industry: NN vs RF") ///
        xtitle("NN SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_ind_rank_nn_vs_rf.pdf", replace

    quietly count if !missing(lasso_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Industry: LASSO vs RF") ///
        xtitle("LASSO SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_ind_rank_lasso_vs_rf.pdf", replace
restore


















* FEARN



* GAMMA TABLES


* Create occupation importance table (Gamma) - LASSO SHAP, NN SHAP, RF SHAP from Python CSVs
tempfile occ_lasso_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_occupation_shap_gamma_fearn.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    destring occ_code, replace force
    gsort -avg_shap
    gen lasso_shap_order = _n
    keep occ_code lasso_shap_order
    save `occ_lasso_shap', replace
restore

tempfile occ_nn_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/occupation_shap_gamma_fearn.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    gsort -avg_shap
    gen nn_shap_order = _n
    keep occ_code nn_shap_order
    save `occ_nn_shap', replace
restore

tempfile occ_rf_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_occupation_shap_gamma_fearn.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    destring occ_code, replace force
    gsort -avg_shap
    gen rf_shap_order = _n
    keep occ_code rf_shap_order
    save `occ_rf_shap', replace
restore

preserve
    local occ_vl : value label occ
    keep occ
    duplicates drop occ, force
    rename occ occ_code
    if "`occ_vl'" != "" {
        label values occ_code `occ_vl'
        decode occ_code, gen(occ_label)
    }
    else {
        tostring occ_code, gen(occ_label) format(%9.0g)
    }

    merge 1:1 occ_code using `occ_lasso_shap', nogenerate
    merge 1:1 occ_code using `occ_nn_shap', nogenerate
    merge 1:1 occ_code using `occ_rf_shap', nogenerate

    label var occ_label "Occupation"
    label var lasso_shap_order "LASSO SHAP Order"
    label var nn_shap_order "NN SHAP Order"
    label var rf_shap_order "Random Forest SHAP Order"

    gsort nn_shap_order lasso_shap_order occ_label

    listtex occ_label lasso_shap_order nn_shap_order rf_shap_order using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_fearn_lasso_occ_selection.tex", ///
        replace ///
        head("\begin{tabular}{lccc}" ///
             "\hline\hline" ///
             "Occupation & LASSO SHAP Order & NN SHAP Order & RF SHAP Order \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)

    * Scatter plots comparing SHAP rankings across models (Gamma, Occupation)
    quietly count if !missing(lasso_shap_order) & !missing(nn_shap_order)
    local maxr = r(N)
    twoway (scatter nn_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Occupation: LASSO vs NN") ///
        xtitle("LASSO SHAP Rank") ytitle("NN SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_fearn_occ_rank_lasso_vs_nn.pdf", replace

    quietly count if !missing(nn_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order nn_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Occupation: NN vs RF") ///
        xtitle("NN SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_fearn_occ_rank_nn_vs_rf.pdf", replace

    quietly count if !missing(lasso_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Occupation: LASSO vs RF") ///
        xtitle("LASSO SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_fearn_occ_rank_lasso_vs_rf.pdf", replace
restore


* Create industry importance table (Gamma) - LASSO SHAP, NN SHAP, RF SHAP from Python CSVs
tempfile ind_lasso_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_industry_shap_gamma_fearn.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    destring ind_code, replace force
    gsort -avg_shap
    gen lasso_shap_order = _n
    keep ind_code lasso_shap_order
    save `ind_lasso_shap', replace
restore

tempfile ind_nn_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/industry_shap_gamma_fearn.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    gsort -avg_shap
    gen nn_shap_order = _n
    keep ind_code nn_shap_order
    save `ind_nn_shap', replace
restore

tempfile ind_rf_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_industry_shap_gamma_fearn.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    destring ind_code, replace force
    gsort -avg_shap
    gen rf_shap_order = _n
    keep ind_code rf_shap_order
    save `ind_rf_shap', replace
restore

preserve
    local ind_vl : value label twoind
    keep twoind
    duplicates drop twoind, force
    rename twoind ind_code
    if "`ind_vl'" != "" {
        label values ind_code `ind_vl'
        decode ind_code, gen(ind_label)
    }
    else {
        tostring ind_code, gen(ind_label) format(%9.0g)
    }

    merge 1:1 ind_code using `ind_lasso_shap', nogenerate
    merge 1:1 ind_code using `ind_nn_shap', nogenerate
    merge 1:1 ind_code using `ind_rf_shap', nogenerate

    label var ind_label "Industry"
    label var lasso_shap_order "LASSO SHAP Order"
    label var nn_shap_order "NN SHAP Order"
    label var rf_shap_order "Random Forest SHAP Order"

    gsort nn_shap_order lasso_shap_order ind_label

    listtex ind_label lasso_shap_order nn_shap_order rf_shap_order using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_fearn_lasso_ind_selection.tex", ///
        replace ///
        head("\begin{tabular}{lccc}" ///
             "\hline\hline" ///
             "Industry & LASSO SHAP Order & NN SHAP Order & RF SHAP Order \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)

    * Scatter plots comparing SHAP rankings across models (Gamma, Industry)
    quietly count if !missing(lasso_shap_order) & !missing(nn_shap_order)
    local maxr = r(N)
    twoway (scatter nn_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Industry: LASSO vs NN") ///
        xtitle("LASSO SHAP Rank") ytitle("NN SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_fearn_ind_rank_lasso_vs_nn.pdf", replace

    quietly count if !missing(nn_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order nn_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Industry: NN vs RF") ///
        xtitle("NN SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_fearn_ind_rank_nn_vs_rf.pdf", replace

    quietly count if !missing(lasso_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Gamma v Industry: LASSO vs RF") ///
        xtitle("LASSO SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_fearn_ind_rank_lasso_vs_rf.pdf", replace
restore


* ALPHA TABLES


* Create occupation importance table (Alpha) - LASSO SHAP, NN SHAP, RF SHAP from Python CSVs
tempfile alpha_occ_lasso_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_occupation_shap_alpha_fearn.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    destring occ_code, replace force
    gsort -avg_shap
    gen lasso_shap_order = _n
    keep occ_code lasso_shap_order
    save `alpha_occ_lasso_shap', replace
restore

tempfile alpha_occ_nn_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/occupation_shap_alpha_fearn.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    gsort -avg_shap
    gen nn_shap_order = _n
    keep occ_code nn_shap_order
    save `alpha_occ_nn_shap', replace
restore

tempfile alpha_occ_rf_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_occupation_shap_alpha_fearn.csv", clear
    rename occupationcode occ_code
    rename averageshapvalue avg_shap
    destring occ_code, replace force
    gsort -avg_shap
    gen rf_shap_order = _n
    keep occ_code rf_shap_order
    save `alpha_occ_rf_shap', replace
restore

preserve
    local occ_vl : value label occ
    keep occ
    duplicates drop occ, force
    rename occ occ_code
    if "`occ_vl'" != "" {
        label values occ_code `occ_vl'
        decode occ_code, gen(occ_label)
    }
    else {
        tostring occ_code, gen(occ_label) format(%9.0g)
    }

    merge 1:1 occ_code using `alpha_occ_lasso_shap', nogenerate
    merge 1:1 occ_code using `alpha_occ_nn_shap', nogenerate
    merge 1:1 occ_code using `alpha_occ_rf_shap', nogenerate

    label var occ_label "Occupation"
    label var lasso_shap_order "LASSO SHAP Order"
    label var nn_shap_order "NN SHAP Order"
    label var rf_shap_order "Random Forest SHAP Order"

    gsort nn_shap_order lasso_shap_order occ_label

    listtex occ_label lasso_shap_order nn_shap_order rf_shap_order using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_fearn_lasso_occ_selection.tex", ///
        replace ///
        head("\begin{tabular}{lccc}" ///
             "\hline\hline" ///
             "Occupation & LASSO SHAP Order & NN SHAP Order & RF SHAP Order \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)

    * Scatter plots comparing SHAP rankings across models (Alpha, Occupation)
    quietly count if !missing(lasso_shap_order) & !missing(nn_shap_order)
    local maxr = r(N)
    twoway (scatter nn_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Occupation: LASSO vs NN") ///
        xtitle("LASSO SHAP Rank") ytitle("NN SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_fearn_occ_rank_lasso_vs_nn.pdf", replace

    quietly count if !missing(nn_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order nn_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Occupation: NN vs RF") ///
        xtitle("NN SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_fearn_occ_rank_nn_vs_rf.pdf", replace

    quietly count if !missing(lasso_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Occupation: LASSO vs RF") ///
        xtitle("LASSO SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_fearn_occ_rank_lasso_vs_rf.pdf", replace
restore


* Create industry importance table (Alpha) - LASSO SHAP, NN SHAP, RF SHAP from Python CSVs
tempfile alpha_ind_lasso_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_industry_shap_alpha_fearn.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    destring ind_code, replace force
    gsort -avg_shap
    gen lasso_shap_order = _n
    keep ind_code lasso_shap_order
    save `alpha_ind_lasso_shap', replace
restore

tempfile alpha_ind_nn_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/industry_shap_alpha_fearn.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    gsort -avg_shap
    gen nn_shap_order = _n
    keep ind_code nn_shap_order
    save `alpha_ind_nn_shap', replace
restore

tempfile alpha_ind_rf_shap
preserve
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_industry_shap_alpha_fearn.csv", clear
    rename industrycode ind_code
    rename averageshapvalue avg_shap
    destring ind_code, replace force
    gsort -avg_shap
    gen rf_shap_order = _n
    keep ind_code rf_shap_order
    save `alpha_ind_rf_shap', replace
restore

preserve
    local ind_vl : value label twoind
    keep twoind
    duplicates drop twoind, force
    rename twoind ind_code
    if "`ind_vl'" != "" {
        label values ind_code `ind_vl'
        decode ind_code, gen(ind_label)
    }
    else {
        tostring ind_code, gen(ind_label) format(%9.0g)
    }

    merge 1:1 ind_code using `alpha_ind_lasso_shap', nogenerate
    merge 1:1 ind_code using `alpha_ind_nn_shap', nogenerate
    merge 1:1 ind_code using `alpha_ind_rf_shap', nogenerate

    label var ind_label "Industry"
    label var lasso_shap_order "LASSO SHAP Order"
    label var nn_shap_order "NN SHAP Order"
    label var rf_shap_order "Random Forest SHAP Order"

    gsort nn_shap_order lasso_shap_order ind_label

    listtex ind_label lasso_shap_order nn_shap_order rf_shap_order using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_fearn_lasso_ind_selection.tex", ///
        replace ///
        head("\begin{tabular}{lccc}" ///
             "\hline\hline" ///
             "Industry & LASSO SHAP Order & NN SHAP Order & RF SHAP Order \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)

    * Scatter plots comparing SHAP rankings across models (Alpha, Industry)
    quietly count if !missing(lasso_shap_order) & !missing(nn_shap_order)
    local maxr = r(N)
    twoway (scatter nn_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Industry: LASSO vs NN") ///
        xtitle("LASSO SHAP Rank") ytitle("NN SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_fearn_ind_rank_lasso_vs_nn.pdf", replace

    quietly count if !missing(nn_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order nn_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Industry: NN vs RF") ///
        xtitle("NN SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_fearn_ind_rank_nn_vs_rf.pdf", replace

    quietly count if !missing(lasso_shap_order) & !missing(rf_shap_order)
    local maxr = r(N)
    twoway (scatter rf_shap_order lasso_shap_order, mcolor(navy)) ///
           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
        title("Alpha v Industry: LASSO vs RF") ///
        xtitle("LASSO SHAP Rank") ytitle("Random Forest SHAP Rank") ///
        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_fearn_ind_rank_lasso_vs_rf.pdf", replace
restore




* ===========================================================================
* CROSS-MEASURE RANK CORRELATION PLOTS (fhwage vs fearn)
*
* For each risk measure (gamma, alpha) and dimension (occ, ind), build the 3x3
* set of scatter plots comparing fhwage {LASSO, NN, RF} SHAP ranks against
* fearn {LASSO, NN, RF} SHAP ranks. Each of the 9 cells is exported as its own
* PDF (36 plots total) for arrangement into 3x3 grids in LaTeX. In each plot
* x = fhwage model rank, y = fearn model rank.
* ===========================================================================

local DIR "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk"

foreach risk in gamma alpha {
    foreach dim in occ ind {

        if "`dim'" == "occ" {
            local csvstem "occupation"
            local codevar "occupationcode"
            local idvar   "occ"
        }
        else {
            local csvstem "industry"
            local codevar "industrycode"
            local idvar   "twoind"
        }

        * --- base set of codes from the analysis data ---
        preserve
            keep `idvar'
            duplicates drop `idvar', force
            rename `idvar' code
            tempfile base
            save `base'
        restore

        * --- one rank tempfile per model x measure ---
        foreach meas in fhwage fearn {
            if "`meas'" == "fhwage" local sfx ""
            else                    local sfx "_fearn"

            foreach mod in lasso nn rf {
                if "`mod'" == "lasso"   local pre "Lasso_"
                else if "`mod'" == "rf" local pre "RF_"
                else                    local pre ""

                preserve
                    import delimited using "`DIR'/`pre'`csvstem'_shap_`risk'`sfx'.csv", clear
                    rename `codevar' code
                    rename averageshapvalue avg_shap
                    destring code, replace force
                    gsort -avg_shap
                    gen rank_`mod'_`meas' = _n
                    keep code rank_`mod'_`meas'
                    tempfile rk_`mod'_`meas'
                    save `rk_`mod'_`meas''
                restore
            }
        }

        * --- merge all 6 and draw the 9 fhwage-vs-fearn scatters ---
        preserve
            use `base', clear
            foreach meas in fhwage fearn {
                foreach mod in lasso nn rf {
                    merge 1:1 code using `rk_`mod'_`meas'', nogenerate
                }
            }

            foreach xmod in lasso nn rf {
                foreach ymod in lasso nn rf {
                    quietly count if !missing(rank_`xmod'_fhwage) & !missing(rank_`ymod'_fearn)
                    local maxr = r(N)
                    twoway (scatter rank_`ymod'_fearn rank_`xmod'_fhwage, mcolor(navy)) ///
                           (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
                        title("`risk' `dim': fhwage `xmod' vs fearn `ymod'") ///
                        xtitle("fhwage `xmod' SHAP Rank") ytitle("fearn `ymod' SHAP Rank") ///
                        legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) ///
                        xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
                    graph export "`DIR'/OtherOutput/`risk'_`dim'_xrank_`xmod'_fhwage_vs_`ymod'_fearn.pdf", replace
                }
            }
        restore

    }
}







