class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda-cloud/zeebe.git",
      tag:      "1.2.9",
      revision: "b55242898afe0dd93b87fa0b464f7c4d9a10bbad"
  license "Apache-2.0"
  head "https://github.com/camunda-cloud/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3e371b9cb6a84ef2ff97011c41da59fbab979cf51c471b38ef1577614a44338"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3e371b9cb6a84ef2ff97011c41da59fbab979cf51c471b38ef1577614a44338"
    sha256 cellar: :any_skip_relocation, monterey:       "22141eaa052feaddd41c8e2f52677eb6a8eaa7893d18e3e39128974a34d611dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "22141eaa052feaddd41c8e2f52677eb6a8eaa7893d18e3e39128974a34d611dd"
    sha256 cellar: :any_skip_relocation, catalina:       "22141eaa052feaddd41c8e2f52677eb6a8eaa7893d18e3e39128974a34d611dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da943af497ffe7af297c23478e6e484d475ee86c052b3878dc18b8fc65a239c"
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
