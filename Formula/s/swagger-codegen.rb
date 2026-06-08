class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.81.tar.gz"
  sha256 "b16c7c1bc73cdaa0221d26129eccad32f10c2deecc29ccb90fd6bc79c22b9faf"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1049299ae68815894fc913e4f607e75a19269a49609e01c347b62c825976127b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "714b2601b4754e1db772db5877d2605d73613e0d7c6d097d8a694d537fe0bf27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8013de985735fe92ad225c4ba1948f09e3d02db17ca58d317dc1adea723cff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "186a1036060cf69f4f35dd1343736b56596651a94e74b56aba81fee9318d35e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e379448a773b443e80916ed9fb14031fb78f05a883ff6093c6e948e46c407812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a255e5afb41a4ba87abd76bd23a8016bcdb03578fb06d0b14176a98432a4ec4"
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
