class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.3.4",
      revision: "1dd666fb236c086131c264a10c522fe946631784"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4f58dd812d9cc74cc9bcf63defe280c43321356b8bbeec87d7ff921fd58dabe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4f58dd812d9cc74cc9bcf63defe280c43321356b8bbeec87d7ff921fd58dabe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4f58dd812d9cc74cc9bcf63defe280c43321356b8bbeec87d7ff921fd58dabe"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d724f4b635e22b4ae47dab880cf2c408d22a8c37e257c946b0f991e1cb0ed54"
    sha256 cellar: :any_skip_relocation, ventura:        "3d724f4b635e22b4ae47dab880cf2c408d22a8c37e257c946b0f991e1cb0ed54"
    sha256 cellar: :any_skip_relocation, monterey:       "3d724f4b635e22b4ae47dab880cf2c408d22a8c37e257c946b0f991e1cb0ed54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b24959b4be76313132c126e3389524d4f42a5d753c1a5d366595a3f5911f50b"
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
