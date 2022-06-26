class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.27.tar.gz"
  sha256 "d0a11cb5ca141cf2f5db28c3d88ce2685c49cc2544ea1f12bae6c1f414f24798"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "c64e5c92b7d19a5d17d63174f101884aba3a7a9265f42467a521378257491ae7"
    sha256 cellar: :any_skip_relocation, big_sur:      "f7a80d9c84ca79b5461ad7f59b1ec009d8af6de7ceb5cb3605455d6a60330ab4"
    sha256 cellar: :any_skip_relocation, catalina:     "a2d47d074b31e4d42f11769925b79d5f54adc5890debd3ee0954795da77bb930"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "47a48826b0a8253bac8fdc39acba4146b0a4d47f4c8f9f9232f1558adc1c5839"
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
