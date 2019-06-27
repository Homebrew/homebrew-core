class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.6.tar.gz"
  sha256 "03226c30e977f0dfc26749598783a59588629737f6841398a2e5834c34f5e875"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2baf65ff68e846b881535ae9617357f83016403fe9e0f9593be82552731cf23" => :mojave
    sha256 "a75187f7cadf5af077e24c5760ee9c304a9ecc39f71e87b20497a9ad7dfe1ee1" => :high_sierra
    sha256 "6544d80520c3d1cc506d2ea168aad877fba09763dbb6a3cf8cfb6e45af1edf31" => :sierra
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
