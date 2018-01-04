class SwaggerCodegen < Formula
  desc "Generation of API clients, server stubs, documentation from OpenAPI/Swagger definition"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.3.0.tar.gz"
  sha256 "e0f5637e68add2f7b5abbb69b020c6a6da6ea146d1ab1dc167791124d5b3b3a6"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "26df240a880ea990c83fe1e866b73c6f59584efa9066952a8953e7b6438c69d1" => :high_sierra
    sha256 "704953dac764a141b07ba5cf72c4bc07d7a7ffe7fbb0dbfb25b785563266a232" => :sierra
    sha256 "179c1b14bacfb4b80649475072d0db5e7bed928835fcd3f15465d2cba3bbb90e" => :el_capitan
    sha256 "1fc02905cba6c5e8a02c6936db0dfbcc430b9ff10b1a3961a0cabe7e17ce4814" => :yosemite
  end

  depends_on :java => "1.8"
  depends_on "maven" => :build

  def install
    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
      ---
      swagger: '2.0'
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
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "swagger"
  end
end
