all:
	if [[ -e begateway.zip ]]; then rm begateway.zip; fi
	cd src &&	zip -r ../begateway.zip * -x "*/test/*" -x "*/.git/*" -x "*/examples/*"
