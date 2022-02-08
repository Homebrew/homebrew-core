class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.26.tar.gz"
  sha256 "5bae383a96b8c97f4fa8def76d29da6d87c934bdd28792a0611da07f6c36b578"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "ba8af6666496ff2515d1a1a46c7ccb74d31e528662a1064ca6dfd638d1d0315d"
    sha256 cellar: :any_skip_relocation, catalina:     "0ad4cab793435a3d660eb368ee75166972198155ac5bd3cc42ee7a3cd8da4c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "89b49d9c3f64b42d5a35d05fa388709fa55f7e55413d7f93184250496e350783"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "1.8"
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
