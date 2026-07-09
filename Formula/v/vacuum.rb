class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.9.tar.gz"
  sha256 "c6becf62f8eca4bf46bf2b38dad055e7c9cc7461d8578cfe3daa4a5304a16d2f"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62f8f75e5f7624967d2de409d3f600ec2fc75be0f5dd11eda0cc58441594235b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "076b2d9fac28d9d7bd307463e6f6395402de01b49c46b40a93b1c71d5ac5c64b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a318e00627b22c90dda354ad50889f56c2918335428596b6f4c35b0287a8b22f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e000d28460edb8a16396127bcfc5275eb450fa7782e50682c0d929b97acdb4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "091f69c6ee2b9f15f2c2fb5dd1cb52244468187a1d6cee5726af1acbc7b9ca1c"
    sha256 cellar: :any,                 x86_64_linux:  "c49fc9f8ad46c856d2f29c103b7e3430922bdb9797b288850972f66a51092ea3"
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
