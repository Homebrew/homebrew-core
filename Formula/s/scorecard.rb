class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://scorecard.dev"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.7.0",
      revision: "d7552fb3cdc05e9f6426177d3328887304fce554"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05d9482a837f1e6026b75fb5b849ea05cc9602be17e578a6e509cf7c73147683"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3f8bf84060df953762b65d75f7a68d59c28c26984d60bdfe365a978221896b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2053401d4740fc10ef0249776f4696648e32edecb36382a0b4a63e3fe98e635f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2307e4654a79619ec55ea3691cdf98453cd6a5609bf431a9e69cd5265c512dc5"
    sha256 cellar: :any,                 x86_64_linux:      "7589d61d70d51f946ee22e0f7bda2576c64c865e35c9293e2be7d1d75ca3ff23"
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
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    expected_output = "repo unreachable: GET https://api.github.com/repos/kubernetes/kubernetes"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version")
  end
end
