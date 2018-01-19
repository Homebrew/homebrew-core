class SwaggerCodegen < Formula
  desc "Generation of API clients, server stubs, documentation from OpenAPI/Swagger definition"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.3.1.tar.gz"
  sha256 "0f86c36a5961b0212f3f3b28650d6c6545b281ce1405411edee8505dfbb4073e"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2ee371fe1c53feaa5dca074466d59983ece519e0638f94c9bb903151ee15a63" => :high_sierra
    sha256 "437f56001856c312d90ef88addfa086b85e6757fad436897ef7901966e07c219" => :sierra
    sha256 "e54452eeeb744aaf4fd0c37937d1ef674e20e0af1984581f636ccfeed1cdfb45" => :el_capitan
  end

  depends_on :java => "1.8"
  depends_on "maven" => :build

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

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
