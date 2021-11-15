class Renameutils < Formula
  desc "Tools for file renaming"
  homepage "https://www.nongnu.org/renameutils/"
  url "https://download.savannah.gnu.org/releases/renameutils/renameutils-0.12.0.tar.gz"
  sha256 "cbd2f002027ccf5a923135c3f529c6d17fabbca7d85506a394ca37694a9eb4a3"
  revision 3

  livecheck do
    url "https://download.savannah.gnu.org/releases/renameutils/"
    regex(/href=.*?renameutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, monterey:     "93a4fb65fd3bba13cd797f0c374981b8dde01ee25a0b0637f6e4448b655457e4"
    sha256 cellar: :any, big_sur:      "503b84eed8791b4a924e61fdfb0ea53cb6d349fe8a55c43ab7582c1e2a0985ba"
    sha256 cellar: :any, catalina:     "2ec48c66fea9f53acf2b2ba3b726e6f7a9ff35778a3fb574fc59e7c6d01f681a"
    sha256 cellar: :any, mojave:       "4f360267cba9842ef85e9cfbb1baaf73e9576dccfb924aade7f0ad6bbf0bf605"
    sha256 cellar: :any, high_sierra:  "d25dc64bcc5d30e7695c65a93f7285849b57fdbdb18bf7d5e7bc22f0786cb14c"
    sha256               x86_64_linux: "1a7ddae9fa3352ec89e73c91eaabedc5e941e3e752fdf5afda5b5098fb65cd7c"
  end

  depends_on "coreutils"
  depends_on "readline" # Use instead of system libedit

  conflicts_with "ipmiutil", because: "both install `icmd` binaries"

  # Use the GNU versions of certain system utilities. See:
  # https://trac.macports.org/ticket/24525
  # Patches rewritten at version 0.12.0 to handle file changes.
  # The fourth patch is new and fixes a Makefile syntax error that causes
  # make install to fail.  Reported upstream via email and fixed in HEAD.
  # Remove patch #4 at version > 0.12.0.  The first three should persist.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/renameutils/0.12.0.patch"
    sha256 "ed964edbaf388db40a787ffd5ca34d525b24c23d3589c68dc9aedd8b45160cd9"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-packager=Homebrew"
    system "make"
    ENV.deparallelize # parallel install fails
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello World!"
    pipe_output("#{bin}/icp test.txt", ".2\n")
    assert_equal File.read("test.txt"), File.read("test.txt.2")
  end
end
