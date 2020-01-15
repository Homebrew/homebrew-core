class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.11.tar.gz"
  sha256 "be894d7db64059be761427b430072bcb5a3dbfa39bca4f6c2f19efa667c1aacc"

  bottle do
    cellar :any_skip_relocation
    sha256 "87c9aa9ab9aa5320ecf0676f5d49e1a89aa1abbc1911a7f70455b7f6394f959c" => :catalina
    sha256 "e52f58a2762912aa906c2b6bb61fd3f2bd9cea2b03a364f68446b5284954ceef" => :mojave
    sha256 "e64c86cc0ec2a8e5e8eed6aafb3b94594a6eca8b4de0687052774a3f84912bcc" => :high_sierra
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
