class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.79.tar.gz"
  sha256 "e1ecd975f0e2f3190a92924059e8f7c1875e3ec29eb731df382fafdb49112407"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca40fd55ca66e5f73183f3d8be57c1f892594d08cfbf65f0478abd3eac489e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cddc8d44d3db0d548c221a4452a71fed6aba77c0fcee1acdb53bad4f95bc3e8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a47614780dba4cb7ad0e0b8427c4410344c2444c4f29acb9d1b9605d840493"
    sha256 cellar: :any_skip_relocation, sonoma:        "484e01e84dee0c0f5452b8a9e19449427254da1a4a180d3acb4c98d59a87b94e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac34662eee34be1edde98c5203da8fb83208972d7285b67b37bcffee7e2ffc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd85093b64fd2197faf96941bbbe7d0233bad90e96803c72e91ed43308ab4a2d"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<~YAML
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
    YAML
    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
