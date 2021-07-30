class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "10ad1aafba9db7bfe26e0a77f534d6175ba85f8d9d6d30dd2c4f50b0a5692dad"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2be95fb6123f3030597290eca51adfef9aac4c9fe9475c8762334fc2126ead1e"
    sha256 cellar: :any_skip_relocation, big_sur:       "fdeae02a92cb740341d4b9e28fe037c80f66b66b48d37c40ef2c261606ac7e31"
    sha256 cellar: :any_skip_relocation, catalina:      "bdaf2b3695feb573360dc50193f48b7e8399e2e89eb145a2312a731de1b953d4"
    sha256 cellar: :any_skip_relocation, mojave:        "80c11460a03d2d35b6a87e6e684908cd76cb446cce5268c2b0b5d77a84f499fe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("checks/main") { system "go", "run", "main.go" }
    doc.install "checks/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Active 2>&1", 1)
    assert_match "GET https://api.github.com/repos/kubernetes/kubernetes: 401 Bad credentials", output
  end
end
