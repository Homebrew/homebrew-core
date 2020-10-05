class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.22.tar.gz"
  sha256 "fbdd96ea4577fcc5dfb53402a893a1033e35f336d4db43f078cdd05cf3a7e108"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4963f8dbafdb150d6f53390c7efb8f3dbeeaa667532700f7c657921a856e8fd2" => :catalina
    sha256 "34221c4d7cfe5740e3ae2b7b9e1f5dc00f83542dc6be8466acd7db1ce933e7f9" => :mojave
    sha256 "a76d67d7d444979bd8a06225c36ff67e1986aa155d9763db301b694522966cf7" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

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
