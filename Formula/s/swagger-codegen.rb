class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.63.tar.gz"
  sha256 "dcc3f38baa8c13a2ea7c7ccd77f035d79574a79633f3986a6dfae00ee10f3b22"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30fa318e2ef4cf0cc46c3edf48ebe779560039d514a8cc26b6ebdd37ecf1e017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e664848f93a98481af6565b78888e43b56b97720bbc4a0ebdb8e705ea6b7c96c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5206873b3c0d3f49a174552cd04329d1af542dfc821366812442092b8892b49b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d22dc2965d66dcacb745183f29e869c24cd9289ed7ef8d5740d8ce8a37f7d44"
    sha256 cellar: :any_skip_relocation, ventura:       "630418f3917a26b6602f19d09c30fdfc953bba23f9208029f00bfc892fb06d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d03e72f8ce24d8ba86833148a511897763c82468713449ce5d500970f71af996"
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
    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
