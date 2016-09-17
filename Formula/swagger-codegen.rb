class SwaggerCodegen < Formula
  desc "Generation of client and server from Swagger definition"
  homepage "http://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.2.1.tar.gz"
  sha256 "bdf6d5828cdcdeb43f377d58f13a73f8c297fb90c3bad900f0e0a266ebf8d778"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "514301a5707ccafbab4435d840d7ad99817a38bf3e2392cd33c68d8de09653bd" => :sierra
    sha256 "8d4c728aacf862c15a22bb254365fd9d557acaa144f0e9eccd72b7e09c207174" => :el_capitan
    sha256 "43283ffa36d261cf9723866ac0f825b92e0a37212de27645819ebe14117fdcfa" => :yosemite
    sha256 "01614863b7c91a94b27ecccda0bf6617244c53d43cf641a4148bdead33031a33" => :mavericks
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
