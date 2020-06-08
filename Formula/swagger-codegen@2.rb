class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.14.tar.gz"
  sha256 "0042eb69d804fb80316c8aeccd52eb2b2a573e6e08883395de9168c55b14a2f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae83be14ef662c56355dbcb6adfd3776e7cde0f093e2b006c994501da85decaa" => :catalina
    sha256 "cf4b5ae78cd0fb2a8662751b83180948ff46126aa24832eb499229d74041693d" => :mojave
    sha256 "8275c272491a58ed7a6e4207f2c3761d82fce0e07f0f37fc931383b5343b38e3" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on :java => "1.8"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.safe_popen_read(cmd).chomp

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
