class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe/archive/refs/tags/8.5.3.tar.gz"
  sha256 "5bc14705a8424c4c1da6a70dc1140aaf7636fb79c7569c0d92979448be81eb54"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dd79e6cc1e243ff27cbec84218a9f9c08ed2352899d87e0b70139fe26fac053"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dd79e6cc1e243ff27cbec84218a9f9c08ed2352899d87e0b70139fe26fac053"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd79e6cc1e243ff27cbec84218a9f9c08ed2352899d87e0b70139fe26fac053"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6a2d7b16c318b30382255678f3d896a215b68162e4fe520725ff2da4ef53c8e"
    sha256 cellar: :any_skip_relocation, ventura:        "e6a2d7b16c318b30382255678f3d896a215b68162e4fe520725ff2da4ef53c8e"
    sha256 cellar: :any_skip_relocation, monterey:       "e6a2d7b16c318b30382255678f3d896a215b68162e4fe520725ff2da4ef53c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e5cafa0c93aa642df25cc8839530418f6219c32017c2e0de26afd9295edf8b9"
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
