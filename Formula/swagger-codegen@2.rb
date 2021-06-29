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
    sha256 cellar: :any_skip_relocation, big_sur:  "61cfae47db4d83734155edb210c038510bbe9c9e6db083faf38588ea8424959d"
    sha256 cellar: :any_skip_relocation, catalina: "e61e995f40b4c66561ffc942cffd4134f276c6a3a19641d228ff9c2101e4f1b1"
    sha256 cellar: :any_skip_relocation, mojave:   "ddb6b822a399753579b60f69a84c6edd40bdc1b11d2c9d1783d34cc40bba5c60"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
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
