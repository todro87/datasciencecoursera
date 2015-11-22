## First function creates an object of class matrix and sets its inverse to NULL
## Second function checks if the inverse of a matrix is already cached, if yes
## it returns the cached inverse, otherwise it calculates the inverse and puts
## it into cache

## This function creates and object of class matrix. It has also the ability
## to modify it, set its inverse as well as get the inverse matrix

makeCacheMatrix <- function(x = matrix()) {
        
        inverse <- NULL # sets inverse to NULL as the matrix is new
        
        setMat <- function(m=matrix()) { # This one can modify matrix
                
                x <<- m
                inverse <<- NULL # If matrix is modified the inverse has to be NULL
                
        }
        
        getMat <- function() x # Gets the matrix
        setInv <- function(newinv=matrix()) inverse <<-newinv # Can set inverse
        getInv <- function() inverse # Can get inverse
        list(setMat=setMat, getMat=getMat, setInv=setInv, getInv=getInv) # Creates list of functions
        
}


## This function checks if inverse of a matrix already exists, if yes it returns
## the cached inverse. If not the function calculates the inverse and stores it 
## in cache to make it available through first function

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
        
        inverse <- x$getInv() # Gets inverse if x
        
        if (!is.null(inverse)) { # If inverse exists returns it
                
                message("Getting cached inverse matrix")
                return(inverse)
                
        }
        
        # Lines below calculate inverse
        data <- x$getMat() # Gets matrix
        inverse <- solve(data) # Calculates inverse
        x$setInv(inverse) # This one sends inverse to cache
        inverse # Returns inverse
        
}
