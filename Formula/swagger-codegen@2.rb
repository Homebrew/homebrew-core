class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.14.tar.gz"
  sha256 "0042eb69d804fb80316c8aeccd52eb2b2a573e6e08883395de9168c55b14a2f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "121cc4b8277a93d7c21574de981dc473880e96279c563d8e2e56ede38095dab1" => :catalina
    sha256 "60b725db74b4689556ecb0c7fb0af2d92022669bd1450a767a8efcb23083c03c" => :mojave
    sha256 "274e510aec367dc0a4a1c6ce110ae65818041d6c095f5efc4057da49fc29582a" => :high_sierra
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
