class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.28.4.tar.gz"
  sha256 "669efe71e06bc8e59f293d3e015f96aa5d55aa28b59bcc960b6925592ab92511"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09b4dbcd13cccd8454615d12713384236b2d453f673ae8185f37b7e4b71ea9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4d70625fb56e29df33815fa08ec63b88bb12333014e1a69ab65581808c6574"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e9ef182f463295132ce75c61f3c5822b5e3431044e5e0b05c2d649562d862d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c37e28b13d01817ecbda85aa1128d29424c932cc975c970d82c5d9d1e590b50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb31062a3f3933f0f52c8f7e336f73210e8857fe70c4b60270b12222ce2a2115"
    sha256 cellar: :any,                 x86_64_linux:  "c07a87bffe884f103f097f4654864156d053060f9136c413317f2df4772684c7"
  end

  deprecate! date: "2026-06-03", because: :unsupported, replacement_cask: "daveshanley/vacuum/vacuum"
  disable! date: "2026-12-03", because: :unsupported, replacement_cask: "daveshanley/vacuum/vacuum"

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
