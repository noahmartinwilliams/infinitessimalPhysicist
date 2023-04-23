main: finite-answers.json
	./trainer.py

finite.json: 
	twint-zero -Query:"from:@finitePhysicist" -Format "json" > finite.json

finite-answers.json: finite.json
	tac tweets.json | ./change_json.pl > finite-answers.json


