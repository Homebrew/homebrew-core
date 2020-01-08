class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.10.tar.gz"
  sha256 "e70b7f6fc24093c7a8ea87a9ac5ec41c7f2a07de483b3b53eaf9a063bd45e795"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b8765c76e4f85d70a83752e5233444e70fb94a1686ba677067cae22fb453dd7" => :catalina
    sha256 "1e63476bc5fcb754649200f730032384ebcf89d25bc6d74fe367ab273c2f6d3b" => :mojave
    sha256 "fe8d92368bcd090b7a0ba6d0f23df7869228cb11babae4c194827d2cbeaed2d2" => :high_sierra
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
