library(rvest)
library(stringr)
library(tidyr)
library(curl)

excelOutputFile = "C:/Users//////UNL_Course_Info.csv" # insert your own path here

mainList =
    list("acct/", "acts/", "adpr/", "abus/", "aecn/", "agen/", "alec/", "agri/", "agro/", "asci/", "anth/", "aren/", "arch/", "ahis/", "artp/", "cerm/", "draw/", "grph/", "pant/", "phot/", "prnt/", "sclp/", "arts/", "watc/", "astr/", "bioc/", "bios/", "bsen/", "bime/",
"brdc/", "chme/", "chem/", "cyaf/", "cive/", "clas/", "comm/", "crpl/", "cdev/", "csce/", "cone/", "cnst/", "crim/", "econ/", "educ/", "cehs/", "edad/", "edps/", "ecen/", "engr/", "eaep/", "engl/", "ento/", "entr/", "enve/", "ethn/", "fina/", "fdst/",
"fors/", "fren/", "geog/", "geol/", "geos/", "germ/", "gero/", "grba/", "grdc/", "gpsp/", "grek/", "hebr/", "hist/", "hort/", "hrtm/", "hums/", "imse/", "ibms/", "ides/", "jomc/", "jour/", "jgrd/", "juds/", "larc/", "latn/", "law/", "life/", "mngt/", "mrkt/",
"matl/", "math/", "mech/", "msym/", "mrst/", "metr/", "modl/", "musc/", "muap/", "mucp/", "muen/", "muop/", "mued/", "muco/", "mudc/", "nres/", "ngen/", "nutr/", "phil/", "phys/", "dplh/", "plpt/", "pols/", "psyc/", "raik/", "relg/", "russ/",
"scil/", "socw/", "soci/", "span/", "sped/", "slpa/", "stat/", "scma/", "sram/", "teac/", "tmfd/", "thea/", "tlmt/", "vbms/", "vmed/", "wats/", "wmns")

sitesUNL <- paste("https://catalog.unl.edu/graduate-professional/courses/", mainList, sep="")

out <<- list()
complete = function(xyz) {
    out <<- c(out, list(xyz))
}

for (i in 1:length(sitesUNL)) {
    curl_fetch_multi(
    sitesUNL[i]
    , done = complete
    , fail = print
    , handle = new_handle(customrequest = "GET")
    )
}

multi_run()

allOutput <- lapply(out, function(x) {

    webpage <- read_html(x$content)
    cSubj <- html_nodes(webpage, "[class~=\"cb_subject_code\"]")
    cNumber <- html_nodes(webpage, "[class~=\"cb_course_number\"]")
    cDesc <- html_nodes(webpage, "[class~=\"title\"]")
    sub <- html_text(cSubj)
    num <- html_text(cNumber)
    desc <- html_text(cDesc)
    outInfo <- cbind(sub, num, desc)
})

mainDF <- do.call(rbind, allOutput)

write.csv(mainDF, file = excelOutputFile, row.names = FALSE)
