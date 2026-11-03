class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.181.2.crate"
  sha256 "100afc8897e6bcd33c797824f2c05361c95bd08c2b6b7319d73faa6211dad709"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16f716cc125ea127d17158f08b2aae4e1593dfb4a196b0ed9b75102d6cea6b31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9f9031286c8dea310a36229f60b866def5345504cb5ae25c1e00fba3897a386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "447486c936d7ee7860ac85255b971aad57232f204a56086d4602fbd597ad6c80"
    sha256 cellar: :any,                 arm64_linux:       "16aa3e03ad82097b51d2d76d5aafdea6ca08f73f7a88e11477908bdaa23e3c9f"
    sha256 cellar: :any,                 x86_64_linux:      "66a682b2160dc66afaf82ab0cc9df5fb92993a71d3d7d937c52bda73ddc33644"
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
