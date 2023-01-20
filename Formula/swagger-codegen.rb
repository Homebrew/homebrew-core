class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.37.tar.gz"
  sha256 "a190c23cd5f4fc8fa31fc436d36d38aa37be200407d3bd0a850744eb2b7e755e"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20e38fc0301114c0b166e8bb74e0b01c23885e5171f94290806be6c48c26a1bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a715d064a7170b491df39b0c285be433460cebfb17e6e3c99e02367cafdd1c1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2abba1006a12b66baeb96b14e8abc988edd036f07ef86f983838d997eca7918d"
    sha256 cellar: :any_skip_relocation, ventura:        "c1c21b0005afac6a647bf6e56d2e1212b52ad1cc15ef69496d96d35ec919a7a5"
    sha256 cellar: :any_skip_relocation, monterey:       "9c1df6fa08d861bc0c4c19b57646551a67fcd3addced73383cd91d710ab89fef"
    sha256 cellar: :any_skip_relocation, big_sur:        "125357516098cd7b3bc59228c9cd4d204c53b113fe5909a696ed450545ec820c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a1a67ba546512dd9c3134d4f0255a0ade0535874d185b35de15ddb10b7d213"
  end

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
      openapi: 3.0.0
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
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
