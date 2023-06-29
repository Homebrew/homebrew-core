class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.7",
      revision: "e386bbd132c4b286d76bc825f781c77e76f90eb4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3464dd86d5a1572492ff94cf7bf45ec9f1498ecc01e86bf5cc9ea7fee4f0ced8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3464dd86d5a1572492ff94cf7bf45ec9f1498ecc01e86bf5cc9ea7fee4f0ced8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3464dd86d5a1572492ff94cf7bf45ec9f1498ecc01e86bf5cc9ea7fee4f0ced8"
    sha256 cellar: :any_skip_relocation, ventura:        "029e7b16275a75bb2bf49e6aeba2cea06a10a56c66a0cfb000ce795bac6d3f2b"
    sha256 cellar: :any_skip_relocation, monterey:       "029e7b16275a75bb2bf49e6aeba2cea06a10a56c66a0cfb000ce795bac6d3f2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "029e7b16275a75bb2bf49e6aeba2cea06a10a56c66a0cfb000ce795bac6d3f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cbf7140c9412a2ca795972c42f0258194eba16648ca518af15a0d8c3c477839"
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
      "desc = \"transport: Error while dialing: dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end
