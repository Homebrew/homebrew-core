class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.23.tar.gz"
  sha256 "a05930aa3f514e0f8533367a84a9172be96e3d0ec0527118e934e46cc68835d7"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "aabed284837100eff46261bdae1fb7f70858becc4dc322b405b1cb4f1ecf4469"
    sha256 cellar: :any_skip_relocation, catalina:     "783ed614be01173501e9bd3537045e5e6d88b83d72a75cd2fae04bab59c3d9ce"
    sha256 cellar: :any_skip_relocation, mojave:       "790cb84f620ecd9d631f9b959376feafb34dc66e80cb848aad5023cda9017c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ae54df6667c7dd2d828718b646ec5be079922bb85691ed44d976bb4fdeb6e6f1"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "1.8"
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
