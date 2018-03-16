class SwaggerCodegen < Formula
  desc "Generation of API clients, server stubs, documentation from OpenAPI/Swagger definition"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.3.1.tar.gz"
  sha256 "0f86c36a5961b0212f3f3b28650d6c6545b281ce1405411edee8505dfbb4073e"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81b19c10e0cb6e02ae83ecd1a572f72e06ba78dfa8c086f061e81d50b88c3153" => :high_sierra
    sha256 "b1796894e7d5ebed8e78ab6919c34c8cee32c7076d3b17e0f172cae9c08cfc87" => :sierra
    sha256 "4bf5f529fad00809762b99a5fb93e52560f7509cdb7b074c2d02a5081f8bbbd5" => :el_capitan
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
