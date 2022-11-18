class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.36.tar.gz"
  sha256 "c27116294fcdb37f2a66f2f307e03298c7694351d14d5cae7c453723ae1b6519"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ecde876bcf9a1ce318a5c08542110f78ae9349c7b871b3bf9b6f68c970ed3b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef5f8901b74603a63efa7d05545f5d9519cbe48873bcb0ce1fa7aca08bce8942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a39a3304a35b0b840bbcc36de013295b263096757e6585ed2fd63d70ed095ba5"
    sha256 cellar: :any_skip_relocation, ventura:        "373aa0a4caa4b55f5d66997fa64229eb70a09c3752c89bd34419635de5e9c67e"
    sha256 cellar: :any_skip_relocation, monterey:       "e849a65b310095bb7fa44dd22e06dfdb29b0a8a1364bed32710c1f623dc180c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3703ab07b17daca72bf0518b3c3caf29f47fbf6ebc857e055f335a867ea2960a"
    sha256 cellar: :any_skip_relocation, catalina:       "2e16135ad91655415b9849728ea86b8e408da61ec896682f29d946ec92cd1daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c3af0a2670bc813e4c2a7fd497f2bb4bc20a1c22fe4736943188da0b4bbcae"
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
