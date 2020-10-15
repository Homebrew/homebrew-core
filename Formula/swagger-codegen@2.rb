class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.16.tar.gz"
  sha256 "0b786ad905a512d78374c784acd1874320764adcdcab046d2f7389a2de3663c6"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "909d4667c2b8c5f735beff4404c8ebc5584af15928ac8cdee821635ee2d552a3" => :catalina
    sha256 "c395e124b836c0d57d0b749fd8ebf73036225d9722e7d1f71bff0e033ba74a3e" => :mojave
    sha256 "bc0304846c907c859e147a4a57b0fa9ffe5f31bfd2d11f5039bec14150071afa" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on java: "1.8"

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
