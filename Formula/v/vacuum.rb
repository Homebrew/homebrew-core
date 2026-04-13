class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "b961dbe0e4594af6e29d48ed2eaa26b6d857ebac952d9818fec6de716a89ff59"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaaccc6c4a2b16fa325645a0d12995984d3def961e9c1afa828dd784e4b3bff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c31ccbd7b46303c7725d6bc55e6e3bcbca625739ade1bffec2721350779d1358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5ede424d1581007c780d5998e85d50a78ec64eecdd0f2d347d530c6c8a2a732"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0bdbe85020b0f6aa8df1e0266f3bc6dc1f65b36861d9b419f8fd09ade0bca3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c60a7606836c665ed08c41d8e6f727b7bd97e0071814982cee8f4254d35221d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f9b3bd713066afb9929c3290f180af6a51814ca5ec66137b3dde2e0071d74f5"
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
