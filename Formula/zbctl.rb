class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.8",
      revision: "e491a2a024dba1f4e992dc1e4ef3bbdb5cf6b87c"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96ca56e1662d1820abea31a1cb6a0f529a7b504524c7fc58e3b021eb835e17b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96ca56e1662d1820abea31a1cb6a0f529a7b504524c7fc58e3b021eb835e17b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96ca56e1662d1820abea31a1cb6a0f529a7b504524c7fc58e3b021eb835e17b6"
    sha256 cellar: :any_skip_relocation, ventura:        "4fe1b1cb13ebe411616f5f5755105848baab15e33d2698d2390cb3f8fb877790"
    sha256 cellar: :any_skip_relocation, monterey:       "4fe1b1cb13ebe411616f5f5755105848baab15e33d2698d2390cb3f8fb877790"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fe1b1cb13ebe411616f5f5755105848baab15e33d2698d2390cb3f8fb877790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b25fc0956067821b43b5a188e6639646cc891bde8658c8061f80d678df959990"
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
