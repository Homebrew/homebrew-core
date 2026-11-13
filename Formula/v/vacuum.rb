class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "eda9c5ba9eeff5bf8c0b9ffc9e5554663cf9b6c3b3305fe9c376f6ed6badca10"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5ab71378f83f60da77467d07f6238b59f3c1519db0a0994545ba53d343c0510"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77d0072dc76822cf33db2064acb37b2a2a2de99d07222c398e3c4006224e9503"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57d5e95f23740226d0431b971f936bdfc960c7217b725655fb88bebcc92f46d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "677357793517a7e74a3dca7a1c9b194acc9d5fef120e96e65b4afef38a6a023c"
    sha256 cellar: :any,                 x86_64_linux:      "e05a09ca4d3c8d9b3ebc79d20107583ffb909743d9cace7d84ccfaf675b45768"
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
