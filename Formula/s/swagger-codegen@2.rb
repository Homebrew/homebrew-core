class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.38.tar.gz"
  sha256 "32ff457e226204cfbcc998c8414ad91eaef3d2d4ea1e0a68f3bbb010ef188a49"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef034691d94f85238d0728b4d75349283092f9898e501cfbfde627e499f655e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9514a589e3ead653cc75b17e820b575261654fa741364fc5142637d0f0618da1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e2304f367858316816b2487472f6a37c0f27321b1a3765d117a31a815d7869"
    sha256 cellar: :any_skip_relocation, sonoma:         "056f4b554ca8ae7961186f19445278254fdb114fb10474cbcf588ef26244822c"
    sha256 cellar: :any_skip_relocation, ventura:        "a619534e5534aa1797dfcec1edb16fbe90fbba358dc1744d7e180f9d2d106f43"
    sha256 cellar: :any_skip_relocation, monterey:       "c966d00dfe5688991b4dbeaa50cf7d58115f8013986f3a8588b65ca790f2f984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e77320fa4cc8881306db3a424ed4d9814af4290bf579054bc5915586163e622"
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
