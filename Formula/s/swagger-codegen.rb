class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.80.tar.gz"
  sha256 "386235163329de6ab7d6d4c5d9532940f3c732ef085d415a92850834706950de"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4c27c79b3ff4908ad8d50de2f77143da30f94c6056a509d28923835eaadc7e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f153ca2e7b0fef66de9295412b57984a7fc2fdbc1ba8593798932623f8d25f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec2daf47818541d8f6ef8eb893fb4bdf484d76dc38533f36ce6ab63156e27e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab9d49be5a36822fcea047834025bc69c9bcc9e303c7af378171e8220631da7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23d619498ce2332a8da19ef08177a395ab331aafd60e904d799375dc37fb4778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c9cee1ea62829bdff21dfddbe1677e7082779610fd7df0e22eb95df4ea4938"
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
