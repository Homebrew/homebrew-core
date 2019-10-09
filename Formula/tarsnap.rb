class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.39.tgz"
  sha256 "5613218b2a1060c730b6c4a14c2b34ce33898dd19b38fb9ea0858c5517e42082"
  revision 1

  bottle do
    cellar :any
    sha256 "afa6ebfefbc93faf12ac6576f26edb0b68c6a47cc65b893d590ea1efd4301fb4" => :catalina
    sha256 "c6c97cd8e16ba02f7997d1d269373dca82d4a3d188b89dc3532c8149e277bd02" => :mojave
    sha256 "847aae76230beaedfa23ea0a0f375864a8af6063c8539634637ab218a425540d" => :high_sierra
    sha256 "dbf1a477d46c723a3cebb6b1001771bf51956035ea3369b5e2451c091cad5930" => :sierra
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@1.1"

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 https://github.com/Tarsnap/tarsnap/issues/286
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
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
      --without-lzma
      --without-lzmadec
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"tarsnap", "-c", "--dry-run", testpath
  end
end
