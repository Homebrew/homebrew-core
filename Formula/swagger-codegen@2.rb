class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.1.tar.gz"
  sha256 "235d8a97b2aca7bad5246cceb94c322008dd58d621924c9a97c41c23b2d1f4f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "769c7e1a6b378faaf84172a4e9ab960300df554ddf7a3387415aed70f4df1acb" => :mojave
    sha256 "63c89bc821776da016325b7ed76679a6f5a2380023801b74975a2a3e9a7f7da3" => :high_sierra
    sha256 "7f94e593e6ba40496cdeaf162eeeb574da408b8592dbf8eff42715753b75aa18" => :sierra
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
