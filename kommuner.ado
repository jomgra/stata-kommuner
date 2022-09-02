/* -----------------------------------------------------------------------------------

	KOMMUNER

	Laddar in en aktuell kommunlista med 
	befolkningsuppgifter om indelning från SKL
	
	
----------------------------------------------------------------------------------- */

program kommuner 

quietly {

	local fn = substr(c(tmpdir),1,length(c(tmpdir))-1) + "\SKLKIN_" + subinstr("$S_DATE"," ","",.)
	noisily display "Laddar in Sveriges kommuner (från SKL)..."

	capture confirm file "`fn'.dta"
		if _rc==0 {
			use "`fn'.dta", replace
		}
		else {
			//  SKL info: https://catalog.skl.se/catalog/1/datasets/11
			capture import excel "https://catalog.skl.se/store/1/resource/163", firstrow clear

			foreach var of varlist _all {
				capture assert missing(`var')
				if !_rc {
					drop `var'
				}
				else {
					local lvar = lower("`var'")
					rename `var' `lvar'
				}
			}
			format %10.0g folkmängd*
			compress
			save "`fn'.dta", replace
		}

	noisily display "Klar."
}
end
