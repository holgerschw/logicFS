predict.logregmodel<-function(object,newbin,type,...){
	if(!type%in%c(1:3,9))
		stop("Currently only available for classification and linear and\n",
			"(multinomial) logistic regression.")
	mat.model<-cbind(1,eval.logreg(object,newbin))
	pred<-mat.model%*%object$coef
	if(type==1)
		pred[pred!=0]<-1
	if(type==3)
		pred<-exp(pred)/(1+exp(pred))
	pred
}

