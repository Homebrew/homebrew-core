class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.42.3.tar.gz"
  sha256 "670de61af66b69b55d080676ddac476da21a31b961f96810f1d17470c9429306"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    manifest_sha256 "4ae37c4c5a994eb8cdbd56f1cab7390a3aecbe36bc5056ef79529a5c1d943653"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "153146be29ac210e5bfdf290c3cc27ab6fc0e6045636c0299670e3bfaf287900"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8168b345299489a27d22dad564d5378735252b8b78e3d609dbfb5c5f30d3f8c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb852718aded705f05ba50351e59d2bde46096fdf81eb8ed3f60a0ca05e9da43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa4de8ab3161f0be56f0bac0b95010b3afb977459406ab431b29c1fa781823bf"
    sha256 cellar: :any,                 x86_64_linux:      "7ae15fe072e389c3c543a287843b0c46ea43d68b236def93ea05362647db28b3"
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
