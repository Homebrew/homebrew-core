class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "face6af69249a83046e2f074217f0b14bc1cd7244aae03f16fa5e882978e1b74"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fce4f14181182c7fc19c0dd28459425305c2567291fafa518cb88a1c11473c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3878d549e42a31d837fe6253f0ce9eef4017a0b4dbd0c96021a94e2b2ed8f1c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d4873b95a26ce5385dbc65cd9d1576dffbc0ab138d283f68ff64dedc8dcaec0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0743a53a7661e1794a67ffe8393956614a6260e5e58c7c3789fbf844490acc9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccc741b33b79102e030951d5601159945a3dd3d01d65256d067640f1fc3e8137"
    sha256 cellar: :any,                 x86_64_linux:  "efec76fd6830ead1710963d767800a0be6d030fe2e52c1ff2db1045ec22d3b00"
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
