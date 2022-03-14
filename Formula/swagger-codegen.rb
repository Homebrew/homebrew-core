class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.33.tar.gz"
  sha256 "be4b07522d8bd06e39b2c72043251f9a6d8619686f06bac4cf37e976090271f7"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23e302324f6b1aa892e6cca34fc3a34a8a676c9e5ce474430817660f1d80adfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "281a75df638297b421855c95d780f05bb9714ac6919230546b0d205506bf7a01"
    sha256 cellar: :any_skip_relocation, monterey:       "9f22bbd9255c1d7635f684a9b441fdac1ebbcf5fcb32bb967d15010a801f487a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e80155974fcec90421a52331825434df64e330df59967d685de26f013aeb3a50"
    sha256 cellar: :any_skip_relocation, catalina:       "e7ce3919562e4d24b059bb30fd82b750f3d64ae01715f9bacee9b716cb5f4603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4680b8f20c9b2f35d5f1119db4cd7bdf5a0dbff03708a3609ee47c2fe9eff4cd"
  end

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
    EOS
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
