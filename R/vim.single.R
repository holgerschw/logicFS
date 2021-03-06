vim.singleBoth<-function(primes,mat.eval,cl,useN=TRUE){
	n.col<-ncol(mat.eval)
	mat.in<-matrix(0,n.col,n.col)
	id.primes<-colnames(mat.eval)%in%primes
	n.primes<-length(primes)
	mat.in[id.primes,id.primes]<-1-diag(n.primes)
	mat.in[!id.primes,!id.primes]<-diag(n.col-n.primes)
	mat.in[id.primes,!id.primes]<-1
	mat.pred<-mat.eval%*%mat.in
	mat.pred[mat.pred>1]<-1
	vec.improve<-colSums(mat.pred==cl)
	preds<-rowSums(mat.eval[,id.primes,drop=FALSE])>0
	n.corr<-sum(preds==cl)
	vec.improve<-ifelse(id.primes,n.corr-vec.improve,vec.improve-n.corr)
	if(!useN)
		vec.improve<-vec.improve/length(cl)
	# names(vec.improve)<-colnames(mat.eval)
	vec.improve
}

vim.singleRemove<-function(primes,mat.eval,cl,useN=TRUE){
	vec.improve<-numeric(ncol(mat.eval))
	id.primes<-colnames(mat.eval)%in%primes
	mat.eval<-mat.eval[,id.primes,drop=FALSE]
	n.primes<-length(primes)
	mat.in<-1-diag(n.primes)
	mat.pred<-mat.eval%*%mat.in
	mat.pred[mat.pred>1]<-1
	improve<-colSums(mat.pred==cl)
	preds<-rowSums(mat.eval)>0
	n.corr<-sum(preds==cl)
	vec.improve[id.primes]<-n.corr-improve
	if(!useN)
		vec.improve<-vec.improve/length(cl)
	vec.improve
}


	

