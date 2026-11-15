class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.85.tar.gz"
  sha256 "f75a67248a97f95ae4ee21d44f68ce244afe93b2d2284ddd88ed1e3647a7246b"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "917b6d4d2b9d33e5fdee195856fb3d1614b13b0a872f5b6e43b02fdfab1a6ce0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "917b6d4d2b9d33e5fdee195856fb3d1614b13b0a872f5b6e43b02fdfab1a6ce0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "917b6d4d2b9d33e5fdee195856fb3d1614b13b0a872f5b6e43b02fdfab1a6ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ffe39f1bac4503df3f51a072e417a73de4283bac2b2df474c001d49aa89f6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6ffe39f1bac4503df3f51a072e417a73de4283bac2b2df474c001d49aa89f6f6"
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
