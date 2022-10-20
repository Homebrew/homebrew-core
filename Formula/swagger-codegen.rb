class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.35.tar.gz"
  sha256 "dd041dba3de05c2c2cce6c69f6ed861168f127eed2e375b8f2080fd07b89bddc"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ca0829d3e3796ec035be8df87dbe64a52845f35cb6e76c5640d0907affa17ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92278b1722babad53fdecb654977dfae35e607e5ce4a4406bd0e089168a4f25f"
    sha256 cellar: :any_skip_relocation, monterey:       "f5f3de0de1a42d99d4ad3044cbe13926e4860792bb8d650892c0fc579c552dbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "993d49ca3fa816a2e67f49f5f57bfa730dd01df739b9b67c71b407e49dc8a1a4"
    sha256 cellar: :any_skip_relocation, catalina:       "66ffbc0f1a75815c14b42170626df2c3de0e4c9c07a73cf4049fe86ff261e287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f5690eacaca68437e6da012e70861e01d0fd3a293e0475122d9fd480070e61"
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
