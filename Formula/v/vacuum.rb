class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "1ff103a4078d02254bf7ec20896b8a8855bfdf28eb0aa96a865b6ef19a8e5a28"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4d98a315c5a003bf92a0ab526072411c90967031c333d675436783f670f19a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fbf3a45bedb2d7ce451591d958157aedcbd9bf6261bc1aa57bb1d246d80f8c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfad726c1fa74f54fa14834368d649814cbd606b168029910a4c663a27593315"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4aa10fcf7368f69877ff5da7c058375073bde245e3ab63d0c2e2bc19cd61c503"
    sha256 cellar: :any,                 x86_64_linux:      "f2f5107a499ae08f5b7db8340fcec5246071632e74dab257926373c5df4a1ae1"
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
