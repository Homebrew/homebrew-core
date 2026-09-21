class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.52.tar.gz"
  sha256 "7707fa9771272644d7fab12a5eaee0f3f319bda746a44ed58ba726efa60050a9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23934d1279f84871f71cc64bac2eacfc3049e97b1f46c10e6727be3fbe4c6238"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c882506c804b8e91126bd148bdd91523d2c44c12c22a47019a039518a34ec51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3a172aa5f6f114873695481455cda3e5ae69bee3f61d9a84a9ed045c5498020"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5bc2a13066e46e9740879b8815adcbd60bbbdbd4312fe5a2850743c00ae5a9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "807a4df4e8ae5e7b145fe3cbf2a86eb6be3562396911c656b1805896782149c9"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    java_version = "21"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    # Only build the CLI: the `swagger-generator` webapp fetches a since-renamed `swagger-ui` branch at build
    # time, and the tests need a JVM attach socket that the build sandbox denies
    system "mvn", "clean", "package", "-DskipTests", "-pl", "modules/swagger-codegen-cli", "-am"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script(libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version:)
  end

  test do
    (testpath/"minimal.yaml").write <<~YAML
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
    YAML

    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes (testpath/"index.html").read, "<h1>Simple API</h1>"
  end
end
