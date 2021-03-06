vim.norm<-function(object,mu=0){
	# requireNamespace("genefilter", quietly=TRUE)
	check.out<-check.mat.imp(object,mu=mu)
	mat.imp<-check.out$mat.imp
	vim<-check.out$vim
	stat<-genefilter::rowttests(mat.imp)$statistic
	names(stat)<-rownames(mat.imp)
	vim$vim<-stat
	vim$measure<-"Standardized"
	vim$threshold<-qt(1-0.05/nrow(mat.imp),ncol(mat.imp)-1)
	vim$mu<-mu
	vim
}


	