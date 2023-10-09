class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.47.tar.gz"
  sha256 "8481d60b89bdfe0c4ed7816da065b839439d5b37cfdb48d44ad07f546387c71b"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cbd58e99741a5d98a0ffd3d35abf009bc5c038e49b8f979c0256d705e8b8ede"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4f68bf7b48ab5aa347463ff04cb7a878b3e666689a6d87b999850d4d5a30573"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b4233b925873b1986580bc631209d4d19e4006041a85c13ca84858e8b658825"
    sha256 cellar: :any_skip_relocation, sonoma:         "875908e531ab7bca7f17739727adbba2522505be7e867965e3cb0bcbf4e5adfb"
    sha256 cellar: :any_skip_relocation, ventura:        "0fd187974e3e577480a0c0220798e7ffbf70f2ef51df3a23f4c353827f53ac72"
    sha256 cellar: :any_skip_relocation, monterey:       "8c261d417a9b51d21da43e97fd3b22c8aefc1807e6a8c82b1f0f1d5eb37d8dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9259f85140d16dfcf30de72d39ceffd60ed7c83db91ea1ce60e7c5a7bd9d975"
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
