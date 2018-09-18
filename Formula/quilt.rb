class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.65.tar.gz"
  sha256 "f6cbc788e5cbbb381a3c6eab5b9efce67c776a8662a7795c7432fd27aa096819"
  head "https://git.savannah.gnu.org/git/quilt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "924f0efd884663cc2ad2b991f51b450518e74f6071a0a722bf2e23b84c4bb108" => :mojave
    sha256 "6905212919229016ef984a2aca56b424da0057ad3404a9cab0290997838bb785" => :high_sierra
    sha256 "8ea83c73d0043e442c32351e84c591a39305abd13745a5968993c43f750c046a" => :sierra
    sha256 "8ea83c73d0043e442c32351e84c591a39305abd13745a5968993c43f750c046a" => :el_capitan
    sha256 "8ea83c73d0043e442c32351e84c591a39305abd13745a5968993c43f750c046a" => :yosemite
  end

  depends_on "coreutils"
  depends_on "gnu-sed"

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
