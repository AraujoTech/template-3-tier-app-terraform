#!/bin/bash

echo "=============================================================="
echo "WELCOME TO SETUP PARAMETERS SCRIPT"
echo "=============================================================="

echo "This script will help you to setup your environment variables in AWS SSM Parameter Store"
sleep 1
clear
echo "Would you like use the create mode or delete mode?"
echo "1. Create"
echo "2. Delete"
read MODE
case $MODE in
    1)
    echo "Create mode initiated"
    sleep 1
    clear
    echo "Would you like to insert in the single mode or get this data from a .env file?"
    echo "1. Single mode"
    echo "2. From .env file - more suitable for batch jobs"
    read ANSWER
    clear

    case $ANSWER in
        1)
        echo "Single Mode setup initiated"
        clear
        echo "Please enter your AWS region (e.g. us-east-1):"
        echo "default is us-east-1"
        read REGION
        clear
        echo "Please enter your AWS profile (e.g. default):"
        echo "default is default"
        read PROFILE
        clear
        echo "Please enter your application name (e.g. app):"
        read APP_NAME
        # until [ -z "$APP_NAME" ];
        # do
        #     clear
        #     echo "Please enter your application name (e.g. app):"
        #     read APP_NAME
        # done
        clear
        echo "Please enter the environment variable name (e.g. OPENAI_API_KEY):"
        echo "It is case sensitive"
        read ENV_NAME
        # until [ -z "$ENV_NAME" ];
        # do
        #     clear
            # echo "Please enter the environment variable name (e.g. OPENAI_API_KEY):"
            # read ENV_NAME
        # done
        clear
        echo "Please enter the tier (e.g. backend):"
        read TIER
        # until [ -z "$TIER" ];
        # do
        #     clear
        #     echo "Please enter the tier (e.g. backend):"
        #     read TIER
        # done
        clear
        echo "Please enter the environment variable value:"
        read ENV_VALUE
        clear
        echo  "Please enter the parameter type (String orSecureString):"
        echo "1. String"
        echo "2. SecureString"
        read TYPE
        clear
        case $TYPE in
            1)aws ssm put-parameter --name "/${APP_NAME}/${TIER}/${ENV_NAME}" --region "${REGION:=us-east-1}" --value "${ENV_VALUE:=' '}" --type "String" --profile ${PROFILE:=default} --overwrite ;;
            2)aws ssm put-parameter --name "/${APP_NAME}/${TIER}/${ENV_NAME}" --region "${REGION:=us-east-1}" --value "${ENV_VALUE:=' '}" --type "SecureString" --profile ${PROFILE:=default} --overwrite;;
            *) echo "Invalid option" ;;
        esac ;;
        2)
        clear
        echo "Get from .env file initiated"
        echo "Please note in this case we only can store parameter with type String"
        sleep 1.5
        clear
        echo "Please enter your .env file path (e.g. .env):"
        read ENV_PATH
        until [ -f "${ENV_PATH}" ];
        do
            clear
            echo "File ${ENV_PATH} not found"
            echo "Please enter your .env file path (e.g. .env):"
            read ENV_PATH
        done

        clear
        echo "Please enter your AWS region (e.g. us-east-1):"
        echo "default is us-east-1"
        read REGION
        clear
        echo "Please enter your AWS profile (e.g. default):"
        echo "default is default"
        read PROFILE
        clear
        echo "Please enter your application name (e.g. app):"
        read APP_NAME
        # until [ -z "$APP_NAME" ];
        # do
        #     clear
        #     echo "Please enter your application name (e.g. app):"
        #     read APP_NAME
        # done
        echo "Please enter the tier (e.g. backend):"
        read TIER
        # until [ -z "$TIER" ];
        # do
        #     clear
        #     echo "Please enter the tier (e.g. backend):"
        #     read TIER
        # done
        clear
        readarray -t lines < "${ENV_PATH}"
        for line in "${lines[@]}"; do
            if [[ $line == *=* ]]; then
                ENV_NAME=$(echo $line | cut -d '=' -f 1)
                ENV_VALUE=$(echo $line | cut -d '=' -f 2-)
                aws ssm put-parameter --name "/${APP_NAME}/${TIER}/${ENV_NAME}" --region "${REGION:=us-east-1}" --value "${ENV_VALUE:=''}" --type String --profile ${PROFILE:=stg} --overwrite
                echo "Parameter /${APP_NAME}/${TIER}/${ENV_NAME} created or updated"
            fi

        done
        ;;
        *) echo "Invalid option";;
    esac
    ;;
    2)
    echo "Delete mode initiated"
    clear
    echo "Would you like to delete in the single mode or get this data from a .env file?"
    echo "1. Single mode"
    echo "2. From .env file - more suitable for batch jobs"
    read ANSWER
    clear

    case $ANSWER in
        1)
        echo "Single Mode delete initiated"
        sleep 1
        clear
        echo "Would you like to enable the interactive mode? (y/n)"
        read INTERACTIVE
        if [[ $INTERACTIVE == "y" ]]; then
            echo "Please enter your AWS region (e.g. us-east-1):"
            read REGION
            clear
            echo "Please enter your AWS profile (e.g. default):"
            read PROFILE
            clear
            echo "Please enter your application name (e.g. app):"
            read APP_NAME
            until [ -z "$APP_NAME" ];
            do
                clear
                echo "Please enter your application name (e.g. app):"
                read APP_NAME
            done
            echo "Please enter the tier (e.g. backend):"
            read TIER
            until [ -z "$TIER" ];
            do
                clear
                echo "Please enter the tier (e.g. backend):"
                read TIER
            done
            clear
            echo "Please enter the environment variable name (e.g. OPENAI_API_KEY):"
            echo "It is case sensitive"
            read ENV_NAME
            u
            clear
            aws ssm delete-parameter --name "/${APP_NAME}/${TIER}/${ENV_NAME}" --region "${REGION:=us-east-1}" --profile ${PROFILE:=default}
        else
        echo "Please enter the name of paramether to delete: (e.g. /app/backend/OPENAI_API_KEY)"
        read ENV_NAME
        echo "Please enter your AWS region (e.g. us-east-1):"
        read REGION
        echo "Please enter your AWS profile (e.g. default):"
        read PROFILE
            aws ssm delete-parameter --name "${ENV_NAME}" --region "${REGION:=us-east-1}" --profile ${PROFILE:=stg}
            echo "Parameter ${ENV_NAME} deleted"
        fi
        ;;
        2)
        echo "Batch delete mode initated"
        sleep 1
        clear
        echo "Please note in this case you will delete all parameters related to this file"
        echo "Please enter your .env file path (e.g. ./.env):"
        read ENV_PATH
        until [ -f "${ENV_PATH}" ];
        do
            clear
            echo "File ${ENV_PATH} not found"
            echo "Please enter your .env file path (e.g. .env):"
            read ENV_PATH
        done

        clear
        echo "Please enter your AWS profile (e.g. default):"
        echo "default is default"
        read PROFILE
        clear
        echo "Please enter your AWS region (e.g. us-east-1):"
        echo "default is us-east-1"
        read REGION
        clear
        echo "Please enter your application name (e.g. app):"
        read APP_NAME

        clear
        echo "Please enter the tier (e.g. backend):"
        read TIER
        clear
        readarray -t lines < "${ENV_PATH}"
        for line in "${lines[@]}"; do
            if [[ $line == *=* ]]; then
                ENV_NAME=$(echo $line | cut -d '=' -f 1)
                ENV_VALUE=$(echo $line | cut -d '=' -f 2-)
                aws ssm delete-parameter --name "/${APP_NAME}/${TIER}/${ENV_NAME}" --region "${REGION:=us-east-1}" --profile ${PROFILE:=stg}
                echo "Parameter /${APP_NAME}/${TIER}/${ENV_NAME} deleted"
            fi

        done
        ;;
        *) echo "Invalid option";;
    esac
    ;;
    *) echo "Invalid option";;
esac
