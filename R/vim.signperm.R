vim.perm <- function(...){
	cat("vim.perm has been removed.\n",
		"Use vim.signperm for a sign permutation based VIM ",
		"(this is the former vim.perm).\n",
		"Use vim.permInput, vim.permSNP, or vim.permSet for a label permutation",
		"\n", "based VIM for the inputs, SNPs or Sets, respectively.\n\n",
		sep="")
}

vim.signperm <- function(object, mu=0, n.perm=10000, n.subset=1000, version=1,
		adjust="bonferroni", rand=NA){
	# requireNamespace("genefilter", quietly=TRUE)
	out<-check.mat.imp(object,mu=mu)
	mat.imp<-out$mat.imp
	vim<-out$vim
	if(!version %in% 1:2)
		stop("version must be either 1 or 2.")
	stat <- if(object$type==2) rowMeans(mat.imp)  else genefilter::rowttests(mat.imp)$statistic
	B<-ncol(mat.imp)
	n.subs<-unique(c(seq(0,n.perm,n.subset),n.perm))
	n.subs<-diff(n.subs)
	larger<-numeric(length(stat))
	if(!is.na(rand))
		set.seed(rand)
	for(i in 1:length(n.subs)){
		mat.perm<-matrix(sample(c(-1,1),n.subs[i]*B,replace=TRUE),B)
		out <- compLarger(mat.imp, mat.perm, stat, B, object$type)
		larger<-larger+out
	}
	rawp<-larger/sum(n.subs)
	if(version==2)
		rawp[rawp==0] <- (10*n.perm)^-1
	adjp <- adjustPval(rawp, adjust=adjust)
	vim$vim <- if(version==1) 1-adjp else -log10(adjp)
	tmp<-if(adjust=="none") "Unadjusted"  else paste(toupper(adjust),"Adjusted\n")
	vim$measure<-paste(tmp,"Sign Permutation Based")
	vim$threshold <- ifelse(version==1, 0.95, -log10(0.05))
	vim$mu<-mu
	vim
}

adjustPval <- function(rawp, adjust="bonferroni"){
	if(adjust == "qvalue"){
		# requireNamespace("siggenes", quietly=TRUE)
		pi0 <- siggenes::pi0.est(rawp)$p0
		adjp <- siggenes::qvalue.cal(rawp, pi0)
	}
	else
		adjp <- p.adjust(rawp, method=adjust)
	adjp
}



