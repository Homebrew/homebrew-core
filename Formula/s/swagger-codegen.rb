class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.76.tar.gz"
  sha256 "341747798efd874a945c9be0c4c0cd09fb24516b43c48f0719655ecfc79772fb"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "263e69050ec6a5c048f65dc1d2ddba42b53e1aa96d2f5b3ff772fedb2436a93b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf09768ca12960b92ca2095ce5785c73a4981c19d202a9dee10a6c7074f5285e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ad53aa58d78a34c12b825d63f789754e6b6e94a81e43158183713b8f95eb3c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc6909732e2b200d9a363e4b18e45c9c0ed6be3d160bbaa6440346c1ac1be821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "889887c5aa673f0247c65b8cf33b95ee3934a12f87aa7d394bfae9d8d8e7521a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "444f03cdb1b443a30b80183eae9e7af939c7686a37e8dadb4afdc8f7485f7a21"
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
