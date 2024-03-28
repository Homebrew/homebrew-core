class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.4.5",
      revision: "d59142bd6505c132540c14798cde09f96d0444a6"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub. Upstream may not mark all unstable releases as
  # "pre-release", so we have to use the `GithubReleases` strategy until the
  # "latest" release is always a stable version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68636b0f0ebf4bbb0d0a5c163be3f5f6f3ca44d7ce8153dd901217243833f6fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68636b0f0ebf4bbb0d0a5c163be3f5f6f3ca44d7ce8153dd901217243833f6fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68636b0f0ebf4bbb0d0a5c163be3f5f6f3ca44d7ce8153dd901217243833f6fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "f89087f711dd6047dd3c41d06872c84f3470d036d60034a73caad60be0de0135"
    sha256 cellar: :any_skip_relocation, ventura:        "f89087f711dd6047dd3c41d06872c84f3470d036d60034a73caad60be0de0135"
    sha256 cellar: :any_skip_relocation, monterey:       "f89087f711dd6047dd3c41d06872c84f3470d036d60034a73caad60be0de0135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a49443f3a39e4df8e8c2c2da876ad5c6b0b4780da182f5b1108105087c2869ea"
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
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags:)

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
