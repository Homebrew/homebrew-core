class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "66dadabf33742368e7ed748be220b60f57d97388fb5140857a16ef269cea5b59"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5466d0b61e9756efdb1293b038deea671c3a3548ed556902df4ad7c1ea751d06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c4ab18d03d918d1c2ca272d855aa66e14a524cce4c6d2c2c5514eca5cf9cf52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64816434af305bcd6ca7e1fe010217865a66ad134d26a85d6786fb62b6438665"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2afb48078028e3cab4e7091b5d8c4f0f0ce9ba0e4a45b7df3bd5b270ada9df8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a170d19625c49b6a3beb3f8a88e40bfc066009d79a22a386cc09045e622495e3"
    sha256 cellar: :any,                 x86_64_linux:  "e23c634c457fc06416e001e5974dbca19dfc698ce4865a98be37ad2bc683245a"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "html-report/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
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
