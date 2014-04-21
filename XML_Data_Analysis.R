install.packages("XML")
install.packages("plyr")
install.packages("ggplot2")
install.packages("gridExtra")

require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")

setwd("C:/Users/Tobi/Documents/R/InformIT") #you will need to change  this on  your machine
xmlfile=xmlParse("pubmed_sample.xml")
class(xmlfile) #"XMLInternalDocument" "XMLAbstractDocument"

xmltop = xmlRoot(xmlfile) #gives content of root
class(xmltop)#"XMLInternalElementNode" "XMLInternalNode"        "XMLAbstractNode"
xmlName(xmltop) #give name of node, PubmedArticleSet
xmlSize(xmltop) #how many children in node, 19
xmlName(xmltop[[1]]) #name of root's children

# have a look at the content of the first child entry
xmltop[[1]]
# have a look at the content of the 2nd child entry
xmltop[[2]]

#Root Node's children
xmlSize(xmltop[[1]]) #number of nodes in each child
xmlSApply(xmltop[[1]], xmlName) #name(s)         
xmlSApply(xmltop[[1]], xmlAttrs) #attribute(s) 
xmlSApply(xmltop[[1]], xmlSize) #size 

#take a look at the MedlineCitation subnode of 1st child
xmltop[[1]][[1]] 
#take a look at the PubmedData subnode of 1st child
xmltop[[1]][[2]]

#subnodes of 2nd child
xmltop[[2]][[1]]
xmltop[[2]][[2]]


#we can keep going till we reach the end of a branch  
xmltop[[1]][[1]][[5]][[2]] #title of first article 
xmltop[['PubmedArticle']][['MedlineCitation']][['Article']][['ArticleTitle']] #same command, but more readable

#Turning XML into a dataframe
Madhu2012=ldply(xmlToList("pubmed_sample.xml"), data.frame) #completes with errors: "row names were found from a short variable and have been discarded"
View(Madhu2012) #for easy checking that the data is properly formatted
Madhu2012.Clean=Madhu2012[Madhu2012[25]=='Y',] #gets rid of duplicated rows

#looking at which authors played most active role
FirstAuthor=Madhu2012.Clean$MedlineCitation.Article.AuthorList.Author.LastName
SecondAuthor=Madhu2012.Clean$MedlineCitation.Article.AuthorList.Author.LastName.1
ThirdAuthor=Madhu2012.Clean$MedlineCitation.Article.AuthorList.Author.LastName.2
FourthAuthor=Madhu2012.Clean$MedlineCitation.Article.AuthorList.Author.LastName.3

pdf('AuthorHist.pdf')
ggplot(Madhu2012.Clean, aes(x=FirstAuthor)) + geom_histogram(binwidth=.5, colour="pink", fill="purple")+coord_flip() #Memtsoudis most frequent
ggplot(Madhu2012.Clean, aes(x=SecondAuthor)) + geom_histogram(binwidth=.5, colour="pink", fill="purple")+coord_flip() #Yan, Chui, Kirksey most frequent
ggplot(Madhu2012.Clean, aes(x=ThirdAuthor)) + geom_histogram(binwidth=.5, colour="pink", fill="purple")+coord_flip() #Ma most frequent
ggplot(Madhu2012.Clean, aes(x=FourthAuthor)) + geom_histogram(binwidth=.5, colour="pink", fill="purple")+coord_flip() #Mazumdar most frequent
dev.off()

#write all the graphs to one canvas
a=ggplot(Madhu2012.Clean, aes(x=FirstAuthor)) + geom_histogram(binwidth=.5, colour="pink", fill="purple")+coord_flip() #1st author
b=ggplot(Madhu2012.Clean, aes(x=SecondAuthor)) + geom_histogram(binwidth=.5, colour="pink", fill="purple")+coord_flip() #2nd author
c=ggplot(Madhu2012.Clean, aes(x=ThirdAuthor)) + geom_histogram(binwidth=.5, colour="pink", fill="purple")+coord_flip() #3rd author
d=ggplot(Madhu2012.Clean, aes(x=FourthAuthor)) + geom_histogram(binwidth=.5, colour="pink", fill="purple")+coord_flip() #4th author

jpeg('AuthHist.jpeg')
grid.arrange(a,b,c,d)
dev.off()

#exporting data
write.table(Madhu2012.Clean, "Madhu2012.txt", sep="\t", row.names=FALSE)
write.csv(Madhu2012.Clean, "Madhu2012.csv", row.names=FALSE)
