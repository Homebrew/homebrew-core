class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.4.0",
      revision: "80ee3ecfedf8b19ab8991713a9fdb2e7dcd7262e"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2981be637900f3fda110a669805b1f0ce5860fabe1137ce5db64a615df51b3b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "098af34d7a9cb03717cd1a09ea36a27e32f530ca42d0412439d0d38eb12b8e2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df92a13ab3fc9674a8aeec99475568b5d36c2708c1860ac41272248b906747d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "49c787ddb6507aaf3211e1b4b1226df37446b0f3d7eefde86b571777e17e3eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6473855d91617f3d1290bc2545186ad2b3929bb081afb76dfca1ced080a80f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9f23e1989c85a62f28a89f884496b6fb9792c42b740ea530b1370a3bda44dd"
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
    system "go", "build", *std_go_args(ldflags:)
    system "make", "generate-docs"
    doc.install "docs/checks.md"

    generate_completions_from_executable(bin/"scorecard", shell_parameter_format: :cobra)
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1")
    expected_output = "repo unreachable: GET https://api.github.com/repos/kubernetes/kubernetes"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version")
  end
end
