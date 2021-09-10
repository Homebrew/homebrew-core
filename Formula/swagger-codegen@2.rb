class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.21.tar.gz"
  sha256 "0aba5cf7d8d1a2c2c5da3f8933f10922541e7c532082dd61c5df1cc4859c4a42"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "ee749950ee8cdd3ab857f180639c55a52fba2376b07651a0ebc20ac0545aafdd"
    sha256 cellar: :any_skip_relocation, catalina:     "356f53ea21ff99adaf4a8f6d92b050ef73b1215b2571a83dd7f6b94cfcdc61ba"
    sha256 cellar: :any_skip_relocation, mojave:       "b4a4565fb71e64da0a0bdb792117421a64997eb52347f7bb2392681fbd910e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aa9639a0489935eeea4800e7deedf8ff067db52339483a6dee429a82f24d4d40"
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
