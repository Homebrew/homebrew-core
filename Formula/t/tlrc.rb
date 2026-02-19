class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://tldr.sh/tlrc/"
  url "https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "402942f1bc37301da9dd1870294d7edd8e81989a178c6439cfbd866d9a9bf67a"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09c51b3ef2e33c87d899f0480a720bb4224f65329a091370344b984d42f48eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f82f86ffb0b23c55d52ee4345d70d1d47cf089ae79232f77e1539a4913014795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0612abdd2e4e06c1267c2dd0f1d9e15db481245bb4a24bad18609c7e5c55bea7"
    sha256 cellar: :any_skip_relocation, sonoma:        "202da0505b809d8acd1000455f1ae63ccdcb589a5ec8b416f7c34c5a2b46a505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38d841e720d52704ac843b20260fb9e5ab5ee89f57e4cde8b6aea4172be3e835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7ce495afb5e5f4e97c9393d46f6b6a09e716626f2352729840a0c055db562e0"
  end

  depends_on "rust" => :build

  conflicts_with "tealdeer", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "tldr.1"

    bash_completion.install "completions/tldr.bash" => "tldr"
    zsh_completion.install "completions/_tldr"
    fish_completion.install "completions/tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
