class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://tealdeer-rs.github.io/tealdeer/"
  url "https://github.com/tealdeer-rs/tealdeer/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "78e7dbfcc2c8975c143a9746b073a3af875cdee72819bc383fbd411bae2c553c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tealdeer-rs/tealdeer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0484a48458699481e077219fe8853741375707358bbc48f03db3c7847cfa0294"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa27939498be34ee09fcfb9e82faf022df9bdf5cd8a27ccb79e8ed484ba60895"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58947a0d7b708b657b51b59319e95b05350eb7ea43697ca1e8ae6ff09d3eeb87"
    sha256 cellar: :any,                 arm64_linux:       "53d756ef58fdc2997046a183c76dd4ea188899ea36ffbce9b381ad101295b864"
    sha256 cellar: :any,                 x86_64_linux:      "1ad9546e9ec87d7353b4c499e14d69caf50f6a998eefb1ab84da985f4e8b9c7f"
  end

  depends_on "rust" => :build

  conflicts_with "tlrc", because: "both install `tldr` binaries"

  # `test do` block downloads the tldr pages cache
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "completion/bash_tealdeer" => "tldr"
    zsh_completion.install "completion/zsh_tealdeer" => "_tldr"
    fish_completion.install "completion/fish_tealdeer" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
