class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.183.1.crate"
  sha256 "7701a85a00bb8696e454d873cb3c609c9df853ba533c3c76c086bf4c2a61f077"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1912c2e46b11d89e537c995cc7216b41225708d2821bbfb8f4aa638c7077957f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22ffbc5deabc04bd1ffa0b532a4ede01fd11fa2e45fbf38814065ca3cbb96285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0877789d28c5b3ebbe62cea845e0169b1945252fac399b03c5bec27df05bf1e4"
    sha256 cellar: :any,                 arm64_linux:       "bc6adb778993ff2db7571f867b287d5273a5a599def07a78b2056ba38c51ea6c"
    sha256 cellar: :any,                 x86_64_linux:      "5fff30a8b61180dda13cdd452566787b8654c30578cfdcb1f7ac84b5763ed5e8"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
