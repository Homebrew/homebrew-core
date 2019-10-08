class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.8.tar.gz"
  sha256 "513fba01b35b03fde7195f16d3b7cc36efc7f61c504f9c32470c595ab6741c4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6d1b2fc744c3c124ee55b7d2198dee4d3e3c20dad9f8ba94b3ca7c19cb9f04a" => :mojave
    sha256 "bd0465bf9ea0d3538b8bd6d226cb9696c8de952243fb374291ac90b722ac1c1d" => :high_sierra
    sha256 "13e305c8dbf7f6a56de187da9d1267bed96b678c03f0fe10a3e547ddd95a3e9d" => :sierra
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
