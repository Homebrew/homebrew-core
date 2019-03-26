class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.4.tar.gz"
  sha256 "7cc96656c2756f393fcf01559855d289d10832f799292755a953e7580612c9b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "484bb243a1701a06c6f1357ea526d928ab38e1cc085af1015fcc3014b609302a" => :mojave
    sha256 "19ef8c8852e3bce455f863946375c4ff407f696b861add6d8d9ec6657dc1b75a" => :high_sierra
    sha256 "d4d5a6c2eec943d9fdf96029769a3bb4b11c944dc13911068168f3b5db2ac18d" => :sierra
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
