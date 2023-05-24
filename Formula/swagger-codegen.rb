class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.44.tar.gz"
  sha256 "a9ff081072cbdeaee1def8012188914618f8a97bc911e61c4914e90826fa7030"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce94a8df7657872940d30b6f303ddad64fb07f4e3f4c01a227106d681f2ea6a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7052c2a4fe56ad6203a16837fa0c0390c8a55a2e66f763e935182e6e7e18f15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dc34122ad983a30f800d1c4634a0108df29657f7667ad6763024c437e6a70ef"
    sha256 cellar: :any_skip_relocation, ventura:        "f4d85ff515d4a2e5889c0a5c21f010d1262ab00697728b0b27c371594ad3efce"
    sha256 cellar: :any_skip_relocation, monterey:       "34aa7966c95587238a127616819918509c0b7aff0d7d043d2440c43f92ba4913"
    sha256 cellar: :any_skip_relocation, big_sur:        "49008d4dad21822e4b1b4cbf6812e7eaa842cf017dfc3f436ab609bdccbd6670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb3525a5d136147851596bacace12c3367c34a0d6b86a3a216b99512e21e3d90"
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
