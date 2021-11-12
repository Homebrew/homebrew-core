class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/v1.4.1.tar.gz"
  sha256 "e0b905db0aceb26046721ba0d755612577ff80f5b19af3376947f1bf82bae89f"
  license "MIT"
  head "https://github.com/tldr-pages/tldr-c-client.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a2aeb8a5b9969a0b613c343a8fdc89265d4810c7484a1de34b94cfe57baac287"
    sha256 cellar: :any,                 arm64_big_sur:  "cee86fdf29b1674a695eb18b8555e9179f9babe2af20a46962571c1a6fd14be9"
    sha256 cellar: :any,                 monterey:       "9c8b9b3a64ac90fb227fa1acabec1968c6bcf9933f58e58c0b998ad238a0c871"
    sha256 cellar: :any,                 big_sur:        "24c35eb041c4a9d5f7a413d5ba4cb1f964adbcedd0155af40096c191fbcf1c26"
    sha256 cellar: :any,                 catalina:       "212ca0f1eccd82850e0bd9ff7ad0260d59ab8bab815c6e4934403cc94ebd43a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b5d29e3ea8ea279e5506d586e023086996b9679d33ef1c3f97add47f31b41e"
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
