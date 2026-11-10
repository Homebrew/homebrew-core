class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.181.10.crate"
  sha256 "ac45a08c8d25e7b0e34915f39b78e3f0894720632d21e3972f89e33d0ed7190a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17388cf154fadced7bd53298d75b48c346a497edae3c3f364ead751b89c11d2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70a8f31c13bc9129d90e939db64409bc521aede92239307f9fc4d8159c4a37f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f048dbe6e4fcb2d234682a11bebeb68a6506150fc78e10917d7565c3d7eb661a"
    sha256 cellar: :any,                 arm64_linux:       "a8f733c9c61ea4c2861a7da8e1656e9d097cccb36927b6f50c097c897b94b869"
    sha256 cellar: :any,                 x86_64_linux:      "a81f98bdc76a1c7af9bb2433fc6d9341fd44f5c10e633f874bb026a4d204a06c"
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
