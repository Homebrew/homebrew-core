class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.12",
      revision: "87328facf23bbfc324c0e3eb4ddfd8e56522e620"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e0e94cda21a8176d48fbc702d0e128674a5b9fe27a2d1dabcf65230d7df5f35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e0e94cda21a8176d48fbc702d0e128674a5b9fe27a2d1dabcf65230d7df5f35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e0e94cda21a8176d48fbc702d0e128674a5b9fe27a2d1dabcf65230d7df5f35"
    sha256 cellar: :any_skip_relocation, ventura:        "60adc0565170851478e693626dffd2faf46b551b2734e2d5b9d9471552d9d68a"
    sha256 cellar: :any_skip_relocation, monterey:       "60adc0565170851478e693626dffd2faf46b551b2734e2d5b9d9471552d9d68a"
    sha256 cellar: :any_skip_relocation, big_sur:        "60adc0565170851478e693626dffd2faf46b551b2734e2d5b9d9471552d9d68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "282984f9f757e972e01bb35d9b40728a49c2bb19110738e3031e9761a82d5bc2"
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
