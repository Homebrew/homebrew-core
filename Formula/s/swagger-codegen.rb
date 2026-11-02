class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.84.tar.gz"
  sha256 "ba7056e1a2d920598c57c03585679d6198acf2a23e50b00491edfcb38354cbcc"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ddeb5aa07746f2dc84d60de82dde902e50dfe307178a21d3a5b442327ccf9dba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ddeb5aa07746f2dc84d60de82dde902e50dfe307178a21d3a5b442327ccf9dba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ddeb5aa07746f2dc84d60de82dde902e50dfe307178a21d3a5b442327ccf9dba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0dba26630b13ea3e6df85e1a11f3a97549089491a0901c534d6c1cbb512f7325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0dba26630b13ea3e6df85e1a11f3a97549089491a0901c534d6c1cbb512f7325"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<~YAML
      ---
      openapi: 3.0.0
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
    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
