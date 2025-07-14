class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.71.tar.gz"
  sha256 "679818d2ddbca25b6c3de895d5124260e4eb0d187d2694cf6a5c7c411e14a797"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a5e210d774caa543eaf2bb3682ac7814d72cc0bdadd907a3e1dbdb04f76b9ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b425b1f5d6b08cda80b0b93d506471f962b7605b6c00b4c47a48c0292c9424e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e707dee95159227c9ace96b40051e4550f79e969403084eab72a470bd7cdc7f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e31e1d68a4b83284252df58e47a7b7557765b2d360ed76d53d35e9578cc94d3c"
    sha256 cellar: :any_skip_relocation, ventura:       "a0de654cd3b9f3987235e4a9c93acdf15e77ef0ffed879ec5d64dc4dbac9e180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7289c15faf762fa5eb1920589b05b1265191c04a6519587fa3bc6982d53b53ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d09da58c090d676240a694f79738a911fb284565fffcca995e2ba2c19e32f32e"
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
