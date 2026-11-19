class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "b3f90b99b6428f17752cb4e228851e65d2f5f2585dcac6619f6e5df6b42524c9"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f4a24c516cc9cf6144b02a74a7bbb8521659ab059477c3c246096051a5d7fbfe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "268bbad3eb239e4965124d14ab93ad216add29be863f91b105425482e1886e0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45123113580bd87b8a97e83fb20428dfad01640e45e48b83afb7aeb027dc5397"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "61c882de8d5373b02cc8f6af0dc6248a35c927f51c5339bddac3cdf81c53b49b"
    sha256 cellar: :any,                 x86_64_linux:      "062197b68eff4636fe0b7aa3421b95c56179da310d037acddddca971ef27a6a5"
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
