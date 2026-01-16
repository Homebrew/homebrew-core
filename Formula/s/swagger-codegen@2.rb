class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.50.tar.gz"
  sha256 "28b4c2f0554ad3759f48f4676f8ccbd3b15e28a5ad2fc0ecfd985f3e54d044b0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16781a7a58f2e4bc539a9c7f41cae32ac1f13e357deef56a7e76fe7a1ff46f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f63c85e36ff3365a16862c5991c9f2410831c85af25dbad52cb55fae071aab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31290ad8f366106b84a055e06d13616e162d4b951a96ce8578fab5fef02ae6e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4542ec6f68bad8c996e9dc6b8c21c756ddff2f4a72736396c751238404cc6709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e0d8836252fa049ee57ce055cef77e521d06d4c3b5ab9b15d77d1bb47ddd767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11bc8d6b4733b41a41760836811feb2ccdce59aaa56f7b55e1ccfc0923300c6b"
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
