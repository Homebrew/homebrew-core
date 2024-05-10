class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe/archive/refs/tags/8.5.1.tar.gz"
  sha256 "05fa5d7830004c39e00cf2ff0db85e95ac4aedc2e5a9444450491dffdb6270cb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b5232e7dc609791546f8078f249f30b97805059496f2431786bf0e336713e31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b5232e7dc609791546f8078f249f30b97805059496f2431786bf0e336713e31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b5232e7dc609791546f8078f249f30b97805059496f2431786bf0e336713e31"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6a13c0ddd2b322e067c8822068a7e7327caac9fd3c1e9c476b67ba7ae369c17"
    sha256 cellar: :any_skip_relocation, ventura:        "c6a13c0ddd2b322e067c8822068a7e7327caac9fd3c1e9c476b67ba7ae369c17"
    sha256 cellar: :any_skip_relocation, monterey:       "c6a13c0ddd2b322e067c8822068a7e7327caac9fd3c1e9c476b67ba7ae369c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bcd26e7e0c19b21ad5a04cb4e2080aa13d55efc78b55cc4a3e331cca26ba2d5"
  end

  depends_on "go" => :build

  def install
    cd "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/v8/cmd/zbctl/internal/commands"
      ldflags = "-s -w -X #{project}.Version=#{version} -X #{project}.Commit=#{tap.user}"
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

    assert_match version.to_s, shell_output("#{bin}/zbctl version")
  end
end
