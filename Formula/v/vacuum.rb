class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "fcff39d506d77b0ed6387309635b117a31b9b192b1c69128ad58139c49496cd3"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "040e27443d3f3b8be573ddc50b9e7b141b7c35139cf7f308fe96096a43d72088"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c906ceb1d493fbcf16325978400a0b2004c6bc6f4186c7ce75f8001dd74a8124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "611dbff0e670b9508bd61a8ffe7eeb75bf438bdb8c67479735de588467a44cec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "79436246ae1f142a3c2bbc87dc367a2a386e0f826f8e4c5b1fe590aa9ae470fd"
    sha256 cellar: :any,                 x86_64_linux:      "3d48e8f1304f6c8c406b0e54c7cb02ebf25f8fa34a0457001b1501dcd9958993"
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
