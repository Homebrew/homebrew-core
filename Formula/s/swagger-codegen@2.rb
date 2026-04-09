class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.51.tar.gz"
  sha256 "20100d53e204e1d6c2ceac2bd65596c884a7386bae0890aa3ab0b7ba21710a8c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e60872362ef280846128c4c94e7fbeca4ab5191e87f59ea8253e5041495d9d10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2d4ef7957948843aad46c3e61d3f3cfda66ed4dee9d0faba366ea3a479c8a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08242ea6f0fe4a54df8dd18ac96b2efdb6ce04f5a1f4691050e0a8b5bf45d62a"
    sha256 cellar: :any_skip_relocation, sonoma:        "86c7bcae76cebfb42273d033c692742fb68406c52df958b694b68813b07b56e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a26bca1b7efb54eaa79b30410261633682d99e51d856c788669c423405f97218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d198d697c315b45cfb993d660db68455b9d1ec781442e39f04f71958f4de35c3"
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
