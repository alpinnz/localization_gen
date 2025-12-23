.PHONY: help install clean test analyze format lint check coverage publish-dry publish all run-all

# Default target
help:
	@echo "Localization Gen - Available Commands:"
	@echo ""
	@echo "Development:"
	@echo "  make install          - Install dependencies"
	@echo "  make test             - Run all tests"
	@echo "  make test-file        - Run specific test file (FILE=path/to/test.dart)"
	@echo "  make test-examples    - Run tests for all examples"
	@echo "  make analyze          - Run dart analyze"
	@echo "  make format           - Format all code"
	@echo "  make format-check     - Check code formatting"
	@echo "  make lint             - Run linter"
	@echo "  make check            - Run all checks (analyze + format + test)"
	@echo "  make coverage         - Generate test coverage report"
	@echo "  make watch            - Run tests in watch mode"
	@echo ""
	@echo "Localization:"
	@echo "  make generate         - Generate localization (for testing)"
	@echo "  make generate-watch   - Generate localization in watch mode"
	@echo "  make validate         - Validate localization files"
	@echo ""
	@echo "Examples:"
	@echo "  make example-basic    - Run basic example"
	@echo "  make example-modular  - Run modular example"
	@echo "  make examples-setup   - Setup all examples"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean            - Remove build artifacts"
	@echo "  make clean-all        - Deep clean (including cache)"
	@echo ""
	@echo "Publishing:"
	@echo "  make publish-dry      - Dry run publication"
	@echo "  make publish          - Publish to pub.dev"
	@echo ""
	@echo "Maintenance:"
	@echo "  make update           - Update dependencies"
	@echo "  make info             - Show package information"
	@echo "  make check-release    - Check if ready for release"
	@echo ""
	@echo "Shortcuts:"
	@echo "  make all              - Run install + check"
	@echo "  make run-all          - Run complete test suite (all + examples)"
	@echo ""

# Install dependencies
install:
	@echo "Installing dependencies..."
	@dart pub get || (echo "ERROR: Failed to install dependencies" && exit 1)
	@echo "SUCCESS: Dependencies installed"

# Install dependencies for all examples
examples-setup:
	@echo "Setting up examples..."
	@cd example/basic && flutter pub get || (echo "ERROR: Failed to install basic example dependencies" && exit 1)
	@cd example/modular && flutter pub get || (echo "ERROR: Failed to install modular example dependencies" && exit 1)
	@echo "SUCCESS: All examples setup complete"

# Run all tests
test:
	@echo "Running tests..."
	@dart test || (echo "ERROR: Tests failed" && exit 1)
	@echo "SUCCESS: All tests passed"

# Run tests for all examples
test-examples:
	@echo "Running tests for examples..."
	@echo ""
	@echo "Testing basic example..."
	@cd example/basic && flutter test || (echo "ERROR: Basic example tests failed" && exit 1)
	@echo "SUCCESS: Basic example tests passed"
	@echo ""
	@echo "Testing modular example..."
	@cd example/modular && flutter test || (echo "ERROR: Modular example tests failed" && exit 1)
	@echo "SUCCESS: Modular example tests passed"
	@echo ""
	@echo "SUCCESS: All example tests passed"

# Run specific test file
test-file:
	@if [ -z "$(FILE)" ]; then \
		echo "ERROR: FILE parameter required"; \
		echo "Usage: make test-file FILE=test/parser/json_parser_test.dart"; \
		exit 1; \
	fi
	@echo "Running test: $(FILE)"
	@dart test $(FILE) || (echo "ERROR: Test failed" && exit 1)
	@echo "SUCCESS: Test passed"

# Run tests with coverage
coverage:
	@echo "Generating coverage report..."
	@dart pub global activate coverage 2>/dev/null || echo "Coverage already activated"
	@dart test --coverage=coverage || (echo "ERROR: Tests failed during coverage" && exit 1)
	@echo "Converting coverage to lcov..."
	@dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib || (echo "ERROR: Coverage conversion failed" && exit 1)
	@echo "SUCCESS: Coverage report generated"
	@echo "Coverage report: coverage/lcov.info"
	@if command -v genhtml >/dev/null 2>&1; then \
		echo "Generating HTML report..."; \
		genhtml coverage/lcov.info -o coverage/html 2>/dev/null && echo "HTML report: coverage/html/index.html"; \
	else \
		echo "Note: Install lcov for HTML reports (brew install lcov)"; \
	fi

# Analyze code
analyze:
	@echo "Analyzing code..."
	@dart analyze lib bin test || (echo "ERROR: Analysis found issues" && exit 1)
	@echo "SUCCESS: Analysis passed"

