class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "76bd9b029445daf2a58242f37d0ee19ebb72684aed17c2c3daf6ff6c7beceb02"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34740c89abf335441af5cee302b7acfff2635963c1c1e2c5b2175b08c8c3d655"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d0b704eaccb419e0b3f9e9a21249e062a0a5a54edd013bff69de3a6a7410401"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9677d0af5c9761076b33568fa3536961a009a1bd6ade9cb58cff4da783c06706"
    sha256 cellar: :any,                 arm64_linux:       "1eea8adf8226d2c18e4b740aa44e7ba72c046cc5291dc2e2020859682dd8360b"
    sha256 cellar: :any,                 x86_64_linux:      "c251f16998e0a57393a9f11f64d4de03c039a08931b1c3b961763a95da41ae7f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
