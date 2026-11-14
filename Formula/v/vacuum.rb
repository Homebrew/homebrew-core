class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "2e0418bfedd9d99eb660c138195e842f88101b5e063f97be7fa940d75121830e"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e54775cc06b223b5a84ea16973f6bf8334d2fb7de56cdcca2bf76a53aa22033"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "40db7ce160f75689cb5fbde4b734b06a36b17006f53e841ece08f9f5eb5b1811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c64bc1755d5d72abf8fad256dcdc742ec8bd3f1060850a74b9004a4f6c30621e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9f07356f9f313be54e02a93fa411d316537e4f21ae5361907bcde775259ffe6"
    sha256 cellar: :any,                 x86_64_linux:      "8aef31bb820efd4fdcca6656534362c876ccdeb6a37e0673b218fa0779e4777c"
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
