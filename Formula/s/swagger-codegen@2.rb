class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.54.tar.gz"
  sha256 "568e1b5f7ff6adfe9e1bf70934bf0490a227c68caa9a24a44f389ac8b3475855"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "0da9eb5977c193c858f1c9ebc6fe2f70387e2d82b4efde7b10a43558ddee65d4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91aa9dbc21a2dab807b50cbf3ae2dadcb92d9e53a2a0a0cc216ced18376d32ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91aa9dbc21a2dab807b50cbf3ae2dadcb92d9e53a2a0a0cc216ced18376d32ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91aa9dbc21a2dab807b50cbf3ae2dadcb92d9e53a2a0a0cc216ced18376d32ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e20d43f29fb9bc3a9bc98f584f401375aacbb8cea4ad6b3083e51228a1110e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1e20d43f29fb9bc3a9bc98f584f401375aacbb8cea4ad6b3083e51228a1110e9"
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
