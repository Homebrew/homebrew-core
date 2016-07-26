class SwaggerCodegen < Formula
  desc "Generation of client and server from Swagger definition"
  homepage "http://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.2.0.tar.gz"
  sha256 "4c0ba632e9da193c278b00bbb59deab68206a588b381de764d614e77ca99f171"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31ea44de7c313ce6d49d8f723d41d11acf09c924bdf32dfb803636e0f239659b" => :el_capitan
    sha256 "d01702bbcd7bff6d82448b9d29b89599e9445daa9f161d71be8371370e36f50a" => :yosemite
    sha256 "892c16f22439b2ab359deca9e0eb35b4319776a255ab204b87d06039cb17ef49" => :mavericks
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
