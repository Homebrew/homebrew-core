class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.8.tar.gz"
  sha256 "56fba8d61d93ccb8c049b0f8b630f67c3730d2ce3190315a009ab2689204d2dc"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6df1703bb9875befe6da7e09487e8360483ec899324507bcd54abed8a065d10e" => :mojave
    sha256 "bf3295aa4be1f689f0869f9963e6221dcf5f3490115426c6aadadfea5b1a44b8" => :high_sierra
    sha256 "918ebdfafdf3b75399be91eebd032e7300cdb3fe8cd98ffaa82e33cd905f3d76" => :sierra
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
