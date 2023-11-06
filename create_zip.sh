#!/bin/bash -e
(cd authorizer/ && sam build) 
#sudo apt-get install zip
(cd authorizer/.aws-sam/build/fullLambda && zip -r ../../../../fullLambda.zip .)