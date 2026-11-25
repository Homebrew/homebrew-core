class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "42ad95c114a333483e87d2eeeb668bbc2ed2521f536fad961d3b366d83e55599"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    manifest_sha256 "b27250ae4c93e39c8cbdab7c49e86af4f685f25cd9cd164f86f6b59e907c2efd"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50c4310bb4fa8950d8653f6c2fc54948925d7c2e379888a53649142b2bbabf98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "029f0fec35ca7eabe48dae5b407dd6d62e02e32b4a10e9375eab3c5baaa91d45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea845b5305f7fb4eb48165842186732222493d221227e611f4295948bc0a4bda"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d7c3d043316ab9674f21cc5a774a9a566dbd067d9c123522a05cb37682b470c"
    sha256 cellar: :any,                 x86_64_linux:      "7da4c1e85bc75b0cceeab15ba08035e18086e8e4f8cc144725f9bd7d4565dabd"
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
