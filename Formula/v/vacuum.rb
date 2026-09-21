class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.30.6.tar.gz"
  sha256 "1c3c3ee6e02f6d6611c578619592b98bc14dc132d86ec410386ec26bedbc4383"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6e8a1d24a3c9a0256ee2c168bbb881dc4a29cfefdf1db5d5ad32671bdacfa85"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "510001d6238369a67d6ffac9fcd5c55aaec63c142e3a0300d23414e54e0d8498"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37ed2e6daf40fb17ddfeb0dc7915074b9edd11c16efaae47ee2d31f7625584e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14be79b07ba005ab9f334a7b20d130c0ee46a0f69b9499cd2365abc3d66bf69c"
    sha256 cellar: :any,                 x86_64_linux:      "c083b6d7e57af631f69dc140796cae270b66f04f58f41de5a2a398015d0ee3b2"
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
