class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.43.tar.gz"
  sha256 "dbfdc5d23756d9b67f328a676aa21b2828f895b7c8aa4c230a5790e58ba73828"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edd8b28301f278e009ae9981956b458f65862c5ab1063a14bea2904cb5c2e2e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676ac07df6ccf0fe614a22f85d0dfaa74488af48c5c933f531748668adb76eed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efd799f95e98ca1656d6b71adbbb4633c46f3a9d1bfccf9e4d1fe45cf076f0e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bfc57f936443e461c522807e9c7fef90bd91ba67d87adfdb5370c87c471f584"
    sha256 cellar: :any,                 arm64_linux:   "fd14f15d22831736a9b90c39402b2cb757730102e8db0529d399cedaab5bf000"
    sha256 cellar: :any,                 x86_64_linux:  "361aa1d01407906a4938d23af4cf86ee54de2269ddb1d99778eaf6e2ddf6fc8b"
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
