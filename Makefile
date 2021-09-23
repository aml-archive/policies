


eval:
	# opa eval --bundle=authz --input=input.json --format=pretty 'data'
	opa eval --data=authz/policy.rego \
		--input=input.json \
		--format=pretty \
		'data' 

example:
	opa eval --data=$(dir)/policy.rego --format=pretty --input=$(dir)/input.json 'data'
