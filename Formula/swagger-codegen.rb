class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.41.tar.gz"
  sha256 "b0c07cfe36b434c2c0b067a44f6604d4bad19016cbef20fdbecbd88c9b702863"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72740a4a2ae54f45500d5ea30a8e185740e715d757d4bcb23b5d6c134b0fab5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36129a010404c6644c1a3381d693240d27c611950f1437cdb7db533d18f0dbda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4540eb7ded1db391f47faf97cec315055b943f8f8c718f377defb795367fe702"
    sha256 cellar: :any_skip_relocation, ventura:        "3544f4f0f80efafaeb8d536b8e201f9ce354c684ba8a273ccd0f7cd4f7a1f954"
    sha256 cellar: :any_skip_relocation, monterey:       "b45856211ef26ac278c5c7334e15dd7510a95b2f4325a12b4e96c1174176d754"
    sha256 cellar: :any_skip_relocation, big_sur:        "40a034ba1fe88e1410f7793d7108f3c98f228e1a53430300d6a90afaf5f846f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dfd0cc77b0bd396f435dc03b4494319a1d2000b6dc7c37102b4f612dc809dc5"
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
