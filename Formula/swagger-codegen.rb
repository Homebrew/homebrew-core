class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.26.tar.gz"
  sha256 "01db9839aa443f4c351324c4150af8b5e06eca95452e6195354c3fcd91a052b3"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4174bfcb8d3f5809017cbfc9ba3af8e474a969bbfd8ed81d1848568dcb0a0df"
    sha256 cellar: :any_skip_relocation, big_sur:       "f892a33ad66e1e5de46a01f4fb832d6b7d412f5bc0444a891a0246a962cc59d4"
    sha256 cellar: :any_skip_relocation, catalina:      "e4d0ec8d4c8cdc8f0d8e7b666d2c3e79e5dd81a3abc6c6541abab8fb72eb1131"
    sha256 cellar: :any_skip_relocation, mojave:        "96c06c66bf4781aa2dccc71cf65edcfb9c60fb2a34177612049acb9c17db20d6"
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
