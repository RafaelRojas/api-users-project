#!/usr/bin/env bash

# Function to display help message
function display_help {
    echo "Usage: $0 [--deploy-all] [--destroy-all] [--populate-db]"
    echo "--deploy-all: Deploy all resources."
    echo "--destroy-all: Destroy all resources."
    echo "--populate-db: Populate the database."
    exit 1
}

# Check for command line arguments
if [ $# -eq 0 ]; then
    display_help
fi

# Process command line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --deploy-all)
            # Add deployment logic here
            echo "Deploying all resources..."
            alias tf='terraform'

            # Change directory and apply Terraform in each directory
            for dir in iam dynamo; do
                cd "$dir"
                tf init
                tf apply -auto-approve
                cd ..
            done
            for dir in lambda/createUser lambda/modifyUser lambda/listUsers lambda/deleteUser; do
                if [ -d "$dir" ]; then
                    cd "$dir"
                    tf init
                    tf apply -auto-approve
                    cd ..
                fi
            done
            cd ../..
            cd apiGateway
            tf init
            tf apply -auto-approve
            cd ..
            shift
            ;;
        --destroy-all)
            # Add destruction logic here
            echo "Destroying all resources..."
                        echo "Deploying all resources..."
            alias tf='terraform'

            # Change directory and apply Terraform in each directory
            for dir in iam dynamo; do
                cd "$dir"
                tf init
                tf destroy -auto-approve
                cd ..
            done
            for dir in lambda/createUser lambda/modifyUser lambda/listUsers lambda/deleteUser; do
                if [ -d "$dir" ]; then
                    cd "$dir"
                    tf init
                    tf destroy -auto-approve
                    cd ..
                fi
            done
            cd ../..
            cd apiGateway
            tf init
            tf apply -auto-approve
            cd ..
            shift
            ;;
        --populate-db)
            # Add database population logic here
            echo "Populating the database..."
            cd dynamo
            aws dynamodb batch-write-item --request-items file://batch-write-users.json
            shift
            ;;
        *)
            # Invalid argument, exit with an error message
            echo "Invalid parameter"
            exit 1
            ;;
    esac
done

# Add any additional logic or commands here
