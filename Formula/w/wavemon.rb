class Wavemon < Formula
  desc "Ncurses-based monitoring application for wireless network devices on Linux"
  homepage "https://github.com/uoaerg/wavemon"
  url "https://github.com/uoaerg/wavemon/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "768d7c580fcc592efcacac924dcfd2ebe131608f5c8ac67d36e35731e1ac683a"
  license all_of: ["GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any, arm64_linux:  "6b1dfbf93c4901a09b94379557ad72d261178a2eece733b6fb751fbbde3f1f82"
    sha256 cellar: :any, x86_64_linux: "293ca56289c6308d9fb7db0d0220385c7f22d9e2720507c19c8988ae302b7d74"
  end

  depends_on "pkgconf" => :build
  depends_on "libnl"
  depends_on :linux
  depends_on "ncurses"

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # homebrew's linux runners don't have wifi kernel module
    assert_match "wavemon: option requires an argument -- 'i'", shell_output("#{bin}/wavemon -i 2>&1", 1)
  end
end
