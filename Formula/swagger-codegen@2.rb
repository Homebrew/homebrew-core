class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.18.tar.gz"
  sha256 "dbda71ef9cf24de72056c5eb55ca3ad93ec9631ed2d136124f11b6b555e73d48"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f40d93973e1307433c76b8708bce2d0a4d7f72a33f9abb0710d591ebb88a16c4" => :big_sur
    sha256 "4ae64b61b26aed2224c479413671658e218c32570c3f3cfef8622768f66cf3df" => :catalina
    sha256 "4aec15628c6d6652aa8d34bf9dfe6e9ebec4708ef5dd06b5ebb3a9db93848bff" => :mojave
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
