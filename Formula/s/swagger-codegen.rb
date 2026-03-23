class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.78.tar.gz"
  sha256 "d936c8d525eed32edf942839dd16733c1d4bdfc28e4ed4557c5d2f55d3b28d42"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbc05b7faf526bf5ce367bd05ea68e3a6d52aba332354632ae13d9a4daabb04e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118998c0750ac6d950a8c545bf8560e02f996f2b1f80c2be46ae5641c91b174c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "535155fa18046f1c9d5ca2fcd2696e0153cad7438db40c5e64d5d9f0ac95f0b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "68fe830cad43ac807b77e385bb458cc15a1b49603277567ef6d6b41c2c04a81f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65837ea5799d785e2f5525a683afa1f882ef1d10f0b7f65e0a9e573f5ff50385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975705c95bb33ebf9e6e1fdeb09b694c3bc29abe53a8f4cccde101f8c7ff1198"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "clean", "package", "-Dnet.bytebuddy.experimental=true"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<~YAML
      ---
      swagger: "2.0"
      info:
        version: "1.0.0"
        title: Simple API
      paths:
        /:
          get:
            responses:
              "200":
                description: OK
    YAML
    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
