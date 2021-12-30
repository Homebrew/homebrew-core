class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.31.tar.gz"
  sha256 "70085942d3356aed80c56ea5944f0926b6dc72a4d630d0cd3ddd54fab41c56ce"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0180e0bdcc1215b694b67091af95cddf22c4b3a59adcc8dd102f7af3b0578ae8"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5b0fc16dfb177fde212c57142043d9382388dc1952c424108ac36db3fce1490"
    sha256 cellar: :any_skip_relocation, catalina:      "1ea59e4244ab1868b797a0cf016f60dc10289b0959455ca5ad94a45b29ac921a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf00b31df6ab441fd825b377a62ef44e04352c3464cba96ea0f620d6c35c239"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "11"
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
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
    EOS
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
