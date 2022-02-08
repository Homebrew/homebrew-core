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
    sha256 cellar: :any_skip_relocation, monterey:     "97d1889ca51c52d07c3d8679890ac6739aaebfa4905456f8170a2e566da23abc"
    sha256 cellar: :any_skip_relocation, big_sur:      "f06ba71dd69f2a184532fbea9aec9b5202173a27478d5de92eeb77d7bc914761"
    sha256 cellar: :any_skip_relocation, catalina:     "867a1e7b48e4a16729af63b317f4a88a9ddf0999a6958cd76a4de11bde5e63c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5cb9dea216f8d682a9725208f210ac2a4994766d9ef73facbcb923c17caf4ca1"
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
