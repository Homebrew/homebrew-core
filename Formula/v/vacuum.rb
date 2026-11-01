class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "1ff103a4078d02254bf7ec20896b8a8855bfdf28eb0aa96a865b6ef19a8e5a28"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35d9746fff5de90b62b21772b9773b151797c0df4ac2a9819dc4e0e2ff6566ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd7afd128704856af7ce799904a4321297e796c073965619844328435010ed00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afe30da695b5a0a5bddd5312f9a2cf9d5c84dc8497446e8d0e2d39218a5d0f30"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6719c393c6c990c4c5da0106c487dbc250f568172c247745f93ab7f6d70d565e"
    sha256 cellar: :any,                 x86_64_linux:      "6849f8c7d3b88384dc469acc64f1593c6054108743b49ffc9be4f6affe4848d3"
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
