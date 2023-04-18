class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.4.3/tcpreplay-4.4.3.tar.gz"
  sha256 "216331692e10c12d7f257945e777928d79bd091117f3e4ffb5b312eb2ca0bf7c"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ba4da70429e81af5c7e99917f909711ab60d20ac385a6404f68551a875709b55"
    sha256 cellar: :any,                 arm64_monterey: "359532e03025e843f7abfd9bcf2660eecca53339393b4514d8fbdc3a912e9769"
    sha256 cellar: :any,                 arm64_big_sur:  "3f6d99b318f8c29a6c8138437d792a7aa3b3652fc370825c5632a24624552cf3"
    sha256 cellar: :any,                 ventura:        "b6bb43b2c66e176ce25edd31ce5b54c44c7b24954006fbc37f939f94396241b0"
    sha256 cellar: :any,                 monterey:       "d759b079b1416dc67c531c42c0942e1a09b7599258e26634579b44682f510a78"
    sha256 cellar: :any,                 big_sur:        "8daa28092b5884dac18cc54f28d9cbc37940793f3b324b07c9047210f83543e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "672adb59f7382210e73819d3ce10660ed4d374c5764413e4e387b9c47b62fe73"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-link
      --with-libdnet=#{Formula["libdnet"].opt_prefix}
    ]

    args << if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      "--with-macosx-sdk=#{MacOS.version}"
    else
      "--with-libpcap=#{Formula["libpcap"].opt_prefix}"
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
