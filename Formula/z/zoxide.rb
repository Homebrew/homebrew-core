class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "1b276edbf328aafc86afe1ebce41f45ccba3a3125412e89c8c5d8e825b0c7407"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1467f17fb6fc40689476e7a23c899ce2d7d1973ef3185befbd23bf700cbbc33b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cea8e6116f5dcc487213bc9f1013447ba766967294c091f479858969764ebfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414ab1396110a83c89418c22c1b818be4e63e129b9cb62417684af9ee67af857"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e9391352600b9256d830f483a689290bdb037cebb883e9f04c8f1790a8ae8ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "26b19beed6f0572caef1415bdc74f295410526de07b1f95c345e5a441b26a1ba"
    sha256 cellar: :any_skip_relocation, ventura:       "dc21a28b1f3959472ffdc6bf60cde72bb1625ab95de744175901d908a98500cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54f58a6f4e999a643d6b47619906fec2b2aa1b79b98ecaf22d3e70b0128da1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37e73f85f229d6e7b83cd61700e4254ef6773c5e6d36f4f69e9535fad5bd0b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
    share.install "man"
  end

  test do
    assert_empty shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
