.DEFAULT_GOAL := all

.PHONY: clean
clean:
	./clean.sh

.PHONY: up
up:
	./up.sh

.PHONY: kubeconfig
kubeconfig:
	./kubeconfig.sh

.PHONY: deps
deps:
	# no-op

.PHONY: prepare
prepare:
	./prepare.sh

#.PHONY: prepare
#prepare:
#	make -C ../kind prepare

.PHONY: all
all: up kubeconfig prepare
