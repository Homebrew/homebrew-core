class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.53.tar.gz"
  sha256 "968fe5bf44cb8c6da6f58dc5957df5ea608df0f95812619a7bd6edc9c950aba1"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59d074d064d7eb49b4b1317af2accf9253f6992de2d9bce3bbfb48c0435a91e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5ac227466a443584221da772bcfbf63eb978877ddc13d60e90728d321c0f0aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d074d064d7eb49b4b1317af2accf9253f6992de2d9bce3bbfb48c0435a91e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "df82b94e75390973eb5a24a3f1fdc301ca4b2929b3bcc6bc07d5d9abe563d631"
    sha256 cellar: :any_skip_relocation, ventura:        "e195e989306ec26bc4c627cfd0dbd1ceb2a2fca11e6fa13aa53952725b179b1e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e44fa01e4b187397878f961c706f6b8db95d4e2bba8c35889f50606d75841c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25991f2f4d748e0cd49ce32ca86e44d850b66c8e74a263dcf7cac41768f7dfb6"
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
