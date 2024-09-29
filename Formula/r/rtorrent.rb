class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.10.0/rtorrent-0.10.0.tar.gz"
  sha256 "cc65bba7abead24151f10af116eca2342b0c320fdff3cb8d604c0af09215d3aa"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d73c40d99e7cfbaa067a7c3b405ac28501376977857a68a66a9468122aa1d850"
    sha256 cellar: :any,                 arm64_sonoma:   "7b55a418e1ae243cd062ac5e3e1171ee082814623a15fd3898ecc3172b9a7fe4"
    sha256 cellar: :any,                 arm64_ventura:  "f2c7a8bd2f77caffa6fef4f0fa85f9e598fc8e8e0129562f6ebeb9fda9e84064"
    sha256 cellar: :any,                 arm64_monterey: "85c38e502a8c6ec4b20c973b4d79785436925776ae26db29461931f8221d2d8b"
    sha256 cellar: :any,                 sonoma:         "a7f53e049ba9dd7af4ab89fd49f909654c0492e25dc9c0bc88719d2f7969de63"
    sha256 cellar: :any,                 ventura:        "c5a27e4139d425afe95746a83dd9cc77d97655a02a10eb02882bde897daaf57e"
    sha256 cellar: :any,                 monterey:       "b2a247f5cfba3c8b16326a82055d80e10bc494c3c7db8ace77dc4cee75460bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c12f9d685c1f2702ecefa0eca8d926e4baf71a7935a469a81b864aadac396a6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    args = ["--prefix=#{prefix}", "--with-xmlrpc-c",
            "--disable-debug", "--disable-dependency-tracking"]

    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    pid = fork do
      exec bin/"rtorrent", "-n", "-s", testpath
    end
    sleep 3
    assert_predicate testpath/"rtorrent.lock", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
