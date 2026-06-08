class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://tldr.sh/tlrc/"
  url "https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "4b85b85c0299ae2ae6b78d2d52b2e597e1441da24b579034780663e33ccc85fc"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "817821d692c22c56152930f68b0d1d21074b2ef5a483a61f9b1c9ea1f82a504a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "326c5b867a5ddb95542c027128558aa17859ade4c3eb45e91a23397fc6148e51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19a7df2192a82b99e1fb1f4cde8b4878591b16b97f2cec45b6341ca628e3ef74"
    sha256 cellar: :any_skip_relocation, sonoma:        "71c47e4666ca9ae1f9c848517442aad0650a76891efd2440bdfbf054fb91437b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a9edb03f544efe51691e642f578f28bb902380a56947cf5c2cd6b95f47925bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e33779e12019a251c1d90a2bdc71e3aef3b9ca81d0c09f4240b8d6ec49e76b6"
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
