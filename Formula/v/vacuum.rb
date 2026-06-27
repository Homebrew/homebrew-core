class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.6.tar.gz"
  sha256 "20b24fb86e715eeccf172ffba7839829b68eea1c677a0a4883640a39e0bf5d07"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fa698d6972f10b0297bc597b5c82f2a998dc33bd27fa8143948d05308cbb7e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59008e2d0f4074b8ae4d6e7e45be8aaa151c610546b51a108748f87b45138b73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22c5922584fafa9a27a202ef28421c29b855c3643ac9427e89112e12252f3839"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d65aba6e3e8d10a69792f11dce6baf50a1b2f1f439874827700ceb8b10661da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99377dcb8a7a78d8a05c49f74e5bc8e506c6b2221e926a02b53f7e117e98a6c5"
    sha256 cellar: :any,                 x86_64_linux:  "ba0642cfbd3cb482e18342f0d19a24fb6bd0594e14f7d2376ae2ff36e2d369ef"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "html-report/ui" do
      system "yarn", "install", "--frozen-lockfile"
      system "yarn", "build"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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
