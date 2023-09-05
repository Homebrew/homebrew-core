class Renameutils < Formula
  desc "Tools for file renaming"
  homepage "https://www.nongnu.org/renameutils/"
  url "https://download.savannah.gnu.org/releases/renameutils/renameutils-0.12.0.tar.gz"
  sha256 "cbd2f002027ccf5a923135c3f529c6d17fabbca7d85506a394ca37694a9eb4a3"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://download.savannah.gnu.org/releases/renameutils/"
    regex(/href=.*?renameutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "38109c05cfb9f8fcca3aeff270ad845937c1dd8677a74ea7fec3d717a3c722c9"
    sha256 cellar: :any, arm64_monterey: "a6570746ef47eed43cbde686b8ebf162559a9ada031bab821064c5e0754135a8"
    sha256 cellar: :any, arm64_big_sur:  "0ea05fad50a7a43df09d3bbb652140e5037e91320ff9e549a9ad0cf41dfaa958"
    sha256 cellar: :any, ventura:        "75072c6cbce5f3a83176da9790df986e4d4dea99c6fc7c52f4b8d942c31c1026"
    sha256 cellar: :any, monterey:       "93a4fb65fd3bba13cd797f0c374981b8dde01ee25a0b0637f6e4448b655457e4"
    sha256 cellar: :any, big_sur:        "503b84eed8791b4a924e61fdfb0ea53cb6d349fe8a55c43ab7582c1e2a0985ba"
    sha256 cellar: :any, catalina:       "2ec48c66fea9f53acf2b2ba3b726e6f7a9ff35778a3fb574fc59e7c6d01f681a"
    sha256 cellar: :any, mojave:         "4f360267cba9842ef85e9cfbb1baaf73e9576dccfb924aade7f0ad6bbf0bf605"
    sha256 cellar: :any, high_sierra:    "d25dc64bcc5d30e7695c65a93f7285849b57fdbdb18bf7d5e7bc22f0786cb14c"
    sha256               x86_64_linux:   "1a7ddae9fa3352ec89e73c91eaabedc5e941e3e752fdf5afda5b5098fb65cd7c"
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
    # Work around build failure on Apple Silicon due to trying to use deprecated stat64.
    # io-utils.c:93:19: error: variable has incomplete type 'struct stat64'
    ENV["ac_cv_func_lstat64"] = "no" if Hardware::CPU.arm?
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
