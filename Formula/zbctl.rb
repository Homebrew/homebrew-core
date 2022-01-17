class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda-cloud/zeebe.git",
      tag:      "1.3.1",
      revision: "737fb5b8bd68b8ee170c10ee8f97d679293c1e99"
  license "Apache-2.0"
  head "https://github.com/camunda-cloud/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7cb70bbf00f1b3032da1072827d41eb00333eb99387b8e7295131925ba9e325"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7cb70bbf00f1b3032da1072827d41eb00333eb99387b8e7295131925ba9e325"
    sha256 cellar: :any_skip_relocation, monterey:       "13be1a4ba7be054cc187c980ab34a4892225302574538c7dc68a6f04b81c446d"
    sha256 cellar: :any_skip_relocation, big_sur:        "13be1a4ba7be054cc187c980ab34a4892225302574538c7dc68a6f04b81c446d"
    sha256 cellar: :any_skip_relocation, catalina:       "13be1a4ba7be054cc187c980ab34a4892225302574538c7dc68a6f04b81c446d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96c0b7496b5d794d14dd2b65877164571ebaa5eeecea7092da1a6d5e7c3ff427"
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
