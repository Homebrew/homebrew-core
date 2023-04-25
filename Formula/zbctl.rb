class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.3",
      revision: "25bdd43aba09d8189b8a60c3def3e6ed14984c4b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17f64b68b7e763f1402651030f26bee82815ca0e8ec417cf846f39f4643646d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17f64b68b7e763f1402651030f26bee82815ca0e8ec417cf846f39f4643646d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17f64b68b7e763f1402651030f26bee82815ca0e8ec417cf846f39f4643646d2"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a31e45562437c27c1951f6229f6af4c0e2b49862c779776d71e8bc46bd1a8a"
    sha256 cellar: :any_skip_relocation, monterey:       "f2a31e45562437c27c1951f6229f6af4c0e2b49862c779776d71e8bc46bd1a8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2a31e45562437c27c1951f6229f6af4c0e2b49862c779776d71e8bc46bd1a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d5404bb161eadb7b6569c258297e0e6d7b28d25863b28a65038acebad8c4f0f"
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
