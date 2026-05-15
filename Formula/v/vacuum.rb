class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "9d200267f8ce96bd90079ae457df82bf7fd0f4cc7481681b5b6013ed0a74350e"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93f76b0b9aeeb74368eb2074bf2ae259c579337f9f4a47559c7ef83de2bd6f72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca293a4b2da49ba7ad51dc263528fcf87dd1da9f49441dc3b7cdb4a7e3d6b8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "974156aad94840652b955105fa9dea0697096e8e5e97f419e06cb8bd474e32de"
    sha256 cellar: :any_skip_relocation, sonoma:        "87accf613e2ba5a384fcc27199c8522a85e4e5613268a4dbe2fcc0a0392fd32a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "605633200156d46d7316f4e2ad580b5ff447bcaa34137809cda0f68c2670904e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1c91f4c5c256eeba194c47cb06359445a2226e074822476f2106bcf1ea2e2ec"
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
    system "go", "build", *std_go_args(ldflags:)

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
  end
end
