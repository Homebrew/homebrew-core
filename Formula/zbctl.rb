class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda-cloud/zeebe.git",
      tag:      "1.3.6",
      revision: "897b7ed59fa91ceaf1209e47082acab6386aec3e"
  license "Apache-2.0"
  head "https://github.com/camunda-cloud/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c2842ea5d0d13100a9dd5a3d43b71d05781189aaa84ec2bff416f6a2592f8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94c2842ea5d0d13100a9dd5a3d43b71d05781189aaa84ec2bff416f6a2592f8a"
    sha256 cellar: :any_skip_relocation, monterey:       "f11bcf6cd40d5ca9ffe0e93bcc5618eba1d89c5323831b5c227f59abcdba6d4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f11bcf6cd40d5ca9ffe0e93bcc5618eba1d89c5323831b5c227f59abcdba6d4e"
    sha256 cellar: :any_skip_relocation, catalina:       "f11bcf6cd40d5ca9ffe0e93bcc5618eba1d89c5323831b5c227f59abcdba6d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d83fe05160112225586110bbbbfb31d8d8e88e5c80494dc6c59604045420806"
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
