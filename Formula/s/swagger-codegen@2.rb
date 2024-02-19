class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.39.tar.gz"
  sha256 "3d6c735eafc457a905711918759952b1bd8b249add0dc4e2d801047629979e2f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9f6433bb4d192603ab3ec73f2fea3d3f3e202a36b16b8ba6a32488dbfe8a1de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a25e1b4e1fbc15a8e57a1aa7476c8e8ee3a95d2157735e286a5983f7af35731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9905ed2d39c0c63517499010823d2458a133a0a79dec93e1124502b9af2de16"
    sha256 cellar: :any_skip_relocation, sonoma:         "64f31b0d94a5d6947b87a01c2b4edab21c5d10db10ff71885b0d071308d394f9"
    sha256 cellar: :any_skip_relocation, ventura:        "7f74e2e365b37dba15f92c35d5089156c5aa41a4c2f671af2ba6d15b77dfeadd"
    sha256 cellar: :any_skip_relocation, monterey:       "3de42ffb02893a953984a5479753157f18a29c78c6927606ff29e5e7156cc3c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a2553abb5a656259b9a8804b0fe55da876db3f8dd6b28d08e519a533bb71e1"
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
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
