class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.67.tar.gz"
  sha256 "be23dde48a656cfb54cd204380660ec4dd8b5ddd484d62670fa909941869e040"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b97712aef7f57c1bdf7ad4ead964891cbfb6727e5918983bd698d177b978b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce2fba4d20ebab08913079c654841c4d5d7ad61a9f7b53291b4a84a1f833b190"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2367f19743b586b7070f0cd4b3880a9989b65974a117837329fc9bfd885bf112"
    sha256 cellar: :any_skip_relocation, sonoma:        "046fe981e1efb50358e9b4010d6c2dda7e7eb179af90b9bd9556ff77202d3afa"
    sha256 cellar: :any_skip_relocation, ventura:       "f32049f0c08c1f0e79413cb50bfc3fb0712936592081b558c0951c51e3608611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be501c8580aa14e1c85cb21a708d38489fb57f7f73cb7086d27c720c1069b93"
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
