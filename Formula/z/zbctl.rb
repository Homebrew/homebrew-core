class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://github.com/camunda-community-hub/zeebe-client-go"
  url "https://github.com/camunda-community-hub/zeebe-client-go/archive/refs/tags/v8.7.0.tar.gz"
  sha256 "7798bd2bb8719b18e767acbd31ea7db69f0b170c799b5ef98aa988be2d06dddf"
  license "Apache-2.0"
  head "https://github.com/camunda-community-hub/zeebe-client-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59ca5c0487e4edbcab68fe4f54e4429b47530c85f619ebe61cb4e0ae94464ad9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59ca5c0487e4edbcab68fe4f54e4429b47530c85f619ebe61cb4e0ae94464ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59ca5c0487e4edbcab68fe4f54e4429b47530c85f619ebe61cb4e0ae94464ad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "364f876215bf5a239077d80137db3db3703538de37f65bd33f05fe4d7e18a64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e8577d7a2f3ed00363bd45ec4ba139112bdd891590b63d13d1bad4cacf114255"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def install
    project = "github.com/camunda-community-hub/zeebe-client-go/v#{version.major}/cmd/zbctl/internal/commands"
    ldflags = "-X #{project}.Version=#{version} -X #{project}.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "./cmd/zbctl"

    generate_completions_from_executable(bin/"zbctl", shell_parameter_format: :cobra)
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing: dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output

    assert_match version.to_s, shell_output("#{bin}/zbctl version")
  end
end
