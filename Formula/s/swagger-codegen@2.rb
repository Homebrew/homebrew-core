class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.44.tar.gz"
  sha256 "2a3856e1f22dd01198e2ff50f7f85f61c2ffdd754923ff7b4eb2636ac34e5c57"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9957ad6a72c5b0d33cca934d61fa39df3140deaa1901e1a578068356cb2f8c80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "110e581cb812f4ecc7c493c3fa82d0fd27b6a30945f4af1330245943a9e400e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c868d84b9873fb1e66c3033d4c898bfee02e9b9e6f03312a68ebe50eff510fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "58eae21ef53d08a199c16bcb221decd751987360141bc0a6b28213e1c86e6f1a"
    sha256 cellar: :any_skip_relocation, ventura:       "06d0d89da4abbdea0267da07c2922731d116de55c00466ae178c5570a38d4475"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0f8a738d4322a863da3b8fb8f6939e04e7ddc66afb44943633676b96139637e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88015a18565d8eca250566fd82768c20d7e0e4bcd4a27339ddb34cc313d848dd"
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
