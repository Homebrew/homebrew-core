class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "e78ef5adb5bb92fb6d7d2bbfbca3d98e675269027523a962441e598976307a77"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9de83c9630419a7c014e51646bdfc0db2c06fbccabe65f9d2d3f07e3eb864023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "455ac52ddede04b4e96e33a101efd21758c0f46ee5f95720ea91aa261515d044"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "700ba919ce4d512ad31980af718764cb70862a1468cb2652b9b9210666d8f720"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebcc6093a677646c8c6bd960801b2508485504444bc440cef76e1ba18eaba669"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0dad3ec0f874df348f8d92aa4f3914778035c5b9966cd215e664d85f264b821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "657c2321f0df90ea7235860b9efc650a87e77297d59d17c162fda4efe7051699"
  end

  depends_on "go" => :build

  def install
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
