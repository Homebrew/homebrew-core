class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.15.4/rtorrent-0.15.4.tar.gz"
  sha256 "39342070caf7506bce5ffe8527b5693d6cbe4fda851d54d505707c9063919fc4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74eff163aa464492cb149c2338b562412c6f95fd6e92ba78d240a594b48a07d7"
    sha256 cellar: :any,                 arm64_sonoma:  "7c967db0a885331036ca0757e484fb2443303c962c26e9e19413a7bd19d92ff3"
    sha256 cellar: :any,                 arm64_ventura: "7ee458fa975015e3d9f8b892d371bc4bcd55d21353b58115cd871679f66d9cc6"
    sha256 cellar: :any,                 sonoma:        "b07ab4ce93bc8e231fdf4844be6211a64f956d396917905635433d5dc19ce3bb"
    sha256 cellar: :any,                 ventura:       "b5a1648b56241cf37bfdc090d2ae5e1304da4070fe56a28dc66b127c2ca3ea3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dfc03adc646b35edb4b68c9b09a001293ccaedd5d73a531a96ebf0d59a8a232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c2502f64ea92b501dbe261a3cdbb43ba832ba5b5b0c0be804638acd3a2ee725"
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
