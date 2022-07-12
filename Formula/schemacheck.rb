class Schemacheck < Formula
  desc "CLI utility to validate yaml and json files against a schema written in Go"
  homepage "https://github.com/adrielp/schemacheck"
  url "https://github.com/adrielp/schemacheck.git",
    tag:      "v1.5.0",
    revision: "0650ed36e233cc780be74b135d156d728609162e"
  license "MIT"
  head "https://github.com/adrielp/schemacheck.git", branch: "main"

  depends_on "go" => :build
  depends_on "goreleaser" => :build
  depends_on "make" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"
    system "make", "build"
    bin.install "dist/schemacheck"
  end

  test do
    (testpath/"schema.json").write <<~EOF
      {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "$id": "https://example.com/product.schema.json",
        "title": "Environment",
        "description": "A JSON File.",
        "type": "object",
        "properties": {
            "key1": {
                "description": "Super cool key name",
                "type": "string"
            }
         }
      }
    EOF
    (testpath/"values.json").write <<~EOF
      {
        "key1": "Vader"
      }
    EOF
    validation_output = `#{bin}/schemacheck --schema schema.json --file values.json 2>&1`
    puts validation_output
    assert_match "INFO: schemacheck.go:129: values.json is a valid document.", validation_output
    version_ouput = shell_output(bin/"schemacheck --version 2>&1")
    puts version_ouput
    assert_match "schemacheck version: #{version}", version_ouput
  end
end
