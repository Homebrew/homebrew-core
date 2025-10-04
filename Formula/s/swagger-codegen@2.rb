class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.48.tar.gz"
  sha256 "a003cf2136650843f43d050228d80e60873622e96a8545279bae6d52cdef68fd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85cc8cb7d7e7c2942b2212ac00ca76213ed260550c276701c16864935935c395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e699507f6905ee446ceeb8dc872356dc38b32d3a279452c59c4390b44752a590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cfd9180f46c2765e0b17d3cf8be3e91f3d128e2e4ad5bdcfd1eb2d29778a4cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0050699c0330a88976102fb5d887a8ba69c19b0c9f04bd7a15d5c6a9ce110bb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1db92af55f304bff73080b9e23f4f6bcfc310fef4423e366386c64cb17f91ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe70ca557ab4c10e59d7d8fc3011e3b4bf3a774d325d3e02a419d71945236a1b"
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
