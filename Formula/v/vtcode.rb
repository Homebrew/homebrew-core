class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.181.3.crate"
  sha256 "c5452b1d0dc8aebb6b0f591e52935a481c67d6cf0bb04ffe6d76e33be029ecb7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4bf43c596c5305d9afcce5fa95a25531fbc2445d7916892eb45cda79273a0cc6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "247ffc70e2efa96f98d0f9385982483ca87b8fd193f0c8b954cf7812ac0c4e47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3600a49fd6f982388961b61c2215d6a0b5a89b792fb60040ff3841e69f547222"
    sha256 cellar: :any,                 arm64_linux:       "837143116f94fcd0b74b7af29a2556191a67438a9b13db847cb0c72518624b23"
    sha256 cellar: :any,                 x86_64_linux:      "a07c52594354ad3edc41b4c5eb0bd1ddca2b9c26e26860d338f80fc0f3b5f7d3"
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
