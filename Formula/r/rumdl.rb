class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "1fdb1688fe1d23f3dd74e7a6c219c66173affa3de7a2e3ffd6cbdaa5a0c09a6c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5695166e711067692a3adc903ea40004d20dcb3d94e898c8796afcbc356831ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb503ea7f3de453d9f0aadd7cb95b71a5e12cadb58b5da2833b7af476086ff77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e44d2680cf1f0cbd2dbf4ad53572564db17c1608c13efc300545a8d72164ba3"
    sha256 cellar: :any,                 arm64_linux:       "12fc25953725ee68a9f5492d7f968acdc3c82181ea3a0b8e2e8db2766f776958"
    sha256 cellar: :any,                 x86_64_linux:      "40d0c48be148a4f89ef05d3b9e0b1de83c5f7ca19b04368c801d3f03dde41736"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
