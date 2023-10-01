class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.13",
      revision: "0235787fc28321534a8ab25e7628253e1e39312a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a1e2c1049bb2696469e0d4589d6fb873d20a7bd6cb58479560d0bfd18513119"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a1e2c1049bb2696469e0d4589d6fb873d20a7bd6cb58479560d0bfd18513119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a1e2c1049bb2696469e0d4589d6fb873d20a7bd6cb58479560d0bfd18513119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a1e2c1049bb2696469e0d4589d6fb873d20a7bd6cb58479560d0bfd18513119"
    sha256 cellar: :any_skip_relocation, sonoma:         "180dd74ce44a0681a003f7fd67b17adfb5f87d43bb7de6532530e64cdf66ad24"
    sha256 cellar: :any_skip_relocation, ventura:        "180dd74ce44a0681a003f7fd67b17adfb5f87d43bb7de6532530e64cdf66ad24"
    sha256 cellar: :any_skip_relocation, monterey:       "180dd74ce44a0681a003f7fd67b17adfb5f87d43bb7de6532530e64cdf66ad24"
    sha256 cellar: :any_skip_relocation, big_sur:        "180dd74ce44a0681a003f7fd67b17adfb5f87d43bb7de6532530e64cdf66ad24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f867f9682a7d5cb072fb0c94d5f97683cde59404c021408df3db865a6219350f"
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
