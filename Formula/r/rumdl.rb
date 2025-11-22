class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.181.tar.gz"
  sha256 "fac25d6adbfaa2a4bd7a1655a104e263f67b13c3a45b2f888e161afba0d038ca"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46250a128446e90043c1952bea971e5b3bc5e0d0becc25c243d47b8e66bc7c2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597e962560b3c4ed0f21aaa8b25e6be738ce68a48064e7a12dadc01b3dda3be5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "652cd1ab1f89d58a105735bee4bfa1546970244035c46c400662e7be44f0cc04"
    sha256 cellar: :any_skip_relocation, sonoma:        "070b86c596474c9088260967395688bf905a61ad50a655ca05a73a9a646aae56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e264ce3a161d73bbb1786bf11c0ccfd319a6ab7f949ada715fb4d603a1d7352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d043af459d8915ad10f4d1c5063119a82426a01c4f247d8511af01e31e0719"
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
