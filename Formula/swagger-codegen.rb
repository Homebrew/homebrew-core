class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.40.tar.gz"
  sha256 "5bd3f61fdb9a2c4fe17f911d343ba34ced8de64fce1e22aae4a7e8928c5db63c"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac83fbd838d2578534e81b545f88a9348bb71b7c680a03e6afa93804857dd058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff88789fee05e1ec2264e2639907a5839c82cc1d15c026c5854763e6320efa9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be248b0c9c610e54ec679a66f6c725408d2d76006f35c7872f1001177eae186c"
    sha256 cellar: :any_skip_relocation, ventura:        "45f80c164459c08001e2ec23aa1fb3c143dedd60f40f6bee0b7a3ada412145ab"
    sha256 cellar: :any_skip_relocation, monterey:       "2c87f286f04365d519e57fed7c76efb86a35d3759c17397b1c63bf6436def93d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a59abb2b36fa88f91e7f91d23f3839eb8b60f7566861432370c475ec1fbb8f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eaee1e682808a22c672c1c774a8a5f3dfbcf5329260886f2c430df2ebf2144d"
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
