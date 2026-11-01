class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v7.1.5.tar.gz"
  sha256 "2209c229d19d5429afa5fb0dc5ef73f12d31981620adaa32942320c17bd7b40f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2bb3cccd8b69ac9d5c1409527418e95c59d6da5363ae5efd7e8ef1328122269a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "294fe2ed529923ca0d23fba998c48f510b8280ca30cd6afceb10e47cea4dacca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8273a4394ab29481c72fe365ab1fef936fdb730c22c581c7c0c572a46bc83d56"
    sha256 cellar: :any,                 arm64_linux:       "67da8a3783566a6325a8192cdd526dddb4f99192d0484ca65bf9d2b0ce14edcc"
    sha256 cellar: :any,                 x86_64_linux:      "ee6d7be79be2b3af980f62c1da8410350f5ed0b4b163b261f513655613f6958f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
