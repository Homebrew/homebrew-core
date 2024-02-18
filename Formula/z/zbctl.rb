class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.4.3",
      revision: "fb8218fbfbaa85d60e4455d8e7c148145d8e994c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a85f95855991c19bf1946f6149e3b9714c695de136c56d1debc902cfb16f7fc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a85f95855991c19bf1946f6149e3b9714c695de136c56d1debc902cfb16f7fc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85f95855991c19bf1946f6149e3b9714c695de136c56d1debc902cfb16f7fc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cf46ecb5d9f293da6bf5be94013ba1d6042415caf376ad30a247764aee40658"
    sha256 cellar: :any_skip_relocation, ventura:        "7cf46ecb5d9f293da6bf5be94013ba1d6042415caf376ad30a247764aee40658"
    sha256 cellar: :any_skip_relocation, monterey:       "7cf46ecb5d9f293da6bf5be94013ba1d6042415caf376ad30a247764aee40658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff3eb777c2492f68dbd92e703e14c3241aa9c2edcab83fb84ecb1e99b13ae684"
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
