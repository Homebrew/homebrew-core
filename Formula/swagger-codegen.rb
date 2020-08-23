class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.20.tar.gz"
  sha256 "82de5438e233631026b945d2f25bd0a30c36d496daf42b696de27aa40dcd5dc1"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6edc8aa014a0a91569b7895abd7c7196ae99b6b10ca1e27d0a327ef825f6d171" => :catalina
    sha256 "265c496f1891d12cfc8071f000c0f07bdce03bde78df8c83c57050332ce8e509" => :mojave
    sha256 "39d90b9fe87e3b6dcb7275e3b73ae8255a8a12e752ea35bc3a040ff0e7621516" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on java: "1.8"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.safe_popen_read(cmd).chomp

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
