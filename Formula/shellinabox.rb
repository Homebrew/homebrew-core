class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/v2.20.tar.gz"
  sha256 "27a5ec6c3439f87aee238c47cc56e7357a6249e5ca9ed0f044f0057ef389d81e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d7a8a65efe179655169e1fcb7ff3db1440f4207517ae512a86f017929ab764a" => :sierra
    sha256 "1502d88ce75b94a3cefd4ccc1d65e9c892a02abc754b0027e99b889d22b6989a" => :el_capitan
    sha256 "28a52a963f3cdc8068b4843b2974ccf977cd676f6adf20c126321ed0845f29ea" => :yosemite
    sha256 "5a7ab0bccaaa3687e986f040e0bf1eb12701feecb3e0db6114a5c7cdc1cdfe73" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shellinaboxd", "--version"
  end
end
