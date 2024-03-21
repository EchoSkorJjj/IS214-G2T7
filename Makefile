PROJECT_NAME = "esm"
LOCAL_DEPLOY_DIR = "docker"

# ---------------------------------------
# For deploying docker containers locally
# ---------------------------------------
up:
	@docker compose -p ${PROJECT_NAME} \
		-f ${LOCAL_DEPLOY_DIR}/docker-compose.yml \
		up --build -d --remove-orphans

nobuild/up:
	@docker-compose -p ${PROJECT_NAME} \
		-f ${LOCAL_DEPLOY_DIR}/docker-compose.yml \
		up -d

# ---------------------------------
# For tearing down local deployment
# ---------------------------------
down:
	@docker compose -p ${PROJECT_NAME} \
		-f ${LOCAL_DEPLOY_DIR}/docker-compose.yml \
		down
down-clean:
	@docker compose -p ${PROJECT_NAME} \
		-f ${LOCAL_DEPLOY_DIR}/docker-compose.yml \
		down --volumes --remove-orphans
	@docker system prune -f

# ---------------------------------
# For deploying modules to AWS
# ---------------------------------
deploy:
	$(MAKE) -C terraform/modules deploy-all

deploy-%:
	$(call run_deploy_or_destroy,deploy,$*)

destroy:
	$(MAKE) -C terraform/modules destroy-all

destroy-%:
	$(call run_deploy_or_destroy,destroy,$*)

plan:
	$(MAKE) -C terraform/modules plan-all

plan-%:
	$(call run_deploy_or_destroy,plan,$*)

# ---------------------------------
# For deploying shared/backend to AWS
# This should only be run once
# Please do not run the below commands because they are initialised in AWS already
# ---------------------------------
deploy-shared:
	$(MAKE) -C terraform/shared deploy-shared

destroy-shared:
	$(MAKE) -C terraform/shared destroy-shared

plan-shared:
	$(MAKE) -C terraform/shared plan-shared

# Help
help:
	@echo "Available commands:"
	@echo "  init                - Set up development tools and Python virtual environment"
	@echo "  deploy              - Build and deploy all services"
	@echo "  deploy-service      - Build and deploy specific service"
	@echo "  destroy             - Destroy all services"
	@echo "  destroy-service     - Destroy specific services"
	@echo "  lint                - Lint all services"
	@echo "  test                - Test all services"
	@echo "  help                - Show this help message"
	@echo "  requirements        - Install Python requirements"
	@echo "  rover-up            - Runs Rover GUI to visualise terraform"
