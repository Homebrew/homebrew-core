class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.5.0",
      revision: "c395761df6afe1a69e476bc60a013a94bcbc153f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67d18c35608006abd0c078f9c98da51256ba6b159ed3fea77155bcd69b71ef8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a23690754ffdc36a7420865bedb257e5329ba0b628c87958823b66f7b1a994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c540379921b421b86c879fcd8167eefaae143063ba3898a5abaedb80d7b0cf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "eedcab40b54e6de161675bd1f981715d8934400e2b206a5ee8783e410cad53fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2ce3626e278f23f9c521eba6389cacd79f81b03fc39364fea07b92d6db608dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3279aec0409aff3b2868d943fc8e9a88c201f328c29aa69b0f4d20673359155e"
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
