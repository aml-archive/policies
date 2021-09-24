
eval:
	# opa eval --bundle=authz --input=input.json --format=pretty 'data'

	opa eval data.envoy.authz.allow \
		--input=authz/input.json \
		--data=authz/policy.rego \
	 	--schema=authz/schemas/schema.json \
	 	--format=pretty

example:
	opa eval --data=$(dir)/policy.rego --format=pretty --input=$(dir)/input.json 'data'
