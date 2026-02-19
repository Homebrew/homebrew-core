class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "1f1272afa738b83444eb51b7e2cd7eed00f865b1bdf6e02a9c004e52f960ce43"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fed97598a6db174497003d4d19f29caa620944b7df9a48c7dc8346e831d8c9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aec5355961725de186797d566fabb38d22a70350561cea01c7edd05d9ca37f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a109e3a91d27b23961b0e5418065314085abf02c160bd0dd738935e3168946"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4566fda32a3a319754b32d567ebdff51317cbf6c02153e563b1f80a1e2a039d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb30920743cb767834a1f24a84424b6b4760ef62ea5da421b58977760f005c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6d910cb12316e7382baf8b9e17dbce0a85bd10680d4a72a3f16b35b4e71405"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
