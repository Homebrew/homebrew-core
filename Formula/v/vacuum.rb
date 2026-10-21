class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "da6199101310cd3d15faa9c8cc51fac0a16d052f98dd4af0474707a0547f1277"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5f101b275cff31d4adc3085b3d360530242ede7dd2877f3449aa140aa07cae4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "696b23cc97aa7adcb02c5b42be1ec87b21b75d22bb8fe8b1897d34421e9241f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a3b3e14cc2dab0cd3ab3c842482b43afdc6b2e8f8bfc013c8771723a3e3c030"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac9dee226bfe6ca0815592e8a687345372cfca846971034823770788b3f2cb7f"
    sha256 cellar: :any,                 x86_64_linux:      "89908d8a7d903e8b2e9259cd762357ccd16aa29d594d94ae2a77662eab7d7446"
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
