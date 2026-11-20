class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "177bd0fa166b16f309f64c5a067b47c0f2ef3a167c114c455fa756416b5acc14"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10a8731d40e7bab32771df82bbf22ff934bfe3e31c1b3509048ce49fc0567391"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e0d2a9444a5e8a2907d55092b959b55a98ab24d5e2eb161ac970dcbcb40e0a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3723171831e4fad1185a5827e04570e9fbe87aedb2574e2b5eb66f32d48c941f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a0ae61b0cd9c137c499b7f6ace72b4068a7499a4c00c49036a7701032ac477c5"
    sha256 cellar: :any,                 x86_64_linux:      "b0fc13012a8535824b0ece6ea6b84a9ed6690139426920fb6f2eaf18d499139c"
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
