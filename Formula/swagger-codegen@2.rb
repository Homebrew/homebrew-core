class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.8.tar.gz"
  sha256 "513fba01b35b03fde7195f16d3b7cc36efc7f61c504f9c32470c595ab6741c4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "933369f09633b52e4ed6f667b15963d85f869c71065912d8f7a8e3f8d640f4aa" => :mojave
    sha256 "497a8f2045d6fb210135f5a02e423dca1eeca36521fad4cb7f0ecc384c08d5b3" => :high_sierra
    sha256 "b9fc346c29076314f5baf75b9ce8b9f7cdfa90aa40bfcdaab2fc48d63b64d765" => :sierra
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
