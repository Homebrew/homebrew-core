class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "9d3f0dd0a82cdc4cb3cd69149ad0967291b1bafb751bb07bc9c92db00af613a9"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("checks/main") { system "go", "run", "main.go" }
    doc.install "checks/checks.md"
  end

  test do
    system "#{bin}/scorecard", "help"

    output = shell_output(
      "GITHUB_AUTH_TOKEN=ABCDEFG123 #{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Active 2>&1",
      1,
    )

    assert_match(/^Starting \[Active\]/, output)
    assert_match("repo cannot be accessed", output)
    assert_match("401 Bad credentials", output)
  end
end
