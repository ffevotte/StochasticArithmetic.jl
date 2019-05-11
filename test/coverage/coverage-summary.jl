####
#### Coverage summary, printed as "(percentage) covered".
####
#### Useful for CI environments that just want a summary (eg a Gitlab setup).
####

using Coverage
coverage = cd(joinpath(@__DIR__, "..", "..")) do
    coverage = process_folder()
    covered_lines, total_lines = get_summary(coverage)
    percentage = covered_lines / total_lines * 100
    println("($(percentage)%) covered")

    coverage
end
LCOV.writefile("coverage-lcov.info", coverage)

cd(joinpath(@__DIR__, "..", "..")) do
    run(`genhtml test/coverage/coverage-lcov.info --output-directory test/coverage/html`)
end
