class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.75.tar.gz"
  sha256 "cb105d1a421bc8710aacd14f82690f06b156f46745b0424f2b43e5e3ff4d0c90"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99e6ed0d7c470367e85eb74c458f975470daa46a1aef6bd394ec6bf0341df5d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5674a17da61705a93e546687fcd924b4b5edc043f872f13775491e3612106c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b44bd5072b729a749eff9997d94bdf107487fe4db2a0d627f3ce9101c27d09a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e30388f19620efadcf68284f8e3c64e198ae67ac4b8ae82c80b2ad98bd2b343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e05f248850e54cd3fb7b92beff22d4d293391f3ce6c1abff915e51de34c35a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3083742a497dac918d1b425bb6d5089f55fdf569e6ee049c442e16b423c583"
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
