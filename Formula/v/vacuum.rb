class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "e53ff6e3fcb40db676a349012b7ad7e14bc4259328f8853690afe9bbdc166cda"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a30d83955fd9c7dbf7940233cc66aff1d227995d30fb53cadc188b804c8b0ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55b331fcd91c4d54b207d83cffffd87866605e40a3294aa6db87c78a83f0f7a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a4f42f5ab4f9233abf998ce5273af6f6a2cf800c595a14db0ff189564aaac30"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a105ed0aa4b2c4f64b109d5ffe517064791c37fbb44568d7bd34d50feed56ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20e965d3e529ba7cd77fad7a55fd90fda84a6003946c0fcfa1cbf7e95896f3a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62b135a7320e0a06f598d52c21a18287da5fafbe6432dfddd6bdb67c8cf4fa5"
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
