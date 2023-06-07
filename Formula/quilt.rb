class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.67.tar.gz"
  sha256 "3be3be0987e72a6c364678bb827e3e1fcc10322b56bc5f02b576698f55013cc2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.savannah.gnu.org/git/quilt.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/quilt/"
    regex(/href=.*?quilt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dc018071ad510cf518a434ab4111cbe7c9818ce7e128cb0db45c9b070f28999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc016251e7f6e00724b265762408f2f71c3414690f8c7e3e9b680af3f78240ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a0dd81f8d4dadfd624bd4cdaf6521e7530c722938856ed515b25ee43d48c70b"
    sha256 cellar: :any_skip_relocation, ventura:        "7dc018071ad510cf518a434ab4111cbe7c9818ce7e128cb0db45c9b070f28999"
    sha256 cellar: :any_skip_relocation, monterey:       "fc016251e7f6e00724b265762408f2f71c3414690f8c7e3e9b680af3f78240ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a0dd81f8d4dadfd624bd4cdaf6521e7530c722938856ed515b25ee43d48c70b"
    sha256 cellar: :any_skip_relocation, catalina:       "d8bd4472f644e650e62b719bbae716c2f2c40c159dd6155e2d6fe74cbb02448e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a674930a170db7d564dea2f5a6cfa90efbb59dbf3d6d801f7554c6306a5905c8"
  end

  depends_on "coreutils"
  depends_on "gnu-sed"

  on_ventura :or_newer do
    depends_on "diffutils"
    depends_on "gpatch"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--without-getopt",
    ]
    if OS.mac?
      args << "--with-sed=#{Formula["gnu-sed"].opt_bin}/gsed"
      args << "--with-stat=/usr/bin/stat" # on macOS, quilt expects BSD stat
      if MacOS.version >= :ventura
        args << "--with-diff=#{Formula["diffutils"].opt_bin}/diff"
        args << "--with-patch=#{Formula["gpatch"].opt_bin}/patch"
      end
    else
      args << "--with-sed=#{Formula["gnu-sed"].opt_bin}/sed"
    end
    system "./configure", *args

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
