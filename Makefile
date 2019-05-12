check:
	julia --project=$(PWD)/test/coverage -e 'using Coverage; clean_folder(@__DIR__)'
	julia --project=$(PWD) -e 'using Pkg; Pkg.test(coverage=true)'
	julia --project=$(PWD)/test/coverage test/coverage/coverage-summary.jl
