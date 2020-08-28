class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.15.tar.gz"
  sha256 "11991be490abcdba1051372b584ceeb5ded58d93098e2f13fd2fd89fef9d11e7"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1149ef4ed6c67c5b5724ae4deb2beaef231cb339c3d776ca2c7229b874d4eca6" => :catalina
    sha256 "c441f7af6b1e0bd43f439096f64f66cf5eb23e987cfb578aa7a8a974834721d9" => :mojave
    sha256 "2622efbf0b4aca5bd667ea70c69556d8ba91b60420ba71870c47195ba947ddcf" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on java: "1.8"

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
