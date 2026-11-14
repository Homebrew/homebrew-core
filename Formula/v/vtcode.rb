class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.182.1.crate"
  sha256 "67abfe0556dad7be9d372c1002a148785f8301b79ff822e52e10d546205640a7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ae61e22435665e572fa94b50a7baeab28886afdac9282e10205da7ce7942c26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "251798f35d0a2b63f44a692022a37655f5e52c2b656cea04157959f5d5bff08f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c54ace01fbf9b9bcbd6571c510a9edefc493c734051664d8df51cee4b156556b"
    sha256 cellar: :any,                 arm64_linux:       "c9d8219544eed5092798b719992496f2321d3af9c5bbd2da881fece088f0a376"
    sha256 cellar: :any,                 x86_64_linux:      "cf2f0df0c81d81ae5eb9b94c0d15264f7c97009f42eeb0f6ff4f7f5afb740471"
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
