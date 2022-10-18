class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.2",
      revision: "5c74630358aa4d6f29876e9f2014ef75bd7156e8"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51b929437219dddca0755632d65c022c697af7647483d3009e540098e5491115"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51b929437219dddca0755632d65c022c697af7647483d3009e540098e5491115"
    sha256 cellar: :any_skip_relocation, monterey:       "ca709786a085ef25e7cedeb2f9057eaac49cd78b509f03fbabed469cb97e607d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca709786a085ef25e7cedeb2f9057eaac49cd78b509f03fbabed469cb97e607d"
    sha256 cellar: :any_skip_relocation, catalina:       "ca709786a085ef25e7cedeb2f9057eaac49cd78b509f03fbabed469cb97e607d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c903f2ec01a47c8db17358f0c2614b55041cd005a7b42f614db7a53f878beca"
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
