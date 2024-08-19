class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe/archive/refs/tags/8.5.6.tar.gz"
  sha256 "c0cf2133c217f52323c4202f5b22640e2425cd5a7b19a5a39a77e8d046d04735"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68571287b0defe5055e9b947864d7c69dbf5b0de80cf520a1ed123afaf9d4036"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68571287b0defe5055e9b947864d7c69dbf5b0de80cf520a1ed123afaf9d4036"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68571287b0defe5055e9b947864d7c69dbf5b0de80cf520a1ed123afaf9d4036"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a9144b1314e77629e7d3060bad14555da84d93cb0b987329597cfd5b970ea68"
    sha256 cellar: :any_skip_relocation, ventura:        "6a9144b1314e77629e7d3060bad14555da84d93cb0b987329597cfd5b970ea68"
    sha256 cellar: :any_skip_relocation, monterey:       "6a9144b1314e77629e7d3060bad14555da84d93cb0b987329597cfd5b970ea68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcfedbb3404b8fbf87b710908156bae77cbb8a7cdc217b3c7e833fb1e6b40f4b"
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
