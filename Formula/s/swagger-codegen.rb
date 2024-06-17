class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.57.tar.gz"
  sha256 "1b2cb1514758d56afc6ba3f15c647282e71ed2c0e9f42720723fe4437134ab47"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39e1c9ae77660309b58357e3de02833d1e380a9f4172453fed1617b0087f82e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "243e6d0d5b0784c58c5f00cd0bb5c448d77b2eacf219d82969a8ba272151cce9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4513c328356012b05beabee7870cab3ed0ea0d08342d453b6e4e3008262f3fa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fe138e9065bbd6f99df59e2edb8390ac513fd4181c7db0dd266c15a3ecfcf9e"
    sha256 cellar: :any_skip_relocation, ventura:        "adf8fccd71451b3d097e42d5010ab1dd73e432cb672f47fcd28ad5cd20f80bb2"
    sha256 cellar: :any_skip_relocation, monterey:       "fe66a92d63c887040c457f57006471e8ef845e678da62ef9a295dc456ad29722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11fe2f5f31dc7e985a31414ceddf3ec7725a97c30861c6ecbc4dacbfe34eb497"
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
