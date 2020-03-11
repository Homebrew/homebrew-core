class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.18.tar.gz"
  sha256 "b5ca1b4aa3acfcba54909c9dd163fdae22a5a1099d4a883982e9a9befc8291b1"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5be8c560c7344b211cb07ff8468ad94d74ffcb1c693b5a78b8e6f97dc01bec7" => :catalina
    sha256 "9f09272129619a9b99d3f6ea0ab689c86ba1fe70c8b888b5c8536e0321b258ef" => :mojave
    sha256 "62fd44f3b04f25779eca2f82bb2e93aaaa42f5bdc575a916b0a801ae845f91a8" => :high_sierra
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
