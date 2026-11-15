class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.53.tar.gz"
  sha256 "70f603ee89ed6c9249965930e375141e211b979f41e21fe6f13a32b563c2cade"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6382463d1432c3ddf7b9c5847f895d3182e12ff793da6d7c6bf08138d2e78d63"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6382463d1432c3ddf7b9c5847f895d3182e12ff793da6d7c6bf08138d2e78d63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6382463d1432c3ddf7b9c5847f895d3182e12ff793da6d7c6bf08138d2e78d63"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60c1b8fb1026f3e3872249124e59bec4703a5f19555258f47f39fad3c586bc43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "60c1b8fb1026f3e3872249124e59bec4703a5f19555258f47f39fad3c586bc43"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    java_version = "21"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    # Only build the CLI: the `swagger-generator` webapp fetches a since-renamed `swagger-ui` branch at build
    # time, and the tests need a JVM attach socket that the build sandbox denies
    system "mvn", "clean", "package", "-DskipTests", "-pl", "modules/swagger-codegen-cli", "-am"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script(libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version:)
  end

  test do
    (testpath/"minimal.yaml").write <<~YAML
      ---
      swagger: '2.0'
      info:
        version: 0.0.0
        title: Simple API
      paths:
        /:
          get:
            responses:
              200:
                description: OK
    YAML

    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes (testpath/"index.html").read, "<h1>Simple API</h1>"
  end
end
