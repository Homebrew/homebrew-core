class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.4.tar.gz"
  sha256 "7cc96656c2756f393fcf01559855d289d10832f799292755a953e7580612c9b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c43f95eb12320836718af25f031aad9178d4d1696dab8e630b4be30e0a89fa1" => :mojave
    sha256 "98b073f8ef4a729c9c2a0279a2c13f71f59469932d6f8ba71d5ebdc2a97d85f5" => :high_sierra
    sha256 "513d63d48f63f4f479de0f1ae71d0b3d49466dfb3ab654a5f793bc3571f98dba" => :sierra
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
