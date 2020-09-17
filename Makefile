pretty:
	find . -name '*.py' -exec autopep8 --verbose --in-place --aggressive {} \;
