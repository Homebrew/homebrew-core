class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.68.tar.gz"
  sha256 "fe8c09de03c106e85b3737c8f03ade147c956b79ed7af485a1c8a3858db38426"
  license "GPL-2.0-or-later"
  head "https://git.savannah.gnu.org/git/quilt.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/quilt/"
    regex(/href=.*?quilt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "502671863bf107d3681e09299effd69c594f030f82aa44213efc142c63ac826d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af866881737fac5051ef085909b232d15486658dd38312db8c22a01c3756ca20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "367878f8dd8271300992bb0f1d0477e72ed4d0ce6803b05b30c85fbbc8d0acbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e935a3ddbba6609ab5cebc2d17d93350decaf956c79c08364f92cfb697fb037"
    sha256 cellar: :any_skip_relocation, ventura:        "af866881737fac5051ef085909b232d15486658dd38312db8c22a01c3756ca20"
    sha256 cellar: :any_skip_relocation, monterey:       "367878f8dd8271300992bb0f1d0477e72ed4d0ce6803b05b30c85fbbc8d0acbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa56add5a120e209251cc06d9e9f08d742fd011d8d590bd65c9cfee13c81d87b"
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
