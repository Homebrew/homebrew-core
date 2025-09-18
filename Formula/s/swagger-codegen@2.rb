class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.47.tar.gz"
  sha256 "789f808d0426bfb1940978c65ad34a7dd9431c635d3e023408398ab15c3eea9d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "951d6fc2fe7f82f1733a6d3b8b48825177cf89bdc4c105d2f564781fe13cbfb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "619ea2e23be86b361ca7f65b4921e1d6b17d99e08875054e7907bdd1cc513a20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c317e13184b82924d092893eb1f1f13e117749c9e3aeda0e6032d11cb6aaf28"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fe135b0e5a905c815266f8d90dd56d4cee75a42f6f0cb5f6b8891e752481abb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d517f02d614a51e82dbe9361555ab3bde786543fd80ecd4f33c0fce094cff663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695681c2790dbdf4f8d9e42c735941e3251598cba98bf5c9d4b28955f3149f2d"
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
