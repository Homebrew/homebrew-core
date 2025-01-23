class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.66.tar.gz"
  sha256 "6ddf804f4461593d0bfeb9f5cee9643f6c35158324961555b49f88e3f5bfd4e8"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57bb6dc485a6530c9cf79f0f874634cdc85b6ce59e45ad5a5632cd771cc6c437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29868a8d7740ba6ef6ca500e71f03cc745b39b65dcb5e5475a42b40cb1def3c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e715e80eaa63823caceee919f67efe025c8cc539f6e6fadf931db4e22e36a8cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "af841e7cea46ccc1748cb42971db750ec4a1deeb581c9145fd65e6c26d55150d"
    sha256 cellar: :any_skip_relocation, ventura:       "40236fc7dbc42c723951114a5516e7f50b30621a9e3fdc3cfe346358145a5315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a10b6ddf1f6ae4a0faebf2fe24418524cc277c4f77a44febdfff622f05f31ad"
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
