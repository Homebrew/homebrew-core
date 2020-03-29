class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.18.tar.gz"
  sha256 "b5ca1b4aa3acfcba54909c9dd163fdae22a5a1099d4a883982e9a9befc8291b1"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b367f0cc5cd2bd2218f91d3a2631631b6d7e9bd941baa88606421628e8a94157" => :catalina
    sha256 "1e0883f885e0e83e68ef63e6396fa4bc712741fd8b2b3c3cc24f1df8c367f2ea" => :mojave
    sha256 "ebd5c4ae69699620e7e540ea1998f32134865ee649f6401443636e7f26a499c3" => :high_sierra
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
