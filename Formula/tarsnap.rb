class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.39.tgz"
  sha256 "5613218b2a1060c730b6c4a14c2b34ce33898dd19b38fb9ea0858c5517e42082"
  license "0BSD"
  revision 1

  livecheck do
    url "https://www.tarsnap.com/download/"
    regex(/href=.*?tarsnap-autoconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d249e7eb52d4bfc67e8a74fb45c7419181731c4c37c74591a08d97bd2dd064d8"
    sha256 cellar: :any,                 arm64_big_sur:  "879ca63de6f2c293dd325fe0cf7a7284cf5603bf5efcc6fc5159ddb676d1163d"
    sha256 cellar: :any,                 monterey:       "72bcf82c424cf4df2a63420b7353ee9085738b4132294d84cd6bdcb695c7ee9d"
    sha256 cellar: :any,                 big_sur:        "db0fceeaf2b93d4d7588ef1b3c0ac69080595e4fd05311fb3d61ccb95c9f9ae0"
    sha256 cellar: :any,                 catalina:       "afa6ebfefbc93faf12ac6576f26edb0b68c6a47cc65b893d590ea1efd4301fb4"
    sha256 cellar: :any,                 mojave:         "c6c97cd8e16ba02f7997d1d269373dca82d4a3d188b89dc3532c8149e277bd02"
    sha256 cellar: :any,                 high_sierra:    "847aae76230beaedfa23ea0a0f375864a8af6063c8539634637ab218a425540d"
    sha256 cellar: :any,                 sierra:         "dbf1a477d46c723a3cebb6b1001771bf51956035ea3369b5e2451c091cad5930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ae2d2ea9adaba408f88a7e5917aa3891971e135b24052482193c94e8023b66"
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "e2fsprogs" => :build
  end

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
