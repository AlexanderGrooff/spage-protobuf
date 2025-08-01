#!/bin/bash

# Script to regenerate protobuf code for both Go and TypeScript
# Usage: ./scripts/regenerate.sh

set -e

echo "🔄 Regenerating protobuf code..."

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -f "Makefile" ]; then
    echo "❌ Error: This script must be run from the spage-protobuf directory"
    exit 1
fi

# Clean previous generated files
echo "🧹 Cleaning previous generated files..."
make clean

# Generate Go code
echo "🔧 Generating Go code..."
make proto-go

# Generate TypeScript code
echo "🔧 Generating TypeScript code..."
make proto-ts

# Check if files were generated
echo "📁 Checking generated files..."

GO_FILES=$(find spage -name "*.pb.go" | wc -l)
TS_FILES=$(find generated/typescript -name "*.ts" | wc -l)

echo "✅ Generated $GO_FILES Go files"
echo "✅ Generated $TS_FILES TypeScript files"

# Show the structure
echo ""
echo "📂 Generated file structure:"
echo "Go files:"
find spage -name "*.pb.go" -exec echo "  {}" \;
echo ""
echo "TypeScript files:"
find generated/typescript -name "*.ts" -exec echo "  {}" \;

echo ""
echo "🎉 Regeneration complete!"
echo ""
echo "💡 Next steps:"
echo "  1. Update consuming projects to use the new types"
echo "  2. Test the changes in spage-daemon, spage-api, and spage-web"
echo "  3. Commit the changes with a descriptive message"
