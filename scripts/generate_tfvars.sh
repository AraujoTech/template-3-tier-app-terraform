#!/bin/bash
STAGE=$1
REGION=us-east-1
AWS_LEN=$(aws ssm get-parameters-by-path --path "/${STAGE}/aws/" --region $REGION --recursive| jq '.Parameters | length')
VPC_LEN=$(aws ssm get-parameters-by-path --path "/${STAGE}/vpc/" --region $REGION --recursive| jq '.Parameters | length')
OPENSEARCH_LEN=$(aws ssm get-parameters-by-path --path "/${STAGE}/opensearch/" --region $REGION --recursive| jq '.Parameters | length')
GENERAL_LEN=$(aws ssm get-parameters-by-path --path "/${STAGE}/general/" --region $REGION --recursive| jq '.Parameters | length')
EKS_LEN=$(aws ssm get-parameters-by-path --path "/${STAGE}/eks/" --region $REGION --recursive| jq '.Parameters | length')

# Get AWS Parameters
echo "aws = {" > ./terraform/${STAGE}.tfvars
for (( i = 0; i < $AWS_LEN; i++ ))
do
    NAME=$(aws ssm get-parameters-by-path --path "/${STAGE}/aws/" --region $REGION --recursive | jq -r ".Parameters[$i].Name" | awk -F'/' '{ print $4 }')
    VALUE=$(aws ssm get-parameters-by-path --path "/${STAGE}/aws/" --with-decryption --region $REGION --recursive| jq -r ".Parameters[$i].Value")
    echo -e "\t ${NAME} = \"${VALUE}\"" >> ./terraform/${STAGE}.tfvars
done
echo "}" >> ./terraform/${STAGE}.tfvars

# Get VPC Parameters
echo "vpc = {" >> ./terraform/${STAGE}.tfvars
for (( i = 0; i < $VPC_LEN; i++ ))
do
    NAME=$(aws ssm get-parameters-by-path --path "/${STAGE}/vpc/" --region $REGION --recursive | jq -r ".Parameters[$i].Name" | awk -F'/' '{ print $4 }')
    VALUE=$(aws ssm get-parameters-by-path --path "/${STAGE}/vpc/" --with-decryption --region $REGION --recursive| jq -r ".Parameters[$i].Value")
    if [ "$NAME" == "cidr_ip" ]; then
        echo -e "\t ${NAME} = \"${VALUE}\"" >> ./terraform/${STAGE}.tfvars
    else
        echo -e "\t ${NAME} = ${VALUE}" >> ./terraform/${STAGE}.tfvars
    fi

done
echo "}" >> ./terraform/${STAGE}.tfvars

# Get OpenSearch Parameters
echo "opensearch = {" >> ./terraform/${STAGE}.tfvars
for (( i = 0; i < $OPENSEARCH_LEN; i++ ))
do
    NAME=$(aws ssm get-parameters-by-path --path "/${STAGE}/opensearch/" --region $REGION --recursive | jq -r ".Parameters[$i].Name" | awk -F'/' '{ print $4 }')
    VALUE=$(aws ssm get-parameters-by-path --path "/${STAGE}/opensearch/" --with-decryption --region $REGION --recursive| jq -r ".Parameters[$i].Value")
    echo -e "\t ${NAME} = \"${VALUE}\"" >> ./terraform/${STAGE}.tfvars
done
echo "}" >> ./terraform/${STAGE}.tfvars

# Get General Parameters
echo "general = {" >> ./terraform/${STAGE}.tfvars
for (( i = 0; i < $GENERAL_LEN; i++ ))
do
    NAME=$(aws ssm get-parameters-by-path --path "/${STAGE}/general/" --region $REGION --recursive | jq -r ".Parameters[$i].Name" | awk -F'/' '{ print $4 }')
    VALUE=$(aws ssm get-parameters-by-path --path "/${STAGE}/general/" --with-decryption --region $REGION --recursive| jq -r ".Parameters[$i].Value")
    echo -e "\t ${NAME} = \"${VALUE}\"" >> ./terraform/${STAGE}.tfvars
done
echo "}" >> ./terraform/${STAGE}.tfvars

# Get EKS Parameters
echo "eks = {" >> ./terraform/${STAGE}.tfvars
for (( i = 0; i < $EKS_LEN; i++ ))
do
    NAME=$(aws ssm get-parameters-by-path --path "/${STAGE}/eks/" --region $REGION --recursive | jq -r ".Parameters[$i].Name" | awk -F'/' '{ print $4 }')
    VALUE=$(aws ssm get-parameters-by-path --path "/${STAGE}/eks/" --with-decryption --region $REGION --recursive| jq -r ".Parameters[$i].Value")
    echo -e "\t ${NAME} = ${VALUE}" >> ./terraform/${STAGE}.tfvars
done
echo "}" >> ./terraform/${STAGE}.tfvars
