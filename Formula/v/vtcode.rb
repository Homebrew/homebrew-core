class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.182.3.crate"
  sha256 "35ed586656a408ae96087a1bec5f84f97e0310c98a7dcea2835053c2e0fb5867"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aff098f4e7f2314b95caa4cfc3836e848e51ccfafc198697cc611aa8a1ee2588"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6f43cbb63ef438ac63aa1f181b6018b3fdf3abca439c3777d8ce2d697156053"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72dff2d679f419581a56b964686d16f0a4d8f17b3aecba120446b8dba4ae1948"
    sha256 cellar: :any,                 arm64_linux:       "e3156e72138bd25c834be41dab997c892670a6a5e79a60549f68ae94628844af"
    sha256 cellar: :any,                 x86_64_linux:      "544523bf6895a4a3194a4c53ee8c27172aca7f7cf78cb65126cc14abac0e83fd"
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
