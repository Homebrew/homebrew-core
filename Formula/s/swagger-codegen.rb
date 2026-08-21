class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.82.tar.gz"
  sha256 "abc67e5fb42ddf47d26d670065a1acb996a22f9ea408b7a322240805ab54c07d"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35129e9b64ac153225bcde166af6b4631168b944d9a9e29a670b81cb34eab990"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbd4d700e911fa618154d90115d38933249044e1d1a84a82a9d7617b41f1f769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28041f06b343abf3897b40be7fcc9c29ccf709d7584158afe0770d4f77bfa3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "336965ab95b537b743bfedbf7467ea7943de7aea1e311057caee0bdd41c86ef4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84998b95070734b5fd62e03b8221534b0c33fce463e02f84718b6be462dc65a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d89726fe4fc8b2dc2d8450b87d7d8044f089350fc8c58c1d0d1344345ef13f1"
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
