class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.68.tar.gz"
  sha256 "05edb52130fe8c7d619338b23693aa284138fac2e73867ce5ab718e21b34ea45"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "067dc9c02195e7137aa7b73981469c4eb620f5007cf4038dad747a3365597e9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6c0cece86d7e6b21d0992eb386c2cfdf60f87e02f94d927ebecb447a59a3a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59b7ec0c1577ebfebe2592c68e3cc171e5fd22ece000dff9ef13361a6497a30c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b067becfaa888349fa23ebe558c5da2069a5f0a55f2700c28f7705b2c8a722f"
    sha256 cellar: :any_skip_relocation, ventura:       "3f6c17cc526619ad01b8aee9e62c450c78976a7209da69a52a02fab00bd51b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e01b9efe675d920ba0cc1adbc59aa0356efbd26cb1f6fde3c12ae3d5147fa0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73da380fb2738d1209a443ba96b4d81d5a2c90f7a93940907c2e06d91b11e907"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<~YAML
      ---
      openapi: 3.0.0
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
    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
