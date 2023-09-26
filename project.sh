#!/usr/bin/env bash
# I know, there's must be a better way to deploy and destroy this but I'm tired
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
            cd iam/
            terraform apply -auto-approve
            cd ..
            cd dynamo/
            terraform apply -auto-approve
            cd ..                    
            cd lambda/createUser
            terraform apply -auto-approve
            cd ../..
            cd lambda/deleteUser
            terraform apply -auto-approve
            cd ../..                    
            cd lambda/listUsers
            terraform apply -auto-approve
            cd ../..  
            cd lambda/modifyUser
            terraform apply -auto-approve
            cd ../..  
            cd apiGateway/
            terraform apply -auto-approve
            cd ..   
            shift
            ;;
        --destroy-all)
            echo "Destroying all resources..."
            cd apiGateway/
            terraform destroy -auto-approve
            cd ..   
            cd lambda/createUser
            terraform destroy -auto-approve
            cd ../..
            cd lambda/deleteUser
            terraform destroy -auto-approve
            cd ../..                    
            cd lambda/listUsers
            terraform destroy -auto-approve
            cd ../..  
            cd lambda/modifyUser
            terraform destroy -auto-approve
            cd ../..  
            cd dynamo
            terraform destroy -auto-approve
            cd ..
            cd dynamo
            terraform destroy -auto-approve
            cd ..                   
            cd iam/
            terraform destroy -auto-approve
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
