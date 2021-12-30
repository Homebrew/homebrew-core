class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.25.tar.gz"
  sha256 "bec77e14811ebc38c0f65eafd62681b2475c55cef62c900a25aef16f4a339a92"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "75a99743e24510617a652e1c8f7aec3b683f47793a3d675454d852b52e934473"
    sha256 cellar: :any_skip_relocation, catalina:     "600a66f3d45c727aadf7b9830c6d67c8b7d0e0405879a7b1cf8ad2b77113f425"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28bf1cbf4a34042fa970ca7a3cae58207bbe0319a79cda7f2a51920799a8352d"
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
