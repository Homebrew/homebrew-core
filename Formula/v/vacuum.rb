class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.39.3.tar.gz"
  sha256 "004526686092ef3e4a70b0c2af932435bdb8f1c7ff9a3cd6e4924edd5f41d28e"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9fc2736c01f3a3bbb9dd9bf4dee47224a8f03e8861957f8fafb0e1f3f618eba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "80b1eb227210087a7a164110ce7fffbe7c4e28ec310449a399dc07b50c482688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89cc26836add910072030b26ca02b54f36e54b8ad147eeda168f23249763de57"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd87390eb14483b09bd7c4ddd6e2f4983fc4d93e995123cc1cebf133d627ebbe"
    sha256 cellar: :any,                 x86_64_linux:      "0b02ac22835c5f4cf74b8fcebf36a1140f7bf70f56e182dc354eb9129dbea46a"
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
