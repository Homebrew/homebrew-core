class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "e7497572bb039731ce6a1a6c00754f1a998ff2abe56b80901dab2a23db05378f"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1694097c20040259fe33b63e217bd68f7fa374c593f130afb4d021f47a30f46d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eaa6a7dc504ddbfe12b1ab2c1e73623e648e31957bfa12efbbc64dc31f022ff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ca7f52584d49b2caf076ec4957bc78e374aa8fb88d73030b1016e4c160ab2b2"
    sha256 cellar: :any,                 arm64_linux:       "f19c448da68140ef55d38b0b5b2741123e623f51bdf901d9bfc1170dc550c3e9"
    sha256 cellar: :any,                 x86_64_linux:      "2ca29c3306c2ad596ed675be29409a5bbfa26b591aaad4023f9de74d6387f344"
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
