#!/bin/bash -e

FUZZ_TARGETS=($(find fuzz_targets -type f -name "*.rs" -exec basename {} .rs \;))
echo "Number of fuzz targets to test: ${#FUZZ_TARGETS[@]}"

DETECTED_FAILURE=0
for target in "${FUZZ_TARGETS[@]}"; do
    echo "Running fuzz test: $target"
    if ! cargo fuzz run "$target" --release -- -max_total_time=4; then
        echo "Fuzz test failed: $target"
        DETECTED_FAILURE=1
    fi
done

echo # print a new line for easier spotting of output
if [ $DETECTED_FAILURE -ne 0 ]; then
    echo "ERROR: One or more fuzz tests failed"
    exit 1
else
    echo "All fuzz tests completed successfully."
fi
