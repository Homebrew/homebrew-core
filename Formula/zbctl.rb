class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda-cloud/zeebe.git",
      tag:      "1.3.6",
      revision: "897b7ed59fa91ceaf1209e47082acab6386aec3e"
  license "Apache-2.0"
  head "https://github.com/camunda-cloud/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67abeda5a30b952b5e6748dde8dcc6b21b17ad1c92260e280aff36e36bc080b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67abeda5a30b952b5e6748dde8dcc6b21b17ad1c92260e280aff36e36bc080b3"
    sha256 cellar: :any_skip_relocation, monterey:       "266ab25201c289ae779684a6bd50bfccc643346e383190f854966f21c7076eed"
    sha256 cellar: :any_skip_relocation, big_sur:        "266ab25201c289ae779684a6bd50bfccc643346e383190f854966f21c7076eed"
    sha256 cellar: :any_skip_relocation, catalina:       "266ab25201c289ae779684a6bd50bfccc643346e383190f854966f21c7076eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92695f5e327ae50738ffcc7aa2ae0c2a7003e006222d2841803c6d98644d1074"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clients/go/cmd/zbctl" do
      project = "github.com/camunda-cloud/zeebe/clients/go/cmd/zbctl/internal/commands"
      ldflags = %W[
        -w
        -X #{project}.Version=#{version}
        -X #{project}.Commit=#{commit}
      ]
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code =" \
      " Unavailable desc = connection error:" \
      " desc = \"transport: Error while dialing dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end
