class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.33.tar.gz"
  sha256 "461b457dd20c7ab80486a2d09f1f701e0dfc46313c16b949bfe2639980261b6a"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a05038aad4c3de7efb30968b9cc59da8638ec79cd82ecb75e7aa837d695899e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e51ea470fea5ee116aecdd4b5ece0c7cede682da4d7f31abf319b2c8dc64b021"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad43fb53411e5625ab1ab7bbb9a39913db6105c44d677409ba3db030df8fae17"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2cfcdd90ea7bf53d9720e7dd8976ed8d6f8b2616bc6d7e1eb0755cb7f1ad54e"
    sha256 cellar: :any_skip_relocation, ventura:        "e2cea5a08d86d2296bacb5083fce0b4684d993418a4b489c4830076008d9a2c0"
    sha256 cellar: :any_skip_relocation, monterey:       "58927ad966895916918fea00b5b25b9c57a774bc4b6f25dd8aa0ab5b9c37f441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4cd7fda2ee376846206f696e3d7a9481684b0f91748ec2b46dda6b2f2d96450"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "11"
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
