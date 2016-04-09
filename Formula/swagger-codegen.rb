class SwaggerCodegen < Formula
  desc "Generation of client and server from Swagger definition"
  homepage "http://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.1.6.tar.gz"
  sha256 "433fee205700275ba93a5a74799e0f1795ffd2cc278aaf239a5410561dad2f48"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "16cb4b58895d983284e5784e478227b85b4f77a9aece4b82c669c172c63b6ba6" => :el_capitan
    sha256 "71b5377b6016d7a3768ff74aef4af4c4962b609856c7d62845006c3bba6bcf90" => :yosemite
    sha256 "60d48695e53f6b4324500903f1abc59c8503aad0f154ea1cc36a361eb416ac56" => :mavericks
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
