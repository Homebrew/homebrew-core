class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.182.7.crate"
  sha256 "ff0dc7c4aa5a326bd3b0e1a7def7a655ec4d96ff00bcc0264b472ec51323ba43"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a7aa905038bace754f0b57f3fe1be45e4042ac4e72fd677b33129edfb107a75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c6f5ea275ca11f24302c6a26e8c7eadcef541a9ff3ca5e63a169de94d9512b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0f806b94aa3502fc4f2335d64e5321d779cf299a15f33ae239a18f0e6bdac2e"
    sha256 cellar: :any,                 arm64_linux:       "5586ee5b959ba3c8600881818ce3df3ec8df15e41fd4e7326c88d528e61e29f1"
    sha256 cellar: :any,                 x86_64_linux:      "df292d96460e21b7ab456d0e87d98bd5154ac553268c93988d4175d7e3d55bf9"
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
