class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.3.0",
      revision: "8e76d6b8cbe6e3eedfb822d91cf5bb8621022d86"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "282ffca743ea56c158f81af0a276f730b6cc22c6e02ff44f8388c002fdd46a38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "282ffca743ea56c158f81af0a276f730b6cc22c6e02ff44f8388c002fdd46a38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282ffca743ea56c158f81af0a276f730b6cc22c6e02ff44f8388c002fdd46a38"
    sha256 cellar: :any_skip_relocation, sonoma:         "825e4de3101ae40d10bfe15b1aad80b0c4e74f17600ef466a9bed2b1c21ed316"
    sha256 cellar: :any_skip_relocation, ventura:        "825e4de3101ae40d10bfe15b1aad80b0c4e74f17600ef466a9bed2b1c21ed316"
    sha256 cellar: :any_skip_relocation, monterey:       "825e4de3101ae40d10bfe15b1aad80b0c4e74f17600ef466a9bed2b1c21ed316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6e28111c907c5cdfa68021ba1ceb57f7ad6ed455ef3a35f60b813ca9f87a8de"
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
