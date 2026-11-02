class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.181.0.crate"
  sha256 "8e02af04cb09661e28733b81541041a639ce70af5a08d30400cbc3c5c0b5f39d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1eb7ffb13c903d6bcf47c05f4597e2cb98a1f8eb20e4573ccc5650edc997e82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb866d75d8b1b192c4088cb52d9440bd31a7a47be70c1d6423102efe1a8cec71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d0a6d711b6fb7b1fab678972219ec8e54cd2d9e03a1a85146c3c57deee3cb1d"
    sha256 cellar: :any,                 arm64_linux:       "863679a986d5bec2a965cd06805776083a9cb08f0e03d19e6f04a18cecd3a6ea"
    sha256 cellar: :any,                 x86_64_linux:      "fca52e9b4d2e976e4f666dc9906eb29d9dbc23848a81ee4dd333ccf798e0b334"
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
