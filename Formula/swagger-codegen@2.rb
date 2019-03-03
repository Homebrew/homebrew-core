class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.2.tar.gz"
  sha256 "92328d5aea40baf82e6bc1ce4f6bc07cee854ad02c5149359a8ca80e87414fbd"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8f571c8b8b3b0eac9931fa7bfd25f6e1f23d4be94a8abcaa6338f81d1defda7" => :mojave
    sha256 "3a6b5d34973ffa490f4b49c166561aa6a83f781564733490f373dc4c554ff693" => :high_sierra
    sha256 "b9a9882c5175d8d325a8d60dafcbf7305bfd86c35b604775c7622c9228db27cd" => :sierra
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on :java => "1.8"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
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
