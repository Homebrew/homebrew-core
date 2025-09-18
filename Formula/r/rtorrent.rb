class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.0/rtorrent-0.16.0.tar.gz"
  sha256 "fe8f8793f3bae8de157f567d9d89629dfd6fc21bc18d7db4537c4014a23dc1d9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a3f4f7e823935c6488f2dcd50a72ecb87d172e8afa17b02f1fc80fbc50a78a1"
    sha256 cellar: :any,                 arm64_sequoia: "7822dff7194043147c23224867acfe99a34ad34bb8fb2ff8f232297090d7cfff"
    sha256 cellar: :any,                 arm64_sonoma:  "13a9d525b6d5e5a639d8ee2dbfb729944ad5879db4d3f713fa4913023991335c"
    sha256 cellar: :any,                 arm64_ventura: "a7c02ba23fb7e2e004350543415bdc9c5700cbcd43eeaaa89daa6c48c0506fc0"
    sha256 cellar: :any,                 sonoma:        "f8a8c4231f696edb34881149d9dc12573f6632d8db05dfa82b0d9525688a8038"
    sha256 cellar: :any,                 ventura:       "af9264804be798e5f7d7b256d2e75fc84f349dc202065174c2367bfca2b0439d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f05e88c6539409718638641e77a086b77269643dfe76cb0c96c3b043ad1b2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1f0ee393d6380e00efb7e060c0f4b54ddc6d98d3a906d20bb03ce0d22d44302"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-xmlrpc-c", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    pid = spawn bin/"rtorrent", "-n", "-s", testpath
    sleep 10
    assert_path_exists testpath/"rtorrent.lock"
  ensure
    Process.kill("HUP", pid)
  end
end
