class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.67.tar.gz"
  sha256 "3be3be0987e72a6c364678bb827e3e1fcc10322b56bc5f02b576698f55013cc2"
  license "GPL-2.0-or-later"
  head "https://git.savannah.gnu.org/git/quilt.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/quilt/"
    regex(/href=.*?quilt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec75101f4f4ad66c663993386e2f73d5ddb9537fd081117662123d2d7e7f25db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "484b4b704012510ac4a5a87c8d4ee1084198a0c281bad54f8589d1c916e54450"
    sha256 cellar: :any_skip_relocation, monterey:       "ec75101f4f4ad66c663993386e2f73d5ddb9537fd081117662123d2d7e7f25db"
    sha256 cellar: :any_skip_relocation, big_sur:        "484b4b704012510ac4a5a87c8d4ee1084198a0c281bad54f8589d1c916e54450"
    sha256 cellar: :any_skip_relocation, catalina:       "7b77455170ea9df640510f0ca82de752659b94e26b3c73b6aaa6ba56bac2a309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2b00e285ecc519ad6d6a340c3cccab0c85d02a36a02df29eb002b7dff4e1fa4"
  end

  depends_on "coreutils"
  depends_on "gnu-sed"

  def install
    args = [
      "--prefix=#{prefix}",
      "--without-getopt",
    ]
    if OS.mac?
      args << "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed"
      args << "--with-stat=/usr/bin/stat" # on macOS, quilt expects BSD stat
    else
      args << "--with-sed=#{HOMEBREW_PREFIX}/bin/sed"
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
