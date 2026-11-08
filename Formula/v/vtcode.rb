class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.181.6.crate"
  sha256 "061dd6493e7d70f3db8372879c3a57109cbef878feab75c7b7c752197f2f0a19"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52e8335db01f904c9b7421164c4fa381d1a9ac093109f418880ddea56eaf535b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c834bf73cdecc27e44a329543c26aae2b9c5b4538e2d7073dc05b350fb7697f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69171bfcce4fe79f08fedf2e1924237c7aa0d579ae925d8eb4a3e8ac4704f89d"
    sha256 cellar: :any,                 arm64_linux:       "7301929faf18912462c98b009413367cb46c33e43a3598a18e101895ba904eba"
    sha256 cellar: :any,                 x86_64_linux:      "95ebce9d5fffb3badc19a8d0e661d4a6e04329085baf73c807f102492fc71dd2"
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
