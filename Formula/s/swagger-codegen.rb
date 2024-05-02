class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.55.tar.gz"
  sha256 "0f02ee654c9240f550cdfd516e1e17bc677a887e6babff55c51b0faaa0d8032c"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0159395bdb2aaeb46279c40e297c682cf89eab2b3010607d58c37e6536e9148"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "211cde14fa1047dacbb5e8890591299abf516409e30aa6f9dc77fe051edfbc8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "211cde14fa1047dacbb5e8890591299abf516409e30aa6f9dc77fe051edfbc8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1595aa04e4ff91b78d25d2cd44e348fd99773f463a2dc0f5185b907963b55d9"
    sha256 cellar: :any_skip_relocation, ventura:        "e2e886f51f881efc7412d6d11f07792eaa5048b2a11375e9c9b5385887b59ea1"
    sha256 cellar: :any_skip_relocation, monterey:       "605d9c9658499e46c120adbbfb40055c9f7fa02652b1fd645094d4764c240bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359803bca30a4845252592703be20e747957fc2a159e8e305aecbe4b44fd746d"
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
