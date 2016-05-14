VENV_DIR=.venv
WITH_VENV=. $(VENV_DIR)/bin/activate;
REQUIREMENTS_FILE=_requirements.txt
BUILD_DIR=_build
PRIMARY_TARGET=wiklish.github.io

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
	--command="$(WITH_VENV) urubu build" . & \
	echo "$$!" > builder.pid
	@trap "kill \`cat server.pid\` \`cat builder.pid\` && \
	rm server.pid builder.pid" EXIT && while true; do sleep 10; done

build: .deps
	@$(WITH_VENV) urubu build

clean:
	rm .deps
	rm -rf $(BUILD_DIR)
	rm -rf $(VENV_DIR)

_targets/%: build
	mv $@/.git $(BUILD_DIR)
	rm -rf $@
	cp -R $(BUILD_DIR) $@
	rm $@/builder.pid $@/server.pid || true
	cd $@; git add .; git commit -m "AUTO: BUILT TARGET $@"; git push origin
	git submodule update --remote
	git add .gitmodules $@
	git commit -m "AUTO: UPDATE TARGET SUBMODULE $@"

publish: _targets/$(PRIMARY_TARGET)

all: build
