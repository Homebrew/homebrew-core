class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.32.tar.gz"
  sha256 "6c09797b16e2d17be2592b8dac4d7ef65765eec540c41929a403df59bd9c9fae"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95005d8b832a30dc10cbc458e611354f1f156288d36b2cfd60c2880f87768005"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3642046a6316344f9c236097cc5c51c6bdd10c95b7401ab34824bab44f27e275"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95d594cc6ee387701f713c5479953c7e2e325a2ec11f4385b45bda0a4aa774d6"
    sha256 cellar: :any_skip_relocation, ventura:        "be20870ef3994ce48953c5d9134e740954d3a4dedab4eda0edaeaaf1ee4faf81"
    sha256 cellar: :any_skip_relocation, monterey:       "c081a292ef84ca0a23c299d7ce2d7a09f53bdf4e85ffda8a13d8110f8f0ae441"
    sha256 cellar: :any_skip_relocation, big_sur:        "d44b97fcee0aa0d68ce8cd5a21ef57309ca650c9d1fc852d17f7f1cbabf97d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8233d5aa15bcb8b354b208fe4343d55509c5c79add9a8f94c891ee472bdd0bb"
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
