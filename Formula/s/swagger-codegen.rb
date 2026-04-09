class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.77.tar.gz"
  sha256 "0bfe29217773f4b64f516867ff421e11ec427b93d5506967751a948cddb73ac4"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7494d145a4cfd809b2e0ea179e8a096f8677f69dc15c783b4cec42d63ee23ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5d75fea4218598ca688c54852808a8fc86e5a10785529ed3085db06fe745607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cba27e0839a0bb170921d3847a3be2507665a7d5ccbdd5cf05fe738df0085d0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a512516e1b285952b5fca3fcc519f217d992593422f1d7ff8fb76040dc57fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88989b571e7712f32b3adc8e9e3518933393225184f870e663a4660075a91213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "554ce515903dee75a1b28d9180993b60f20d555466a986d3c706a43090d7d8af"
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
