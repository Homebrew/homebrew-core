class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.86.tar.gz"
  sha256 "fb42b7ec133d8e7dec056f8c3d0e79a27f132304ce4c1bfe9897d48c0d2ce891"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    manifest_sha256 "e66e3d5e1701891e0ed838cc6e3e5bfa9f8dc607377a9a1f03bddc4615ab6c88"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccc099bf3b4adfaa9ff4ced89260d0e2b712cf7fe25e02b2fbfd0a5aa52efc06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ccc099bf3b4adfaa9ff4ced89260d0e2b712cf7fe25e02b2fbfd0a5aa52efc06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ccc099bf3b4adfaa9ff4ced89260d0e2b712cf7fe25e02b2fbfd0a5aa52efc06"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "882317a1287688243dbf7ae0e1e69a4a416c328537b3a3f200cf388270804b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "882317a1287688243dbf7ae0e1e69a4a416c328537b3a3f200cf388270804b8f"
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
