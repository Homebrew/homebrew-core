class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.24.tar.gz"
  sha256 "67ce695b216b0221c91139d388c71d2f5db09fa166dcabc64773e4d959313011"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fdfc6c478debdce4beb5068b8f7f0c7d0c7f7388a518cd17d2fa0c99ad436e1" => :big_sur
    sha256 "3b4850b0c7b9451ddc7882f154e13e2c1d7a5850742b973c49ebf14681d75b83" => :catalina
    sha256 "3d25a89ffd299a2a638aeea874eb08309810af05c2174287c9316369656765a4" => :mojave
    sha256 "4a9b0b330da4d82235eef0859642991dcfebd802d3b569c5cbfb27d4821ead5f" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

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
