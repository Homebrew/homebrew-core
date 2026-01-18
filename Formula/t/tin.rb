class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://sunsite.icm.edu.pl/pub/unix/news/tin/v2.6/tin-2.6.5.tar.xz"
  sha256 "91384d133d72671863494dd9742bc622b4089ea8ea760884a5b8c34095d76dc5"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "0331a52cf02914a9b691b82aec7907c4c7f2cd1350e2ee32d211f6bffe1cabfe"
    sha256                               arm64_sequoia: "43463542d6dec64094e3601ebf8ca1274be58f9e4247a65bf98318ecbe3e7dc8"
    sha256                               arm64_sonoma:  "32264e99abcdcd1d32589ba30f3c44a391a726e15cd3b06ef826338e65090bc7"
    sha256                               sonoma:        "f4f1ef28eeb3cb7aed044a0a3fd774c30337c774ba34ea92e9436064407a14d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "230c5daa95b5616f1c3625d93ab5132aa86944f3dabb715a51fca63084d241f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e459eb91463c1ba613553317eb88a7acb625e401577ba98646803e4cd972059"
  end

  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    # Remove bundled libraries
    rm_r buildpath/"pcre"

    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-pcre2-config=#{Formula["pcre2"].opt_prefix}/bin/pcre2-config"
    system "make", "build"
    system "make", "install"
  end

  test do
    system bin/"tin", "-H"
  end
end
