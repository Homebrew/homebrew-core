class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.19.tar.gz"
  sha256 "ae2e96c023551d5748113912bc9450d67bd20b685bd5eb241458a3a9beb0e0d6"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b1924505bfedc170cbc416c8cee7ab3cc338b8c7c8324adbbd95c95788246221"
    sha256 cellar: :any_skip_relocation, catalina: "958f5d77a0767b75843a0c1c480a118a9a0b5c4ad0e6b9b0792db05e72ecdd08"
    sha256 cellar: :any_skip_relocation, mojave:   "7ce0421c6174917a9773507e239bc2a8826b20ec1b3af54477c7772d3d1c5e6b"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@8"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "1.8"
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
