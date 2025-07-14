class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.46.tar.gz"
  sha256 "25eed35baf6ad4c43b979e97c4ca6cd7e62ee1df47ef04e84c5997cfdc0a8d24"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8ffdab903a50ec24ef2cb91552320bc2e12f7ea015f29998634ced0f6d6bee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca0870feee8d71defd653dfa53dbc9764c4a273022642166edb01c02eff3d22b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7473f61154921eadd45e286e3c7cd020f2ba628d6d75a735fe00e5f713774bae"
    sha256 cellar: :any_skip_relocation, sonoma:        "476ab8d9da04e3a1d47b811a6b6f107dde09a886ec4628760a522d13a9fec064"
    sha256 cellar: :any_skip_relocation, ventura:       "bb720bb8c79de44738daf4d2cb02fdb926f19bc8b38efc32a9fd46c0cdf81e6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20b4002a73dca9fb92b7aff88b12b0208bba5fe140b0322d56adad9857de3882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1436818c609168fe4adb9c2345c4f4f818bef5b4b8bb4aa2f6d686b74be4063d"
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
