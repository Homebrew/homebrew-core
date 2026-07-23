class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.41.tar.gz"
  sha256 "b550d09990385f52096dbc06932662046745ecb191e5e7dd47a058aeaf627718"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fe84eb29c62a4213a8fd5dbda50c7125d81db4c468d1d81a6c8250427675b21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5564cbccdd6c0dd659dc9b905f092c3d8c77a9a9b1f5ca3f869f85eaf92e640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "979f9ae81e6ca3ba8ab3eb7e4f4593a4ff9bfe3d1da853e35c1caa73f9bce9b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a8ce3c7e11d0e57890797e3d652edf057b5c65748d7a1592260eeec4361ed86"
    sha256 cellar: :any,                 arm64_linux:   "b13b58573ccc2b39e8d64d9f211e0341c32c8dcecdaefb6dba3bf0fd5dea59a3"
    sha256 cellar: :any,                 x86_64_linux:  "7d28f361869b8fcdb9d80a74cd76973051dc3e6a994fdd12e98ae1f5d3df1efa"
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
