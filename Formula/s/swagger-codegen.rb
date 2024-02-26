class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.54.tar.gz"
  sha256 "3822477344d525f1f34d0f8f279d44869040424f5febc12959d8471563f887ca"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c0d7b64b6d3be1938ded122403606433a2a0ad7324de31c884dd342e3fa6f03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebc699c86ef92bb8d8a6cc3176a889b860cc315e849652b04a376f074b988681"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c40deda347b9fe4d12e1fe59a8d8e1696df7f4c0bbc5b05ce1da7bef67a94a66"
    sha256 cellar: :any_skip_relocation, sonoma:         "8191c0a5adfaa60a2d89ef00f6962fd085706c172438a40491233c9c4c872dbb"
    sha256 cellar: :any_skip_relocation, ventura:        "daafeeeb33adcf0746d2a91d5abd812c0f46de6654a56922d84926fdef901a5e"
    sha256 cellar: :any_skip_relocation, monterey:       "df164db9f590bbb8fdcedbf535e11b674f8c46ee670d4b201500ee857883afdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21164e7dc7723ab1c6cd3f28740c4e66a6dbf6e4a5a46bc16c957204b9fa20d1"
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
