class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.30.tar.gz"
  sha256 "2869388e8762f7a3b9ac0397c68c3823cd070389a336a8899eb157236c77a194"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "361877d6ccbba3d519dbcd7af28f9f2d3fa4e69f6711b61c33433f4c1bd8d9e5"
    sha256 cellar: :any_skip_relocation, monterey:     "5f6da4aba9f563a0989d285f757af535d7087302a9b71575c90319a9bc54646f"
    sha256 cellar: :any_skip_relocation, big_sur:      "0a9973be6eb7ab099335b6220b9b4f092f70fcb33dfbec9a831fdf0645286007"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "88b490c6ce1f26449999dc190b1cde20bb4305d9f2c08bc83e2e6db5e4e95d21"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "1.8"
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
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
