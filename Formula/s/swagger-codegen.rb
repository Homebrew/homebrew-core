class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.56.tar.gz"
  sha256 "fca468c5dd7e7ad806ae39d0d7c3dac7851b75d72b6e886ec0f565bbc242bfb6"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "512fa31060662cede5e2b8cf2262c5dc6d1c508b316c998713f0226ade31d7ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6434d44c3b18aeec2fd40afa3dad0c1224f19ef3568f214c13d73a1c650fadf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e555ce29857d4ef34521a665213df51ba994429241645acccf15f22ff201ecd"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa56e5d4735c0d1a34f26d43b07c9b9d2d439d526b20c214d67a8397e7c4da32"
    sha256 cellar: :any_skip_relocation, ventura:        "cb73094a0f39d88f7a11f5ffd910c7f2b8f55ae96cc3ae736ff65d71b5dec8d1"
    sha256 cellar: :any_skip_relocation, monterey:       "910ef287c8375e7012fbb5e4e17bfc7e7b317f4bcbc2bccfb660189542e1a761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb3eb32c7f81a8289d698c4ca0c3413fd219eec7d51ac2cfe9d30e13025070e"
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
