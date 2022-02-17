class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.40.tgz"
  sha256 "bccae5380c1c1d6be25dccfb7c2eaa8364ba3401aafaee61e3c5574203c27fd5"
  license "0BSD"

  livecheck do
    url "https://www.tarsnap.com/download.html"
    regex(/href=.*?tarsnap-autoconf[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2f1ea86aae6e6e464e2e78b7e984fdb884e62ab350b3d20058e0db069d7b191e"
    sha256 cellar: :any,                 arm64_big_sur:  "cf93e896315ebb2a3fefb2ff032b6e39c12fa6fd800aea3b92ef0634d31858eb"
    sha256 cellar: :any,                 monterey:       "c0f9c6e1b236cb7090f165e6d0446bf7ebbeec5c376e86f95c4780914986f241"
    sha256 cellar: :any,                 big_sur:        "1c48cabb8d20ad07878301d4569f1aaf9c170ba8a966822dbcf4f24f50b4d00c"
    sha256 cellar: :any,                 catalina:       "46c31d5b91537dfe098c9cdf09b56585fbfa0d096035a71dd6d2ff9746841456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d753f70ee86f887511c3a1a1dbcea99b4da13b77f21b74d56fc1e5190a5c9c6c"
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git", branch: "master"
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
