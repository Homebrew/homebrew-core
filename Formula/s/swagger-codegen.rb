class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.73.tar.gz"
  sha256 "bf76d4ff5a97690cf9e7bdd6e07730eb7c666377c6f7d19347412b618a4e444a"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "075217c1c5349546d4a07e158a80359f43aad8070ded349c664abff693286c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "997f7603f172f190b1b231cd332320aaf395e0573fb164a40c3d2459096db774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93bb0fd223eae6802f74f5b1f4a4cb6f830fce23ab42c55f55778f33c4ae6446"
    sha256 cellar: :any_skip_relocation, sonoma:        "950ecd66bd3780e64c1ecb1f3d12922ac0634e73ac3ce5a6470399d43ea752f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "722ef4e8f06db91638bbaba1ea818bc6538e317ea08eff6dc0bb2677131a0877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "653c100c3f79c0f4d301a2aa4e6dd258a5af701ac08b71a8ee6de128a0f6e62f"
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
