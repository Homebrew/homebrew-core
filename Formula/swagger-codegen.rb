class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.24.tar.gz"
  sha256 "67ce695b216b0221c91139d388c71d2f5db09fa166dcabc64773e4d959313011"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f05debff6dc788a0b151dd5bd82f97c0c09ac1cde7c2d88215c9f186ffec7af" => :big_sur
    sha256 "07f607bb8598788f0e5995227f4740fd104aadaf10e7467485bd192644ba1c4c" => :arm64_big_sur
    sha256 "ba994325a0b782b2c072d925c45ace5169df282c57e27d11cb3a29471542accb" => :catalina
    sha256 "926d1fd46f1e1f0f48b916dd3aaef1fe9f0470b9b23dbb54ad75ca8885104880" => :mojave
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
