class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.46.tar.gz"
  sha256 "019114c144901a9d4c0aefadbbb3f224cc2262e29ddfd2998771d1a901607463"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9061a694e5189a880b4d2ac994499d21739ee60567c75978e3d5e6c46d8b1a9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601980b7811a78fdc05eb878a71d380f382ba3fee80fa35363d83e84ba298811"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "547d62ca978d6c49d30ba1559f2b66f318d03dd4e4382849b0fce741d093a5ab"
    sha256 cellar: :any_skip_relocation, ventura:        "026f178f23c1ca6b94dc5351981d826cafcacdef579ca049e6b0ebd8be4908c4"
    sha256 cellar: :any_skip_relocation, monterey:       "6c79edc43819b7808f153f62957b8acbf57d69511da4d66712ebf1ff5956b865"
    sha256 cellar: :any_skip_relocation, big_sur:        "88f9fed343cec6787bd0f6da3d63ad2dde4f4a426809bd800f124acc1c1fe8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba60470c26c0929b90341dfbfe7bffccd19602d728833edec7c892488d80a6fd"
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
