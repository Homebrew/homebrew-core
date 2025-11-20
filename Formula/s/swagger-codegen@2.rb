class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.49.tar.gz"
  sha256 "9e55b029edb09828c643f8edf2e1d0c1290f5ef2fcb809dfd3314bbdd11f4794"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cbf1681b7e886b34c37e732228f84edc08fea203f60d099f92866210cf05920"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d3154fd353baef6bd06a988708a84238e1a450474fc773f5d4f6c5461aa4ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8ef0d2326c8fb0336d69f01ba5efb0e6c06888de8b2eec74d8a3266225604d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "97af414fadff60cb679a4064bb7fbcf9fabc7beb5425fe48cfa754610874a8e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f387d69dadaa3e19b620bb71ddec827babd37cb1a8724b94c1e6088cc6dc5519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "265d6c093695251c6dcce839a2ffd311503b427859a6cc0c71c1806639941bb7"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    java_version = "21"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script(libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version:)
  end

  test do
    (testpath/"minimal.yaml").write <<~YAML
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
    YAML

    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes (testpath/"index.html").read, "<h1>Simple API</h1>"
  end
end
