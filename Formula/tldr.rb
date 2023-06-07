class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/v1.6.0.tar.gz"
  sha256 "2cd16cd956d15b1d33d7a5e2a2566500ab5766d2fa1b9ee7e49e64acc0352785"
  license "MIT"
  head "https://github.com/tldr-pages/tldr-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6403ccd9be45f800e8b3068b35aa93ab33cea03f60990257d955015dbbced536"
    sha256 cellar: :any,                 arm64_monterey: "d8ae9baacf4db01a286f57b11e7ae144eab6b3c94bf7cde29b4ceade55614f88"
    sha256 cellar: :any,                 arm64_big_sur:  "e631d264c50eddb5c4e2d998d85c783b6f023ea50a854e17ebe14c42bc9f54b8"
    sha256 cellar: :any,                 ventura:        "c10fa005911f6490ffc52c0e1c732c6f2d02c7acd2aecac7f69c7bae19dbe3fd"
    sha256 cellar: :any,                 monterey:       "3bf02d8355d6087bbeeeabdba2a96dc70eb0e862db46002673f7579f97f73af4"
    sha256 cellar: :any,                 big_sur:        "a8e870d5413d1baa4a93cdbc044d1e84815c0aa6e2518957ff0ea1825a3f64db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e171e983894fa7c3fd7ab9170a87648513bea3cfbdd1bcc3c4d1779bae9a8db"
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"

  uses_from_macos "curl"

  conflicts_with "tealdeer", because: "both install `tldr` binaries"

  def install
    system "make", "PREFIX=#{prefix}", "install"

    bash_completion.install "autocomplete/complete.bash" => "tldr"
    zsh_completion.install "autocomplete/complete.zsh" => "_tldr"
    fish_completion.install "autocomplete/complete.fish" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
