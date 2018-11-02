class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.2.tar.gz"
  sha256 "895e88b72d30048ce9cd00e2de4a6bf59db312e13b3498505b5a84b1a0cc18ae"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a7bb5dfb68ce65cc8dee855f0bc7042124fcb928f563d76c238cc6e12b10297" => :mojave
    sha256 "81b19c10e0cb6e02ae83ecd1a572f72e06ba78dfa8c086f061e81d50b88c3153" => :high_sierra
    sha256 "b1796894e7d5ebed8e78ab6919c34c8cee32c7076d3b17e0f172cae9c08cfc87" => :sierra
    sha256 "4bf5f529fad00809762b99a5fb93e52560f7509cdb7b074c2d02a5081f8bbbd5" => :el_capitan
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
