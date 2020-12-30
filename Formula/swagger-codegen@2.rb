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
    sha256 "98cfff49973a3275672bf50b263e71f3188d27638ce2c4fc6920c327e293fc89" => :big_sur
    sha256 "86fd64b89489cfb4a376aa5f37927d39a31c62822927dd111b690905b943aee8" => :catalina
    sha256 "a8d0a5b33d8e4fd77b2cfe7a1d606b32ceb63cba16116bda17c7222561278757" => :mojave
    sha256 "516a29728d07daae99423110c23082ceddef8638bd83d91721e80a42eb0af340" => :high_sierra
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
