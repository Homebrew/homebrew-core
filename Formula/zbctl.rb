class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.0.3",
      revision: "58aac394e8994116c15e7ce10774567665ce0912"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5b664e70d1ffb74e5f05637a0486c7e6df44a1c1a10b3d4f7290b5a0bc02808"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5b664e70d1ffb74e5f05637a0486c7e6df44a1c1a10b3d4f7290b5a0bc02808"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ef689142dc849dd089ab7d7a27801315ca99e1bc097a8e6e1042576aedbe55"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4ef689142dc849dd089ab7d7a27801315ca99e1bc097a8e6e1042576aedbe55"
    sha256 cellar: :any_skip_relocation, catalina:       "a4ef689142dc849dd089ab7d7a27801315ca99e1bc097a8e6e1042576aedbe55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bec7c5bb6bd634cab2b507b8e45e6b17a160977424fb800f4906b8279fb2f542"
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
