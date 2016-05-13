VENV_DIR=.venv
WITH_VENV=source $(VENV_DIR)/bin/activate;
REQUIREMENTS_FILE=_requirements.txt

.PHONY: clean serve build publish

$(VENV_DIR):
	virtualenv $(VENV_DIR)

.deps: $(REQUIREMENTS_FILE) $(VENV_DIR)
	$(WITH_VENV) pip install -r $(REQUIREMENTS_FILE)
	touch $@

serve: .deps
	@$(WITH_VENV) urubu serve & echo "$$!" > server.pid
	@$(WITH_VENV) watchmedo shell-command \
	--ignore-directories --patterns="*.md" --recursive \
	--command="source .venv/bin/activate; urubu build" . & \
	echo "$$!" > builder.pid
	@trap "kill \`cat server.pid\` \`cat builder.pid\` && \
	rm server.pid builder.pid" EXIT && while true; do sleep 10; done

build: .deps
	@$(WITH_VENV) urubu build

clean:
	rm .deps
	rm -rf _build
	rm -rf $(VENV_DIR)

publish: build
	git subtree push --prefix _build origin gh-pages

all: build
