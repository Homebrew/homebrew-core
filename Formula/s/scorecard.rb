class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.13.0",
      revision: "e1d3abc7fd2bdfe8819ac19b5c82815ea20890e6"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "262334c18194ac5ad038b4e837f302f52cee07e539e76de5b9283f6da55cb09b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8840ceb2da14f1dd019e8c3ace500c81537270ba4e48a642ba3f0c358ec353e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75e799e33a7a614e3bda3270bb98f79be9e67b69336528dfce6ce9a41825d00f"
    sha256 cellar: :any_skip_relocation, sonoma:         "40a620263857a30b5180fd8d66c74ffc47d4e1872f108e7d638d009c3f6a2397"
    sha256 cellar: :any_skip_relocation, ventura:        "c17bb4d141ae1f8dd091b49c814266bfe42b1f632b973e85e79500fae6d0ea37"
    sha256 cellar: :any_skip_relocation, monterey:       "cfea6b7777aeedbcf2b77fde4ee1b2ea5cd1886b2c699e2ab491a57b68e97f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a5bac55b0ea244367ee396f82ba6e6a2be0ef604592d1324bbad08e3b6a8022"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState=clean
      -X #{pkg}.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "make", "generate-docs"
    doc.install "docs/checks.md"

    generate_completions_from_executable(bin/"scorecard", "completion")
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    expected_output = "Error: RunScorecard: repo unreachable: GET https://api.github.com/repos/kubernetes/kubernetes"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
