class Renameutils < Formula
  desc "Tools for file renaming"
  homepage "https://www.nongnu.org/renameutils/"
  url "https://download.savannah.gnu.org/releases/renameutils/renameutils-0.12.0.tar.gz"
  sha256 "cbd2f002027ccf5a923135c3f529c6d17fabbca7d85506a394ca37694a9eb4a3"
  revision 2

  bottle do
    cellar :any
    sha256 "c4828ddd8305c394eb1cba076d8863447dc243191990be37de19acfe6ec1c8c0" => :catalina
    sha256 "9f13f1f0096e9875dfa28466cf6689203c7018a8b38cf32def6567f63fd1d3e0" => :mojave
    sha256 "69dacfc5145602d3310aac38122aa7385956fbfb56c9af97adee0f77c2c01453" => :high_sierra
    sha256 "89d596e819476c80807653aaf8a20f7cef7976f53570e4242d87ccebea4cb92f" => :sierra
  end

  depends_on "coreutils"
  depends_on "readline" # Use instead of system libedit

  conflicts_with "ipmiutil", :because => "both install `icmd` binaries"

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
