class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.181.8.crate"
  sha256 "bb3baf94d966b1007bd69c10b6162cc615ba01aebcee4bac737dccf86b8302cc"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc1056b77b8e4a8acfed37b9e0b7f88c2c3c78ae3a489c0a3a741dbec2fa7e43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9d3ad5449631ed5941bb3bbdb40dab6176bd300b0ee5174c6be111ee793498b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "377f5bf2fddf169adcbe66812f6b774ba5769a47e0ae126481b28034ec3e6130"
    sha256 cellar: :any,                 arm64_linux:       "fbfe7105e42959a97758a0d097fca74e558abe57ffca119ea937735f54f4bcc8"
    sha256 cellar: :any,                 x86_64_linux:      "e54c23d19974c990e22817c2ac7c7f35f20c38caf229652d26460b856d6ff0b8"
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