# Format code
format:
	@echo "Formatting code..."
	@dart format . || (echo "ERROR: Format failed" && exit 1)
	@echo "SUCCESS: Code formatted"

# Check format without modifying
format-check:
	@echo "Checking code formatting..."
	@dart format --output=none --set-exit-if-changed . || (echo "ERROR: Code needs formatting. Run 'make format' to fix." && exit 1)
	@echo "SUCCESS: Code is properly formatted"

# Run linter
lint:
	@echo "Running linter..."
	@dart analyze --fatal-infos lib bin test || (echo "ERROR: Linter found issues" && exit 1)
	@echo "SUCCESS: Linter passed"

# Run all checks
check:
	@echo "Running all checks..."
	@echo ""
	@echo "Step 1/3: Analyzing code..."
	@dart analyze lib bin test || (echo "ERROR: Analysis failed" && exit 1)
	@echo "Analysis passed"
	@echo ""
	@echo "Step 2/3: Checking code format..."
	@dart format --output=none --set-exit-if-changed . || (echo "ERROR: Format check failed. Run 'make format' to fix." && exit 1)
	@echo "Format check passed"
	@echo ""
	@echo "Step 3/3: Running tests..."
	@dart test || (echo "ERROR: Tests failed" && exit 1)
	@echo "Tests passed"
	@echo ""
	@echo "SUCCESS: All checks passed"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/
	@rm -rf coverage/
	@rm -rf .dart_tool/
	@rm -rf example/basic/build/
	@rm -rf example/basic/.dart_tool/
	@rm -rf example/modular/build/
	@rm -rf example/modular/.dart_tool/
	@echo "SUCCESS: Clean complete"

# Deep clean including cache
clean-all: clean
	@echo "Deep cleaning..."
	@dart pub cache repair || (echo "ERROR: Cache repair failed" && exit 1)
	@echo "SUCCESS: Deep clean complete"

# Dry run publication
publish-dry:
	@echo "Testing publication..."
	@dart pub publish --dry-run || (echo "ERROR: Publication test failed" && exit 1)
	@echo "SUCCESS: Publication test passed"

# Publish to pub.dev
publish:
	@echo "Publishing to pub.dev..."
	@dart pub publish || (echo "ERROR: Publication failed" && exit 1)
	@echo "SUCCESS: Published to pub.dev"

# Run everything
all: install check
	@echo "SUCCESS: All tasks completed"

# Run complete test suite including examples
run-all: install check test-examples
	@echo ""
	@echo "========================================="
	@echo "Complete Test Suite Results"
	@echo "========================================="
	@echo "  Package Tests:     PASSED"
	@echo "  Code Analysis:     PASSED"
	@echo "  Format Check:      PASSED"
	@echo "  Example Tests:     PASSED"
	@echo "========================================="
	@echo "SUCCESS: All tests completed successfully"

# Watch mode for tests
watch:
	@echo "Running tests in watch mode..."
	@echo "Press Ctrl+C to stop"
	@dart test --watch || (echo "ERROR: Watch mode failed" && exit 1)

# Generate localization (for testing)
generate:
	@echo "Generating localization..."
	@dart run bin/localization_gen.dart || (echo "ERROR: Generation failed" && exit 1)
	@echo "SUCCESS: Localization generated"

# Generate with watch mode
generate-watch:
	@echo "Generating localization in watch mode..."
	@echo "Press Ctrl+C to stop"
	@dart run bin/localization_gen.dart generate --watch || (echo "ERROR: Watch mode failed" && exit 1)

# Validate localization files
validate:
	@echo "Validating localization files..."
	@dart run bin/localization_gen.dart validate || (echo "ERROR: Validation failed" && exit 1)
	@echo "SUCCESS: Validation passed"

# Run basic example
example-basic:
	@echo "Running basic example..."
	@cd example/basic && flutter pub get && dart run localization_gen && flutter run || (echo "ERROR: Basic example failed" && exit 1)

# Run modular example
example-modular:
	@echo "Running modular example..."
	@cd example/modular && flutter pub get && dart run localization_gen && flutter run || (echo "ERROR: Modular example failed" && exit 1)

# Update dependencies
update:
	@echo "Updating dependencies..."
	@dart pub upgrade || (echo "ERROR: Update failed" && exit 1)
	@echo "SUCCESS: Dependencies updated"

# Show package info
info:
	@echo "Package Information:"
	@dart pub deps || (echo "ERROR: Failed to get package info" && exit 1)

# Check if ready for release
check-release: check publish-dry
	@echo ""
	@echo "Checking release readiness..."
	@echo "SUCCESS: Package is ready for release"

