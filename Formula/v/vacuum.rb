class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "ceb4cc374456d65c0480dd764ff3adf1f1b741da9ab493077265c9cf89e676ce"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "938adc89fc87510a9f291f5280bd0d4fc476c30c0db0ed62da4046d43d485208"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e46d3c96f2af5ec531c74af913c453ac2c42b7223505f4b49bc8ccf09024c484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12112a760b78821c883b3b1b037a198c78f110d50269d6812c97e20c26a5b1ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "488763b635530c28df877ad94d0f67fcafd58d4c79e9f7b39ec569b589ef1627"
    sha256 cellar: :any,                 x86_64_linux:      "a19128c41bed0133bda5c47e52b0b88e6c374005e99e246d2d30bc0681cda899"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "html-report/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, tags: "html_report_ui")

    generate_completions_from_executable(bin/"vacuum", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacuum version")

    (testpath/"test-openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
      paths:
        /test:
          get:
            responses:
              '200':
                description: Successful response
    YAML

    output = shell_output("#{bin}/vacuum lint #{testpath}/test-openapi.yml 2>&1", 1)
    assert_match "Failed with 2 errors, 3 warnings and 0 informs.", output

    output = shell_output("#{bin}/vacuum html-report 2>&1", 2)
    assert_match "please supply an OpenAPI", output
    assert_match "generate an HTML Report", output
    refute_match "html-report support is not included in this build", output
  end
end
