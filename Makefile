#
# If you want to see the full commands, run:
#   NOISY_BUILD=y make
#
ifeq ($(NOISY_BUILD),)
    ECHO_PREFIX=@
    CMD_PREFIX=@
    PIPE_DEV_NULL=> /dev/null 2> /dev/null
else
    ECHO_PREFIX=@\#
    CMD_PREFIX=
    PIPE_DEV_NULL=
endif

.PHONY: help
help:
	$(CMD_PREFIX) make -C training $@

.PHONY: md-lint
md-lint: ## Lint markdown files
	$(ECHO_PREFIX) printf "  %-12s ./...\n" "[MD LINT]"
	$(CMD_PREFIX) podman run --rm -v $(CURDIR):/workdir --security-opt label=disable docker.io/davidanson/markdownlint-cli2:v0.6.0 > /dev/null

AI_LAB_REPO:=https://github.com/containers/ai-lab-recipes.git
AI_LAB_REF:=a98479cf572d1f2eb6a70bfbd9ed49f4c12e0c61
.PHONY: update-training-dir
update-training-dir: ## Update the contents of the training directory
	$(ECHO_PREFIX) printf "  %-12s $(AI_LAB_RECIPES_REF)\n" "[UPDATE TRAINING DIR]"
	$(CMD_PREFIX) [ ! -d ai-lab-recipes ] || rm -rf ai-lab-recipes
	$(CMD_PREFIX) git clone ${AI_LAB_REPO} ai-lab-recipes
	$(CMD_PREFIX) mkdir -p training
	$(CMD_PREFIX) cd ai-lab-recipes && git archive $(AI_LAB_REF) training | tar -x -C ../
	$(CMD_PREFIX) rm -rf ai-lab-recipes

# Catch-all target to pass through any other target to the training directory
%:
	$(CMD_PREFIX) make -C training $@
