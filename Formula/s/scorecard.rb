class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://scorecard.dev"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.6.0",
      revision: "61e84743356275f6ffca23b1b2f2cb945e19eb96"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "925a122fff00e4c9d9632ca983633a8e9405aecfd698b0e75cb50894faad7871"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c117afb0536e27405e498adf952e922eb981535cb4feffacae80365867422263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92cc86dde01294c7bdd8ba1137c33cf5f1ed862819bbb47add0444cc021cb8bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de23c9d8567206dbd11eba716fae89b70921a029212c4e524169027804feda85"
    sha256 cellar: :any,                 x86_64_linux:      "2ec8fdf3760d75bcce397cde1723118ac9ebd2638ae3e51ebe8d96a5c94dd130"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
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
