class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.4",
      revision: "a4a6f2dd10d34d3fd4dde287a55930f5a7026123"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17fe9ecab0320de310d735976176f11147e16d588d607634b268818a0126457e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17fe9ecab0320de310d735976176f11147e16d588d607634b268818a0126457e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17fe9ecab0320de310d735976176f11147e16d588d607634b268818a0126457e"
    sha256 cellar: :any_skip_relocation, monterey:       "96e39f41d95c5a46cabf098d763d051bf4661e72af87aed1d0341bc5b69a1b7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "96e39f41d95c5a46cabf098d763d051bf4661e72af87aed1d0341bc5b69a1b7d"
    sha256 cellar: :any_skip_relocation, catalina:       "96e39f41d95c5a46cabf098d763d051bf4661e72af87aed1d0341bc5b69a1b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ed4f21dc069d48ca372d851eb1c7ff14ae4eef899ebda776ad4e1cd005455ad"
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
