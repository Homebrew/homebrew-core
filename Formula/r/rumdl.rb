class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.58.tar.gz"
  sha256 "6a48c9371c91ac3041bf32d2c9b1668a7b5fd633a6580e886c76fd91fd50f5a4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "005e4da6ac95ce43342578ba0c64deff885f63d6388f4c674a256193ce29af68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2688f78e90ae30c149f5c6e40cd45e586178482d217199c04e4c3baddae9cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ba65b757858c0054d3fb3af9a1c3f5613babedd3df14e505937f3674d9fda6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6540c1ea3bc2d2893445d3ffac320375cc8f4a14abe7c4a90d966c7327d3d9b8"
    sha256 cellar: :any,                 arm64_linux:   "385a343daed635142bf1223a5091ad478b60775698815f6ac01f2e53eed6f173"
    sha256 cellar: :any,                 x86_64_linux:  "8f2e8e493245832e4c9e4b57b994de62854b1391898c6e9a9ff7779a5ba2fd1b"
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
