class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.25.tar.gz"
  sha256 "3a9b525c8109afaba7333dfc070de148c18c3e8596382b89bba591e0394ac5e0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8daa528c20726e1eec2a405de5bdb46d4851f0859f7afe2cf69e5d8b99bcd0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d5f2d55f730006ea9bbb085999cf42ee4eb103a7d05d3822c425f6806a98b1be"
    sha256 cellar: :any_skip_relocation, catalina:      "0095ddd1ecb48ecdfba273e7b92b2017cb46903929e65d180082c605e9e92124"
    sha256 cellar: :any_skip_relocation, mojave:        "60716aa9792aa6b4fb5b9bb775214f4b4730dc71802ff73aa8ba193c15d1db81"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
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
