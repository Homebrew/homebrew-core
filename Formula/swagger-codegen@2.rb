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
    sha256 cellar: :any_skip_relocation, ventura:      "dcd188d7701dee7e9b09eabd3314a092bc7d88f187b3ad15e150cc733861e2f5"
    sha256 cellar: :any_skip_relocation, monterey:     "f289c5baa1bdba5ec895aaf3473f3bf7b6c17341c63caee3cde92416a3a4dd6d"
    sha256 cellar: :any_skip_relocation, big_sur:      "1000f89738c76cda32b7def0c273492cae6d63cac6beef817ffbcb867576a39e"
    sha256 cellar: :any_skip_relocation, catalina:     "1c7fd0cdbc0b1b972a40f680c888fbc28053f22c763c018891cc3dee3ddfd1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "111eb19c3cab7004867839c757951f6a0261d27dbf75b5e1b93b02fa6b918e60"
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
