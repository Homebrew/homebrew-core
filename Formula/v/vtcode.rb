class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.185.3.crate"
  sha256 "a467d1026eef4d5bf530bcc5d5c1b36d523076c5f2f0081e398b41c8e8b9a781"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "01b9d4626bf2ddf86c64ecfb168d71e50f0ffaaac1051ae742ac8e8752a037f6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74cf21d91d23e9597e334232901915e05442c71bc5e3a9f435d63b2c4dccbb1a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "806643345abd2c0b37d100d7bafdbc6616cab988d772d32a42b8c7931dc04648"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1499b802aee82510cc7d87ba8cee65d9999876874ebcc34fe758940b6180d809"
    sha256 cellar: :any,                 arm64_linux:       "952be815d3dbf474a7d47b6863750b40fc1886080139c97dfa8449ae361b5559"
    sha256 cellar: :any,                 x86_64_linux:      "6bd7b05ce88aecc83b202e1d7124edbf62c087290a9ac9d916fa80d780ac35d9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
