class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.7.tar.gz"
  sha256 "4df70e638d1ce9023165c909827dd1cd02bbec1ae5756a4bb7891a0747886d66"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5db8d2b191a853e2d5c8be1d5ef65544e34de889517b7f3fe729d961dfdef462" => :mojave
    sha256 "c27fe2bb5df62dd42b3b7110561722a73486e814019610a1d3ac1e5c45d03fa8" => :high_sierra
    sha256 "1434cf70711c7805bb5ecb5ac7e0b4d05b92b5feaeab654cdd3d441334dab0aa" => :sierra
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

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
