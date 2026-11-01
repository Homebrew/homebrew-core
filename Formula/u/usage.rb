class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v7.1.5.tar.gz"
  sha256 "2209c229d19d5429afa5fb0dc5ef73f12d31981620adaa32942320c17bd7b40f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d3c6c4757163e6abcb99d83e53d71711c2d0c71dd526ce191f76a95ff0c8683"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e24cd6d5e673325c17abdd07bb97c5d513920ce5649ec77fc10cd5a7f07338e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfa554ae3e1e5d2fd0ac7db50863eb5cf951e587565a25621633e399c9bb9e9d"
    sha256 cellar: :any,                 arm64_linux:       "477c7a4fe385c3b8ec51ee6b4f2d4b4a444ddd8c8c93e015f75705bc25fb69ab"
    sha256 cellar: :any,                 x86_64_linux:      "6c65ae76e2ccb3d17e72b61629d922a4bf28f8cd50566278f2b1d8cc6308f041"
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
