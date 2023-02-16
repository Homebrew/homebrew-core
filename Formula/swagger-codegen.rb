class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.41.tar.gz"
  sha256 "b0c07cfe36b434c2c0b067a44f6604d4bad19016cbef20fdbecbd88c9b702863"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42ce178738a6964ad27addfdb695e4db2cfb88431bd6904b0c9be8740390cc5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e109a366ced096ecdeda27ac171695c58891e3fce8368b9e2ec27cf62887893"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca5ed02d83980ce4172648c9a351b4cab01d454158bc9a6b7d42d1cac0068f68"
    sha256 cellar: :any_skip_relocation, ventura:        "5671e9d6a1369ec569e46845f72c907e9dd6b9cb7c00b658f3080d9bfc260fca"
    sha256 cellar: :any_skip_relocation, monterey:       "ef2951fa1262510a01bf02a2bb565e3acb60760b5059e3db135a457b33225be3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0977dec8cf570d04da26dfc0904c552ac61bc0f3ad0e2b195d7c2aa58ec70748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0b3b5919fc89d4cc65b929d7eb2ddc6cb65b1cfa3348d9ede4efa359561a017"
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
