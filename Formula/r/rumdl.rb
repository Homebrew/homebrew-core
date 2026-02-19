class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.23.tar.gz"
  sha256 "3e83a54a7f229450c89188c458c1927c28d742b0f2e16636053f0aec8de98948"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e8c24082f3e5f7fab8e3799c52feca2b56d715f248b42c74b0d346e91b2bfea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06bcd1e2ea2c1c602b721a50fdb06902c7e28be79958d78b6e1b90c620f4962c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "852887fe77cd815f3285cff612a8c6ea12c977c15f6a51776b522c14b4a84da7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b71c58e8a686cef75cc45aca696a25bb4bc006833f62bf080a385599862e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7e16af3feb26aa07a47a89c0caa0f92d98df956af94e8cf241b2b0c1410bbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fe0248283a05e40889257ec30f70c135389aabd58a40c29c150a535903c1163"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
