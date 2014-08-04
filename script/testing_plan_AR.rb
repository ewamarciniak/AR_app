#TRAVERSALS

#T1: Raw traversal speed************************************************************************************************
#Traverse the Person hierarchy. As each team_member is visited, visit each of its referenced unshared Projects. As each
# project is visited, perform a depth first search on its graph of documents. Return a count of the number of documents
# visited when done.

#Traversal T2: Traversal with updates***********************************************************************************
#Repeat Traversal T1, but update objects during the traversal. There are three types of update patterns in this
# traversal. In each, a single update to a document consists of swapping its (x,y) attributes. The three types of
# updates are:
#A)	Update one document per project.
#B)	Update every document as it is encountered.
#C)	Update each document in a project four times

#Traversal T3: Traversal with indexed field updates*********************************************************************
#Repeat Traversal T2, except that now the update is on the date field, which is indexed. The specific update is to
# increment the date if it is odd, and decrement the date if it is even.

#Traversal T6: Sparse traversal speed***********************************************************************************
#Traverse the person hierarchy. As each team member is visited, visit each of its referenced unshared projects. As each
# project is visited, visit the root document Return a count of the number of documents visited when done.

#Traversals T8 and T9: Operations on Manual.
#Traversal T8***********************************************************************************************************
#Scans the address object, counting the number of occurrences of the character “I.”

#Traversal T9***********************************************************************************************************
#Checks to see if the first and last character in the address object are the same.


#QUERIES

#Query Q1: exact match lookup*******************************************************************************************
#Generate 10 random Document ids; for each generated lookup the document with that id. Return the number of documents
#processed when done.

#Queries Q2, Q3, and Q7.
#Query Q2***************************************************************************************************************
#Choose a range for dates that will contain the last 1% of the dates found in the database's Documents. Retrieve the
#Documents that satisfy this range predicate.

#Query Q3***************************************************************************************************************
#Choose a range for dates that will contain the last 10% of the dates found in the database's Documents. Retrieve the
# Documents that satisfy this range predicate.

#Query Q7***************************************************************************************************************
#Scan all documents

#Query Q4: path lookup**************************************************************************************************
#Generate 100 random legal_contract titles. For each title generated, find all TeamMembers that use the project
#corresponding to the legal_contract. Also, count the total number of team_members that qualify.

#Query Q5: single-level make********************************************************************************************
#Find all Team_members that use a project with a build date later than the build date of the team_member. Also, report
#the number of qualifying team_members found.

#Query Q8: ad-hoc join**************************************************************************************************
#Find all pairs of Legal_contracts and documents where the legal_contract_id in the document matches the id of the
#legal_contract. Also, return a count of the number of such pairs encountered.


#STRUCTURAL MODIFICATIONS

#Structural Modification 1: Insert**************************************************************************************
#Create five new projects, which includes creating a number of new documents (100 in the small configuration, 1000 in
#the large, and five new legal_contract objects) and insert them into the database by installing references to these
# projects into 10 randomly team_member objects.

#Structural Modification 2: Delete**************************************************************************************
#Delete the five newly created projects (and all of their associated documents and legal_contract objects).
