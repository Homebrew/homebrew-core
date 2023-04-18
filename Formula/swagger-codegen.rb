class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.42.tar.gz"
  sha256 "a2e0ad95750aa0762fd862db7cd154a7bf29869d146498f3d0f042c5e25c20b1"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa905a438355ec3b1890bdb94b6fe9161d3ad8af6fcd05e6420ef892c5018ddf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ee5177af0c3335459416a6553edb56a5b0d4fd63dfa5a5b49af212e41a479ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bea2db1a273fd38cc4fa1a19c8e53261bf5200faac6657f9ceaca608fd91a82b"
    sha256 cellar: :any_skip_relocation, ventura:        "cc2cdc9949e75d68a24bd5499413e8b3cf1556e6ad6ef62f854f4945549ba09f"
    sha256 cellar: :any_skip_relocation, monterey:       "63b0bfb0b816a27f6cb5ff0a1ba0862255803f607127e2499ce393c2b4efd966"
    sha256 cellar: :any_skip_relocation, big_sur:        "3621c3a55d40a901f0fea92573313a76f7c51f7c304cade0205faae028cec534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afdd5e6b52555ade43ab542f2b4db318bc1468211e13972b111e29048fd109a5"
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
