class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.61.tar.gz"
  sha256 "99de8e144cda8e5dd190b1d0d472eacd484e8e26af2bdea180234c80c170da80"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96cea5a809cbc0ba02a9d6d607aedf123940c3c6ad74764d87c7ec068717fb50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67952b2964a751f2baa7166522dc8bfa920ae1055c354b99f34d604a5cc3bc77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e13245f9d44aa6f7b5b1a20d3b61ac2e13fb288e6902706e8777779e66dc5532"
    sha256 cellar: :any_skip_relocation, sonoma:         "42b6201a7c8ac13e440e33e072ca6bfa4966293debac151ab379910dd91b2bd9"
    sha256 cellar: :any_skip_relocation, ventura:        "2f8d437c43e60ce15271f470c2474f581f7c106dc6e77bfd268ebc760a83a898"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdc9d5801cab4de551808c5f2bae2387ec61a9b5ad05559c65a6a810dd7b909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87536fa29aff2e317f905c7f7cef027714503d6f510fb1ae9372c077b82b4947"
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
    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
