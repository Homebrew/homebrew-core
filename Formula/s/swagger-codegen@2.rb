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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c3bccf0295a0e1dd633850e9946c680b2e70061d9a77ba0922bf30064163108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eb8141b0066f09474554c5b43ce5483900f7142cf7b2ce5a18a317fcbb3238a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "101c619d8b7a95aa123982249702b328aca40c54fdcae71079363f326db928f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c995512184cf6536ec84c924c40da4fd49d8b8d9dbba841fef440f3019960d0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d245e13d12fb312da9204d64be5f74254ce5abd383ade758b63ffb1f94e3dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076500d9ca8519fd67662c64962b9d31203ca92c7593be56e864aa1b5da85738"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    java_version = "21"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    system "mvn", "clean", "package"
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
