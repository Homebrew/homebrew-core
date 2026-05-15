class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.92.tar.gz"
  sha256 "53d37cefdc24f1055139a208b66ff341b1851b5fe9feb586f2cd2f351692ca70"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc8095bcc4cf1a58b8f7980497b29f765ad5e05d76a4b14954a146568ca457c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1cf06248d24f41850e62cd9f3d817a1cde16daee45529c4ceffec98c24728cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf7a46c84bc6f8427ebe0536ce6d4d7aa8e86f1b0a51b6cbe5c1cdf22a307ca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "849e1bd16675319946008f63852e33b68764a463f63f8e1a7bd6807774e9e7a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa9e243f95d3ff1691e1103bf3cb6efaa2fed2f0c2d53d8f4296ba7b3adb4b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b5827119587b6d8ef3a7e47bed41dcc601ff22745cae7a968797ec7de5ac5e"
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
