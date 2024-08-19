class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.43.tar.gz"
  sha256 "f89a0bf6e1bbf87722e2df26cafbc2bd71931ccbc74d9ba512023abdb2f501fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ec03eb20264764e08f6eb7d55e2b55945319d88aa15a5acd0138f08665ccffc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87ba049940e4c3d6e41bd2e1362f8c0b3c6c480fc18f2801f37ccf8f93679854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6085448a085606b84c873be01043b28269f15474a175ffb69312140cf3e0be89"
    sha256 cellar: :any_skip_relocation, sonoma:         "edaae87ebd119d7a3731e355161f998cf1a8f0cdfbdd438fcbb73532c12a14d5"
    sha256 cellar: :any_skip_relocation, ventura:        "b29629ce9e98b653bedbbcf082dd8ca09ade52dd1f385502a6e67d58ee2d9172"
    sha256 cellar: :any_skip_relocation, monterey:       "5c996e897ee9ac5eb15f17e6f4948b3cf114c90fa0e075fd92d70aad78151c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97441b532b971583ef873c3025ef8aac522223d2d505ebd8595edd546e59e420"
  end

  keg_only :versioned_formula

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
    EOS

    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes (testpath/"index.html").read, "<h1>Simple API</h1>"
  end
end
