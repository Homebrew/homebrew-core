class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.2.16",
      revision: "b57c92e3e79524daded1596e457b4204c25a4c28"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5be6ea5288b929b2379f8da09fd2d73fc5b3b3b37750584455c2a8ddcb103835"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5be6ea5288b929b2379f8da09fd2d73fc5b3b3b37750584455c2a8ddcb103835"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5be6ea5288b929b2379f8da09fd2d73fc5b3b3b37750584455c2a8ddcb103835"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf62cc53625202965b9738b1fcf672d9c2980bc014cfb0efca94759c9de49bb3"
    sha256 cellar: :any_skip_relocation, ventura:        "bf62cc53625202965b9738b1fcf672d9c2980bc014cfb0efca94759c9de49bb3"
    sha256 cellar: :any_skip_relocation, monterey:       "bf62cc53625202965b9738b1fcf672d9c2980bc014cfb0efca94759c9de49bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb88b979be9f2c57821a7049fc9242b5b1b36e88991400c1f4eb4e14b5c239f"
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
