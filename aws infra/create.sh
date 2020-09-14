
aws cloudformation create-stack \
--stack-name cap \
--template-body file://eks.yml \
--parameters file://eks-params.json \
--region=us-east-2 \
--capabilities CAPABILITY_NAMED_IAM
	