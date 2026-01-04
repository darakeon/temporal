TASK_QUEUE=hello-world
WORKFLOW_TYPE=example
WORKFLOW_ID:=$$(cat last_workflow_id.txt)
NAME=Irmão

TEMPORAL := $(shell which temporal)


install:
	@mkdir temporal
	@cd temporal && curl "https://temporal.download/cli/archive/latest?platform=linux&arch=amd64" -o temporal.tar.gz
	@cd temporal && tar -xf temporal.tar.gz
	@rm temporal/temporal.tar.gz
	@sudo mkdir -p /usr/local/lib/temporal/
	@sudo mv temporal/* /usr/local/lib/temporal/
	@rm -r temporal
	@sudo ln -s /usr/local/lib/temporal/temporal /usr/local/bin/temporal

server:
	@temporal server start-dev \
		--ui-port 8080 \
		--db-filename cluster.db \
		--color always

start:
	@npm install
	@npm run start.watch

run:
	@uuidgen > last_workflow_id.txt
	@temporal workflow start \
		--type ${WORKFLOW_TYPE} \
		--task-queue ${TASK_QUEUE} \
		--workflow-id "${WORKFLOW_ID}" \
		--input '"${NAME}"'

show:
	@echo "Last Workflow ID: ${WORKFLOW_ID}"
	@temporal workflow show \
		--workflow-id "${WORKFLOW_ID}"
