class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.0.tar.gz"
  sha256 "76940646d8cb9e65876a6c0829361ff99ded97126b97d9e954eca03682b287aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a5955496aed7849141c5bf10e9fc5a2e9964b6f3f299d10ac0156a76d5e7a39" => :mojave
    sha256 "76ad53fa55c9f441dfebfaa3179fcb5e1a0e6cc5c2bd45ad1a9fce46abccae85" => :high_sierra
    sha256 "e832af1f7e633801a232b345c15bd5f5426429c8d5d3438591548c33b7659af3" => :sierra
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
