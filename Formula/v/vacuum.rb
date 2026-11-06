class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.39.3.tar.gz"
  sha256 "004526686092ef3e4a70b0c2af932435bdb8f1c7ff9a3cd6e4924edd5f41d28e"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96573556e5e5dd43da0c3d51a11272be668c741fb94c3c86729dacd6fd59c0d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "780780fa01dedef67cf1cef05ce1f3e8f51d03f1dd5065ad57c6d325eaca6fc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56e4a85c7ae672e50e803c2b8614f4aaf01e1a68661e1b0f750cd7db658d9309"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97d4186b700d2897aaa815925cea3899e699cc64010b00081bb2d540c3fb4399"
    sha256 cellar: :any,                 x86_64_linux:      "f9ca272577d35f54c1f26808bbb87b1e97e9f01172c95f2b37529bd8c826d5ae"
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
