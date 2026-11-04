class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v7.2.0.tar.gz"
  sha256 "0e4ca6705f01cd22289b115557bdb972d01aa970de3ed0e7fbb058f843301db9"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81685e2c337ec426829e2bbed513c872fc00568b80bbe47857c310a129c12551"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68a83a2fa33383ac4ab62d3b4923425e5cd53cbc8c57946afef65fba8c27e506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae05f2da18b4882ee94cddd54a23b5fb6de0ca2a74a70bf0f374e99f716178a6"
    sha256 cellar: :any,                 arm64_linux:       "cc207faa34581ecfac742a34f9ca3e209d6d9c5cb2723d4fb9b3baa05a4fce4f"
    sha256 cellar: :any,                 x86_64_linux:      "4bc7c20eb59c45fd99e310bab3b4e4895fc15e70c92e134ef09f09822265da0e"
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
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -- --f").chomp
  end
end
