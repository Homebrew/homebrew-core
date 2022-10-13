class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.1",
      revision: "d19942a6d60ec70f66148cf958454f7b5fb0d455"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf2aa67b8f06dfff8690c31a5b3f94a6120fe113b3d267368cff335538892713"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf2aa67b8f06dfff8690c31a5b3f94a6120fe113b3d267368cff335538892713"
    sha256 cellar: :any_skip_relocation, monterey:       "4d3b965693acfeec3125dfb1c22e6f55adddabe6919a4fd05efe7cb2dbd45fae"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d3b965693acfeec3125dfb1c22e6f55adddabe6919a4fd05efe7cb2dbd45fae"
    sha256 cellar: :any_skip_relocation, catalina:       "4d3b965693acfeec3125dfb1c22e6f55adddabe6919a4fd05efe7cb2dbd45fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de78ec110950f44c1571dcb654e427c29abd1a800ad70d4cf7fecb08aa668a2"
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
