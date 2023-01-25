class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.39.tar.gz"
  sha256 "81b70b6c798344e62d7ab0cfbb11509883bdedcff11722e81f3d891249535afb"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "280058d52643dc57c8e2e596527a2318db3aa97fb4d51fbc815e63736eff931a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2e2e938eb70ef5ef65c32bffe57154259441a2b9e020496094a67794811be42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e77bc0b4fa56fb6813994ea715bab4875f15455a7db3b440bfa3dc6cf177aa93"
    sha256 cellar: :any_skip_relocation, ventura:        "c5b93945b20b047b3592ea0ffe16a99a6df1d9899e1775a4e0b768ed255584de"
    sha256 cellar: :any_skip_relocation, monterey:       "5562967cae570a75553101787f34fc19b4c632916ad232a161af4332c389b862"
    sha256 cellar: :any_skip_relocation, big_sur:        "71a844cc38944d64166ac5fdfc533c59cd63228d0c102af72fa3fdb12a9e28a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b75f688b814929320e415aac66fcbd3d4ec6084a7ad330115b4662471b0f73e6"
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
