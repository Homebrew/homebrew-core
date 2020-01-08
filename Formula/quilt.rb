class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.66.tar.gz"
  sha256 "314b319a6feb13bf9d0f9ffa7ce6683b06919e734a41275087ea457cc9dc6e07"
  head "https://git.savannah.gnu.org/git/quilt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7304ce0125f31f6d38f8645d436de553f765b599e4c66f8f659478963bf33f6" => :catalina
    sha256 "5d7f412108ec8831b8b6bfbc8e41d8b577523ffd66f9d095853a4680ec23b04f" => :mojave
    sha256 "691a01a091194910f0848aea529b331559fb98d44e9821c1ebafba51d2a2d62c" => :high_sierra
    sha256 "2305addd5b8f4b256701b2ec89ec9caffa4699dae48e63f8cac0478545b5d860" => :sierra
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
