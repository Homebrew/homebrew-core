class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.31.tar.gz"
  sha256 "6baceedcfcb8b073f117bd44276f5ea378c0cda468efd7f0a49d740ff4b4a402"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40c393e0df7257a23cb3a208d3c86f75e0a6ee4b03bc19600d27576932b6b446"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f432646330da9ff927dbf6629fb477913464316d544337e32ad485263b51eaac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "327f1bf2731e65633a2992ff9fb39196d1aef9c2f6fe093b9e4a3687dda8369f"
    sha256 cellar: :any_skip_relocation, ventura:        "4d5efee97ca05b6aa30db42439cf35a1836553b7c63893ef093aec1cdcfbc3ac"
    sha256 cellar: :any_skip_relocation, monterey:       "21117df452f6bcaa6ff1a810ad3b2ca9f95f15564b451ad2df7a9e76e8066659"
    sha256 cellar: :any_skip_relocation, big_sur:        "78cb19d181ad2272d96d22216fe48870cfd5ffc4d3d6352dd4f6380d98c6ddfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2e87c4239af64fda1b4c440774887eb935e9e842c824776a3ffd0585fb2752"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "11"
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
