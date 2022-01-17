class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/v4.0.1.tar.gz"
  sha256 "8545d4aacaa2ffafbf545aeee7bccc381d2c00ffa0e4e9cb65190e68ece543d6"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91f2fa9b459481c006b8c8513f62475f567d3525dd323336485dcaa8287221d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "394acdf7d3555b84886836112b94b612812282bb2b2dffb074cb382638d17a74"
    sha256 cellar: :any_skip_relocation, monterey:       "12bee6c93cfc80bb39c505f69d6d1cbbde130033573aa070376cfb22e55f7977"
    sha256 cellar: :any_skip_relocation, big_sur:        "00ec61c9f2c229e600e49b716da6fa5360b5188e85f004a0e471bb6e388f8f98"
    sha256 cellar: :any_skip_relocation, catalina:       "3269a07c027b141c90dbd09d30e8a9a1f5e00e26aaf55c6bfb6725b244324c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9712402c95978a522d5d3444c5466733e0f0aa3c62878ec928babbbeb689a6fe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("docs/checks/internal/generate") { system "go", "run", "main.go", "../../checks.md" }
    doc.install "docs/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 2)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output
  end
end
