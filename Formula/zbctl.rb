class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.7",
      revision: "7992e3e941dc335c829f8ebb2fa3f1b44e0cc243"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab4100a4439dfd36fb307cbc906e95a923819d09ea36dacee62aaabd6f5ac067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab4100a4439dfd36fb307cbc906e95a923819d09ea36dacee62aaabd6f5ac067"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab4100a4439dfd36fb307cbc906e95a923819d09ea36dacee62aaabd6f5ac067"
    sha256 cellar: :any_skip_relocation, ventura:        "ca962e54688a851e4dba9b124cc8fbb4c3ccbcba819022d53a8ce433deaa6049"
    sha256 cellar: :any_skip_relocation, monterey:       "ca962e54688a851e4dba9b124cc8fbb4c3ccbcba819022d53a8ce433deaa6049"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca962e54688a851e4dba9b124cc8fbb4c3ccbcba819022d53a8ce433deaa6049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51c42028f0262c99e33d61ecd66040b4832c8799be3b0a12919f434bc786579c"
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
