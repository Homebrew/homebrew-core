class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.28.tar.gz"
  sha256 "fda101f9234aa9e28ba7e199ff19f13df4dcf598809d0f0a4795bac3e92eece7"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "a9c1da4f98476f68fe7621e4b1822d733266edd1f516b0bd10b79c1407b86632"
    sha256 cellar: :any_skip_relocation, big_sur:      "c621203bf64ce15461414ad79fe6f40b3274175f9ee112e908b5ff70d5446455"
    sha256 cellar: :any_skip_relocation, catalina:     "9be9ed3fe52c36b97a05c9158e23a15d1e4cc39e53676ec6427c65db8ea48c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "21a607f3056f6693cc8f0049d768c3379c5c185c3a1a0e2a093ad93ea92ebfcb"
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
