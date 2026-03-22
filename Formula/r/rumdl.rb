class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.57.tar.gz"
  sha256 "56972374fdccc19c4c93b153d7527015016301b29dc48c46dbffc02a2acac748"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe3ce3f6643003066c0c801d52347919729d3bc182fa8d6d3551456c56364e14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34134622440f26830b27ac70c7650b2339923941ed329a78448ea326d317078a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "072564bf5fe11c646ad3361bd202a4b5b61339822b3397e9ae5ece8a78aaa997"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc227381e188c3a51b340f854e029a738a47edfe89e53ac209c4c6d3d054bdc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f6ec578f000c2c0d8462722edc1721e57247437c32e000970544d109370f9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "919c5aecb00c61787c772d44ad75a83c6a17b93ca8b06e4a941c53a1e1ecf47d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
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
