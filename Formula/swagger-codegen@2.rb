class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.9.tar.gz"
  sha256 "753e80c3286ebfd6d783d756616e79fbe70cec999ce1e394265d5ce1888ea76e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a7564506bb5e3b944e7a0bdcb8143932da96c6420b2849fef1ec71ee870dc6e" => :catalina
    sha256 "4132e890d79cf03662c756af325b8e29d6bec90e51663422b7aa18828e424f7e" => :mojave
    sha256 "5af0a9d1c78c497bb2f16aa9efbc16f69341df4b12050b2f0169ac9d8b1e11b8" => :high_sierra
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
