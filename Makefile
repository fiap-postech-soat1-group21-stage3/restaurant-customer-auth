binary:
	cd authorizer/lambda && go build  -ldflags '-s -w -linkmode external -extldflags "-static"' -o ../../tfgenerated/authorizer main.go