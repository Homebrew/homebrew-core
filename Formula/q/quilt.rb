class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.savannah.gnu.org/git/quilt.git", branch: "master"

  stable do
    url "https://download.savannah.gnu.org/releases/quilt/quilt-0.67.tar.gz"
    sha256 "3be3be0987e72a6c364678bb827e3e1fcc10322b56bc5f02b576698f55013cc2"

    # This fixes 'quilt refresh' with macOS/BSD awk. In stable, 'quilt refresh'
    # just appends the whole patch-file content to the file again and again.
    # This commit is upstream but not included in a stable version yet.
    # Remove on next release.
    patch do
      url "https://git.savannah.nongnu.org/cgit/quilt.git/patch/?id=ce9c68abb7cee0b4fb0d5a7ff7048d0ab3b726f8"
      sha256 "5b936570d75ea30c892baa481293f1e7b9265d106304f87d05853c61e09b2522"
    end
  end

  livecheck do
    url "https://download.savannah.gnu.org/releases/quilt/"
    regex(/href=.*?quilt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85ffd84dafa24dda7015974948cd605116a4e225221d8bd7c186c31ea755559f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10cd41c30603f01fe89ec6ae643bc44e24bf1cd3f5f484ac2099fbb0e05dbf15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66e778f938ed310928846102d07d5055f32ccc16068fa4d0c985e0ada6ea5d59"
    sha256 cellar: :any_skip_relocation, ventura:        "85ffd84dafa24dda7015974948cd605116a4e225221d8bd7c186c31ea755559f"
    sha256 cellar: :any_skip_relocation, monterey:       "10cd41c30603f01fe89ec6ae643bc44e24bf1cd3f5f484ac2099fbb0e05dbf15"
    sha256 cellar: :any_skip_relocation, big_sur:        "66e778f938ed310928846102d07d5055f32ccc16068fa4d0c985e0ada6ea5d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfac0b11eaeeb52b79ac7b5a5ccd6af8b434f963c1365c95fb9e7b125766ff6e"
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
