class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.6",
      revision: "e3fe321264899ca4994e52591c0422804bd89461"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bac110aaf21efa5c05efe7a0dbd6f56ab806116be7e811908d489fa690567856"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bac110aaf21efa5c05efe7a0dbd6f56ab806116be7e811908d489fa690567856"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bac110aaf21efa5c05efe7a0dbd6f56ab806116be7e811908d489fa690567856"
    sha256 cellar: :any_skip_relocation, ventura:        "e670a74d8b925a6ce0ca275fae17980c246aec2eeee10b20cd94214ca1de52c0"
    sha256 cellar: :any_skip_relocation, monterey:       "e670a74d8b925a6ce0ca275fae17980c246aec2eeee10b20cd94214ca1de52c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e670a74d8b925a6ce0ca275fae17980c246aec2eeee10b20cd94214ca1de52c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83cff0b65b83059ffdcfe7d237d9a878c86cb57eed92330bb0d9bd0ba588b533"
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
