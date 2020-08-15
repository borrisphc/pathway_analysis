input_file <- "/home/rstudio/inputs/neg_q75.csv"
job_id <- "neg_q75"
sp <- "hs" # "mm" or "hs"
www_path = "/home/rstudio/"
output_wd <- "outputs/"

for ( uuuu in 1:4 ){
  
  
  args <- commandArgs(trailingOnly = T)
  

  # args1 = Species "mm" or "hs"
  # sp <- args[1]
  
  types <- c('kegg', 'bp', 'cc', 'mf')
  
  # args2 = type 'kegg', 'bp', 'mf', 'cc', 'all'
  # type <- args[2]
  type <- types[uuuu]
  
  
  # args3 = input file path most be csv.file
  # input_file <- args[3] 
  

 
  
  # args4 = output file path
  # output_wd <- args[4]

  # args5 = tmp file path for .runnning file & .done file
  # tmp_wd <- args[5]
  # file path for tmp file 
  tmp_wd <- "/home/rstudio/"
  # args6 = job_id 
  # job_id <- args[6]
  # job_id <- "only_smoke"
  # www_path = "/var/www/chipseek/"
  # output file path

  # c <- c(1)
  # save(c,file = paste(www_path, tmp_wd, "/10.", job_id, "_", type, ".running", sep = ""))
  
  
  ######
  
  no_id_mapped_html <- '<html>
<head>
<meta http-equiv="Refresh" content="30">
<title>Generating GO enrichment</title>
<!-- include the Tools -->
<script src="js/jquery.tools.min.js"></script>
<!-- standalone page styling (can be removed) -->
<link rel="stylesheet" type="text/css" href="/media/css/tabs.css" />
</head>

<body>
<br><br><br><br>
<p style="text-align: center;">
&nbsp;</p>
<p style="text-align: center;">
<span style="font-size:20px;">NO ID mapped<br>
</span></p>
<p style="text-align: center;">
<span style="font-size:20px;">This page will <strong><span style="color: rgb(255, 0, 0);">be empty
</body></html>'
  
  
  kegg_no_pathway_enriched_html <- '<html>
<head>
<meta http-equiv="Refresh" content="30">
<title>Generating GO enrichment</title>
<!-- include the Tools -->
<script src="js/jquery.tools.min.js"></script>
<!-- standalone page styling (can be removed) -->
<link rel="stylesheet" type="text/css" href="/media/css/tabs.css" />
</head>

<body>
<br><br><br><br>
<p style="text-align: center;">
&nbsp;</p>
<p style="text-align: center;">
<span style="font-size:20px;">KEGG NO pathway enriched <br>
</span></p>
<p style="text-align: center;">
<span style="font-size:20px;">This page will <strong><span style="color: rgb(255, 0, 0);">be empty
</body></html>'
  
  
  go_no_pathway_enriched_html <- '<html>
<head>
<meta http-equiv="Refresh" content="30">
<title>Generating GO enrichment</title>
<!-- include the Tools -->
<script src="js/jquery.tools.min.js"></script>
<!-- standalone page styling (can be removed) -->
<link rel="stylesheet" type="text/css" href="/media/css/tabs.css" />
</head>

<body>
<br><br><br><br>
<p style="text-align: center;">
&nbsp;</p>
<p style="text-align: center;">
<span style="font-size:20px;">GO NO pathway enriched <br>
</span></p>
<p style="text-align: center;">
<span style="font-size:20px;">This page will <strong><span style="color: rgb(255, 0, 0);">be empty
</body></html>'
  
  
  ######
  
  library("clusterProfiler")
  #library("openxlsx")
  #library("tidyverse")
  library("org.Hs.eg.db")
  library("org.Mm.eg.db")
  library("enrichplot")
  
  raw_data <- read.csv(input_file)
  
  # ID <- unique(raw_data$Nearest.PromoterID)
  entrez_id <- raw_data$x
  
  species <- 'org.Hs.eg.db'
  kegg_species <- "hsa"
  all_entrez_id <- mappedkeys(org.Hs.egUNIGENE)
  # if ( sp == "hs" ){
  #   
  #   species <- 'org.Hs.eg.db'
  #   kegg_species <- "hsa"
  #   all_entrez_id <- mappedkeys(org.Hs.egUNIGENE)
  #    
  #   ans_id <- c()
  #   for (i in 1:length(raw_data[,1])) {
  #     tryCatch({
  #       ans_id[i] <-  get( as.character( ID[i] ), org.Hs.egREFSEQ2EG)
  #     }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  #   }
  #   
  #   entrez_id <- na.exclude( ans_id )
  # }
  # 
  # if ( sp == "mm" ){
  #   
  #   species <- 'org.Mm.eg.db'
  #   kegg_species <- "mmu"
  #   all_entrez_id <- mappedkeys(org.Mm.egUNIGENE)
  #   
  #   ans_id <- c()
  #   for (i in 1:length(raw_data[,1])) {
  #     tryCatch({
  #       ans_id[i] <-  get( as.character( ID[i] ), org.Mm.egREFSEQ2EG)
  #     }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  #   }
  # 
  #   entrez_id <- na.exclude( ans_id )
  # }
  #print(ID)
  #print(entrez_id)
  # setwd(paste(www_path, output_wd, sep=""))
  # Sys.setenv(HOME=www_path)
  if( length(entrez_id)==0 ){
    
    no_id_mapped_html <- paste(as.character(no_id_mapped_html), collapse = "\n")
    
    write.table(no_id_mapped_html, 
                file= paste(www_path, output_wd, "/", job_id, "_",type,"output1.html",sep = ""), 
                quote = FALSE,
                col.names = FALSE,
                row.names = FALSE)
    
    write.table(no_id_mapped_html, 
                file= paste(www_path, output_wd, "/", job_id, "_",type,"output2.html",sep = ""), 
                quote = FALSE,
                col.names = FALSE,
                row.names = FALSE)
    save(c,file = paste(www_path, tmp_wd, "/10.", job_id, "_", type, ".done", sep = ""))
    stop("no ID mapped")
  }
  
  
  # bitr(aaa$Nearest.PromoterID, fromType = "SYMBOL", toType = "ENTREZID", OrgDb="org.Hs.eg.db")
  #data(geneList, package = "DOSE")
  #entrez_id <- names(geneList)[1:100]
  #entrez_id<- ans_id %>% na.exclude() %>% .[1:900]
  
  if ( type  == 'kegg' ){
    res <- enrichKEGG( gene = entrez_id
                       , organism = kegg_species
                       , pvalueCutoff = 0.01)
  }
  
  
  #print(1)
  if ( type =="bp" ){
    res <- clusterProfiler::enrichGO( gene          = as.numeric( entrez_id ),
                                      universe      = all_entrez_id,
                                      OrgDb         = species,
                                      ont           = "BP",
                                      pAdjustMethod = "BH",
                                      pvalueCutoff  = 0.01,
                                      qvalueCutoff  = 0.05,
                                      readable      = TRUE)
  }
  #print(2)
  
  if ( type =="mf" ){
    res <- clusterProfiler::enrichGO( gene          = as.numeric( entrez_id ),
                                      universe      = all_entrez_id,
                                      OrgDb         = species,
                                      ont           = "MF",
                                      pAdjustMethod = "BH",
                                      pvalueCutoff  = 0.01,
                                      qvalueCutoff  = 0.05,
                                      readable      = TRUE)
  }
  
  if ( type =="cc" ){
    res <- clusterProfiler::enrichGO( gene          = as.numeric( entrez_id ),
                                      universe      = all_entrez_id,
                                      OrgDb         = species,
                                      ont           = "CC",
                                      pAdjustMethod = "BH",
                                      pvalueCutoff  = 0.01,
                                      qvalueCutoff  = 0.05,
                                      readable      = TRUE)
  }
  #emapplot(res, pie_scale=1.5,layout="kk") 
  
  #setwd(output_wd)
  
  if ( nrow(summary(res))==0 ){

    save(c,file = paste(www_path, output_wd, job_id, "_",type,"no_pathway_enrich",".txt",sep = ""))
    if (type == "kegg"){
      kegg_no_pathway_enriched_html <- paste(as.character(kegg_no_pathway_enriched_html), collapse = "\n")
      print("no_pathway_enriched")
      write.table(kegg_no_pathway_enriched_html, 
                  file= paste(www_path, output_wd, job_id, "_",type,"_","output1.html",sep = ""), 
                  quote = FALSE,
                  col.names = FALSE,
                  row.names = FALSE)
      
      write.table(kegg_no_pathway_enriched_html, 
                  file= paste(www_path, output_wd, job_id, "_",type,"_","output2.html",sep = ""), 
                  quote = FALSE,
                  col.names = FALSE,
                  row.names = FALSE)
      print(no_pathway_enriched_html)
    } else {
      go_no_pathway_enriched_html <- paste(as.character(go_no_pathway_enriched_html), collapse = "\n")
      print("no_pathway_enriched")
      write.table(go_no_pathway_enriched_html, 
                  file= paste(www_path, output_wd, job_id, "_",type,"_","output1.html",sep = ""), 
                  quote = FALSE,
                  col.names = FALSE,
                  row.names = FALSE)
      
      write.table(go_no_pathway_enriched_html, 
                  file= paste(www_path, output_wd, job_id, "_",type,"_","output2.html",sep = ""), 
                  quote = FALSE,
                  col.names = FALSE,
                  row.names = FALSE)
      print(go_no_pathway_enriched_html)
    }
    
    
  } else {
    path_for_rmd <- paste(output_wd,paste(job_id,type,"pathway_res.Rdata",sep = "_"), sep = "")
    edox <- setReadable(res, species, 'ENTREZID')
    save( res, edox, type, species, file = path_for_rmd )
    
    #Sys.setenv(RSTUDIO_PANDOC="/usr/local/lib/R/site-library/rmarkdown/rmd/h/pandoc")
    
    #Sys.setenv(RSTUDIO_PANDOC="/usr/local/miniconda/bin/pandoc")
    rmarkdown::render(paste(www_path, 'Page_1.Rmd', sep=""),
                      output_file = paste(www_path, output_wd, job_id, "_",type,"_","output1.html",sep = ""),
                      params = list( 
                        pathway_res = path_for_rmd
                      )
    )
    
    rmarkdown::render(paste(www_path, '/Page_2.Rmd', sep=""),
                      output_file = paste(www_path, output_wd,job_id, "_",type,"_","output2.html",sep = ""),
                      params = list( 
                        pathway_res = path_for_rmd#,
                        #spp = species
                      )
    )
    # rm Rdata file
    #system( paste("rm -f ", paste(www_path, output_wd, sep="") , paste(job_id,"pathway_res.Rdata",sep = "_"), sep = "" ) )
    
  }
  
  #save(c,file = paste(www_path, tmp_wd, "/10.", job_id, "_", type, ".done", sep = ""))
  
  
  print(type)
}

#  只有50算得出來
