class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.29.tar.gz"
  sha256 "1c9285f2c186e54030dbcabfee54c395f57ebfbc42aa35c4cb9143f69e5348d0"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a5cdf8da29b6714579a611b56d333b2e9a5deb1a2836fcbb7bce38c514277f19"
    sha256 cellar: :any_skip_relocation, big_sur:       "b7e43d51d44fb9d13269afb13ee48dd9480864416b89c7da38ca6272f435f0c6"
    sha256 cellar: :any_skip_relocation, catalina:      "9c5d5da2529b5dd084f1b54551cf2a833ef8127b470575d520f2026983538018"
    sha256 cellar: :any_skip_relocation, mojave:        "0879013b47480613e2bdc02f0fa4ea31c20deaa894ec2b2bc6463d47170b93f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9bebbadfaf223b38d1e9b99381ef5d5c4ac3f16c0065cdeca0a8672f1486a5"
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
