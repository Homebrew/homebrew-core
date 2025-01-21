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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93390df04af8f77e55f6758d808fe4b022729cff8cca6be8a08c3692936ae8da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "749278049cc1975aaa1e8aec068ad636a0c20165dca71c5276fcf766ca072fd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16d85444b730f0a2c258bb97b4053ad1cfbb75e4f309cc44b72a06098316623e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f1f9ac33a296483e8d22c148194ba860edf36e69cd55f70655f98aed2290eaa"
    sha256 cellar: :any_skip_relocation, ventura:       "30f36152fba7b75bb39da1848f944d7757c28f9fe108ecb4dc40e5c69e445c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f90f09191691d4f57eda897c9bcf520a5e8c1d4e04e7b1c48cb94565d3303b"
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
