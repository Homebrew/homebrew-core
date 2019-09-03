class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.39.tgz"
  sha256 "5613218b2a1060c730b6c4a14c2b34ce33898dd19b38fb9ea0858c5517e42082"
  revision 1

  bottle do
    sha256 "6e5bd7f2ba58872d43896d92ac1bf1d9f42f2cddc16dc1c374d7353b8d55a82d" => :mojave
    sha256 "b152754ed7ef385e4fd816fbf24571322479757c083ce889134903d4b88e0232" => :high_sierra
    sha256 "7d4da94d575085b3f2c2066ae5b0e83edd589d0238d065fb0f9ba68d916c3868" => :sierra
    sha256 "6c4ff5911171f779b85bda69f07eb7a561ec0911517fe3a48b2cb917c1ff4f92" => :el_capitan
    sha256 "6cc300ce4d0db123d225b9b2ff1d28625061440484932a9c572282de785d4819" => :yosemite
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
