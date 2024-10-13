class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.62.tar.gz"
  sha256 "33a7963c5f14b1c2de8f65e28dcf22384185123550d7c3c156e388f9189e4c80"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1dd19c43691e0f9e40a4d23bffa3e526277e5d06221f34a03478d7cf05034525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1f75f4d99cb7218ebd34847372dadb3070501559282f2128ef1dd7dcfe6675b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9efde2a2a793e26108b45ed7988fe2490e3d2b84fe0e93d29031e7688d2d821e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1f75f4d99cb7218ebd34847372dadb3070501559282f2128ef1dd7dcfe6675b"
    sha256 cellar: :any_skip_relocation, sonoma:         "36196419409b4602c2355070126b6b403c17872d0037934437acbf43b9fa394f"
    sha256 cellar: :any_skip_relocation, ventura:        "8e9bc4352d42bbc74960b00d76c1c1e0ddd9db409a4f2b9d5664b10b6b75ceb0"
    sha256 cellar: :any_skip_relocation, monterey:       "1280224b502fc17c5b9e6d5663c0084961f38ab6742a1fe2eec213ad12e4d0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6feb8f7e4e9a65224288bbf5cb720b2b4d669f3ac046bae1ac23171703075893"
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
    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
