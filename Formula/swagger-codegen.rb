class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.34.tar.gz"
  sha256 "981bd831f80d367a4a8deaf9bda6bb648d91b6aff41c197cbff50fd568d9a110"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be5d9576b684f8245c5788fbf358dac9c663eb421dd027c647971d2f162c08d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43f6ae9075e61e918ac33d2df89e307c59fe7d3bf2da08b13b6992eb0d23eb50"
    sha256 cellar: :any_skip_relocation, monterey:       "a801731c22723e4c772fbe1de06e06e35ede56f4dae22749781011e2c70c95ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f39915debceaa00e20c792de781840f3e795ad2e59a7f622ae7e28d5ec4396fc"
    sha256 cellar: :any_skip_relocation, catalina:       "ff4a1d402acd53f5b0c2238d19ff41bd8036d988c3cd57e5ce9dfef0ac34bcee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b0ea3086e4f9479ffd0415ace31be62e427d9005744b18519d866ae0ab6d063"
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
