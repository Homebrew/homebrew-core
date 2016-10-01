class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.64.tar.gz"
  sha256 "c4bfd3282214a288e8d3e921ae4d52e73e24c4fead72b5446752adee99a7affd"

  head "http://git.savannah.gnu.org/r/quilt.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "34ec3c012f01a9ae624b327abea3f73132c409be577adcf1a0b4cc9ef1f149f0" => :sierra
    sha256 "a7d57c231898a6ca038db9789e8059dc2d4498da2a75eebb7d66837dbdd4bb96" => :el_capitan
    sha256 "a7d57c231898a6ca038db9789e8059dc2d4498da2a75eebb7d66837dbdd4bb96" => :yosemite
  end

  depends_on "gnu-sed"
  depends_on "coreutils"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed",
                          "--without-getopt"
    system "make"
    system "make", "install", "emacsdir=#{elisp}"
  end

  test do
    (testpath/"patches").mkpath
    (testpath/"test.txt").write "Hello, World!"
    system bin/"quilt", "new", "test.patch"
    system bin/"quilt", "add", "test.txt"
    rm "test.txt"
    (testpath/"test.txt").write "Hi!"
    system bin/"quilt", "refresh"
    assert_match(/-Hello, World!/, File.read("patches/test.patch"))
    assert_match(/\+Hi!/, File.read("patches/test.patch"))
  end
end
