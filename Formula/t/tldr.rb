class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "1a2aa8e764846fad1f41a0304e28416f5c38b6d3a3131ad1e85116749aec34ba"
  license "MIT"
  head "https://github.com/tldr-pages/tldr-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "da6e060988186434dccc852f32e1f8869b82257b22fbfa96dd14ab4d219ad863"
    sha256 cellar: :any,                 arm64_sequoia:  "6af1cb13f99042c4bf60228a9365f1578488990549dba76a844909b6033c61c7"
    sha256 cellar: :any,                 arm64_sonoma:   "00d61b3c3ffb5df313b167d915d0f10896f2bfb5b4336f51332f0d7e84e2f6b2"
    sha256 cellar: :any,                 arm64_ventura:  "32223909bb7889f5b22a95b27676700eddf3c2e4a889332ce3f04e70e1faa1cd"
    sha256 cellar: :any,                 arm64_monterey: "87a1252e89172fb34ebb77a20f1224c9941cd9315c5746e4fb930cc01ddb66b3"
    sha256 cellar: :any,                 sonoma:         "86f757f6250dc09efccab23100a8a5b402475c8ae4e3264eebf4563dddf5435b"
    sha256 cellar: :any,                 ventura:        "af00415190134abec3feec158ebc30e3511c43fc07b22dd2d8acf4e669564d0e"
    sha256 cellar: :any,                 monterey:       "65388c830508d2935fc720af7ca9851dfe8a0a08000644f513b26e61098450de"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ebe1e16b5e69d08b0cf773f4a681d1f28cef6b0cab984d41ceef64d9cf68721d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e92ca409631c8006533f00706aeb966dcd6d7ee175b51c8aceeab523ebb3f5"
  end

  deprecate! date: "2024-10-24", because: :unmaintained, replacement_formula: "tlrc"
  disable! date: "2025-10-24", because: :unmaintained, replacement_formula: "tlrc"

  depends_on "pkgconf" => :build
  depends_on "libzip"

  uses_from_macos "curl"

  conflicts_with "tlrc", because: "both install `tldr` binaries"
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
