class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/v1.4.2.tar.gz"
  sha256 "532cc30b21ea146d23ba880142ae284bd2774c27c247ecc00221d9434bd9343f"
  license "MIT"
  head "https://github.com/tldr-pages/tldr-c-client.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c0fcc938b223d6a92066cac07ee07a17a159fd42d3feea456559d64b4f508d89"
    sha256 cellar: :any,                 arm64_big_sur:  "4667ddde137d5b3659817f81be5d801775912071fd073ba09f41d3648ab088ec"
    sha256 cellar: :any,                 monterey:       "c4c0985e0df92f83a992b06de3abb519f3f82f756be4e6efc053378435aa835d"
    sha256 cellar: :any,                 big_sur:        "352bfada409f8f2423e91ce47448f08c1bceba72ac87c2800952457e6e4df3ef"
    sha256 cellar: :any,                 catalina:       "74320c7e9fffe0b57532b5fb37883186ea10d585a1d939b3c23f813957b7f871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f9fa882302c99813e436643d82f6a769b601e8c9706fa668b8a272db0447f1f"
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
