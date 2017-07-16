class SwaggerCodegen < Formula
  desc "Generation of client and server from Swagger definition"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.2.3.tar.gz"
  sha256 "433c295891d0fd51f507b94071f7b8507a955ee74fc5ab6ba2c9d309562dbf69"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b9948e4fa6a29dafb419a6ead0fa2072d3a0e209564b94639bedb531da1a681" => :sierra
    sha256 "ba9912568441c56fd72a38e73648e8119643bdc4115f438ba399bc60cca156a2" => :el_capitan
    sha256 "c482f92fa2688b5f15ecad071e8945c7fb10e24b4fc2aa134c4a351133aa6dc9" => :yosemite
  end

  depends_on :java => "1.7+"
  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<-EOS.undent
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
