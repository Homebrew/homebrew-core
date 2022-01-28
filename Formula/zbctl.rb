class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda-cloud/zeebe.git",
      tag:      "1.3.2",
      revision: "2c177b1e87b92117eb69fa24ad42b17e95f1737f"
  license "Apache-2.0"
  head "https://github.com/camunda-cloud/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe39202fae8087ab5b3902988de861c9577637cdea2a6f92ce8320aa39bcd4a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe39202fae8087ab5b3902988de861c9577637cdea2a6f92ce8320aa39bcd4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "21f1cc22eb3689c86753cfc7d8715bee15cd7b68ab009003099efd8cf4a424d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "21f1cc22eb3689c86753cfc7d8715bee15cd7b68ab009003099efd8cf4a424d6"
    sha256 cellar: :any_skip_relocation, catalina:       "21f1cc22eb3689c86753cfc7d8715bee15cd7b68ab009003099efd8cf4a424d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7b9f6ef7d345790b96923496210981d552cf4064397bbe313249b6fb04ff12"
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
