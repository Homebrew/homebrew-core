class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.39.tgz"
  sha256 "5613218b2a1060c730b6c4a14c2b34ce33898dd19b38fb9ea0858c5517e42082"

  bottle do
    cellar :any
    sha256 "40a6aa38f88d284ef5254c7a689c795b451ab78a03331dd8352e71999cf58db7" => :sierra
    sha256 "40965861e708196ec3c18f9a99943f75a54dac2494c88aed96b3df70cd46d4fa" => :el_capitan
    sha256 "4e256b38d10e905ece1c874a5655612f2f2cc8e7911bfe1d72b07ea2e209244a" => :yosemite
    sha256 "0c8a97e409b389b5e696330123a1f185ebf17c91728274634a25dc7adfa72866" => :mavericks
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "openssl"
  depends_on "xz" => :optional

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 https://github.com/Tarsnap/tarsnap/issues/286
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "libcperciva/util/monoclock.c", "CLOCK_MONOTONIC",
                                                "UNDEFINED_GIBBERISH"
    end

    system "autoreconf", "-iv" if build.head?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bash-completion-dir=#{bash_completion}
    ]
    args << "--without-lzma" << "--without-lzmadec" if build.without? "xz"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"tarsnap", "-c", "--dry-run", testpath
  end
end
