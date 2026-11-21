class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "9883c8b3d5b50184191986b748064a97cabda7538b647c7b36c08bf20b536a83"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    manifest_sha256 "c4f52d55e2e54251856c823ed97e33df0d4c630556a7bba5dddebeec30a882ad"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b0230171fec3a00e9de8284008e5f29c6ddfebf6ff22432ac852f79408896a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "adb4c2aea8732ca6b99f90191e4a53ce59e644bb944dad4c7d80b469a03d589b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bef37cd00a1feb4de402302f96781d305a1d61a84e30e3a357ce591ecf6e509"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "51aa21c62115128e5bd79d8a3380037aa6a1ce00699759f61d81f90484418f01"
    sha256 cellar: :any,                 x86_64_linux:      "f28308afe930dbcc6089fefa6bc690e620829f05ea25fd1bcdb6df4d262a1f00"
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
