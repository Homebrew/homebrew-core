class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.0.5",
      revision: "1df153a7995e28bcfc2358199adb1f8f19d31def"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf3604f57bd03943e578d9456af2c0658c2f0f820326e320440c58ac7bd166f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf3604f57bd03943e578d9456af2c0658c2f0f820326e320440c58ac7bd166f3"
    sha256 cellar: :any_skip_relocation, monterey:       "1a5e1f409d2fccc5200798dac8cbbb4e35bd3a8fa96ed4beb486d68cbe299f72"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a5e1f409d2fccc5200798dac8cbbb4e35bd3a8fa96ed4beb486d68cbe299f72"
    sha256 cellar: :any_skip_relocation, catalina:       "1a5e1f409d2fccc5200798dac8cbbb4e35bd3a8fa96ed4beb486d68cbe299f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c830ceaeda00872eef8730fdd2e5beed4c8e703bc516b2d80c6743850c42aac1"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/v8/cmd/zbctl/internal/commands"
      ldflags = %W[
        -w
        -X #{project}.Version=#{version}
        -X #{project}.Commit=#{commit}
      ]
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags: ldflags)

      generate_completions_from_executable(bin/"zbctl", "completion")
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end
