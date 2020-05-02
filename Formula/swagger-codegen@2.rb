class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.13.tar.gz"
  sha256 "55679a5359bacad56ffe510ca514090d26a8dbd367a01de5472fd40ce1a75286"

  bottle do
    cellar :any_skip_relocation
    sha256 "76cfaccf0ba7e190381d04b08078e14e27dcb46d572d85f6f4097d78563c6113" => :catalina
    sha256 "38d11eaecb8e3d0f555b8fdac370df7f5b09c41eacbc1ba70db7f51bf00cc9c9" => :mojave
    sha256 "a7a408013e8775c8cd959a716e0266f2c61bd595011135ee9d605c1d05765858" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on :java => "1.8"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
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
