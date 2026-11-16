class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v7.4.0.tar.gz"
  sha256 "8c187d439cad6499a0b09e586a7d654136bbce5a76f0348dcc906762697fdef9"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "157a9b805b40f078c5c7967e209a4559b2e02db020465643879bfdef1715a7cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "778995e6341615a22e78ed02e56f9f0e6df3ebd77be577e4238c5a82abd0c176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da12a211bc2313ed35bce3e42658be8c74c8bae7f656b5625d5ea7bbd45be4d3"
    sha256 cellar: :any,                 arm64_linux:       "b196a05d4d666050424e81822d38682fa1ad0b1d4ab0a35f084e018a832c2499"
    sha256 cellar: :any,                 x86_64_linux:      "4bb0bbc9dd34477b5ed0e6440ed1f4e6d27e3c87829f609c5665515ff55fe455"
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
