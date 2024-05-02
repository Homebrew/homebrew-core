class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.41.tar.gz"
  sha256 "64352978f08bb3cf777e9f846c9ea9ccc3fafd85cd437c5c41dfc69a87a3601f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0864788e642914a0837ea7504d3e83a198640e3eb7027c8598ead801024e67f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bb3bef6d634ed47e6635558eb6a7b9e4f18f3188f499f8f1b3effe42358d7f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6937421a86ab953f8cb49a21a1e925326e994cb608cda205bc729792d94892e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "864f7106da0523324eff373575799b8ecdefc4b7fac443f57eb7f3c7f6b92c09"
    sha256 cellar: :any_skip_relocation, ventura:        "bc6f409f3bbc3051ef8cbb831fb96d3d2d15bac973660ebbad13f724cd2fcc52"
    sha256 cellar: :any_skip_relocation, monterey:       "6dfbc78e7cc8323708b6bbec1d7fd77bcd7ae9914011267fa323e155b81d934d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17bf29b24476d0b69a3105a3a1c91111f1299b7d0ddca9c317caea12ba8860f6"
  end

  keg_only :versioned_formula

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
      swagger: '2.0'
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
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
