class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.1.9",
      revision: "6d0999a27969dea3603d8ec43d838eabbcbf42f9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e06616c4c86ea50fe57159ffbb0d21d8edb2c96e8e7f54c37efadb80d68f51d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e06616c4c86ea50fe57159ffbb0d21d8edb2c96e8e7f54c37efadb80d68f51d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e06616c4c86ea50fe57159ffbb0d21d8edb2c96e8e7f54c37efadb80d68f51d"
    sha256 cellar: :any_skip_relocation, ventura:        "062b2690b551441d3b8c3c0487c1ddf7f0fedc188b414114a917c5ec5444cd5a"
    sha256 cellar: :any_skip_relocation, monterey:       "062b2690b551441d3b8c3c0487c1ddf7f0fedc188b414114a917c5ec5444cd5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "062b2690b551441d3b8c3c0487c1ddf7f0fedc188b414114a917c5ec5444cd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb9490bc4fdea59ef2b038076b0cbc843b995029d3fe4e76df2d7180783bc6b"
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
