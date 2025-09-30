class Wget2 < Formula
  desc "Successor of GNU Wget, a file and recursive website downloader"
  homepage "https://gitlab.com/gnuwget/wget2"
  url "https://ftpmirror.gnu.org/gnu/wget/wget2-2.2.0.tar.gz"
  sha256 "2b3b9c85b7fb26d33ca5f41f1f8daca71838d869a19b406063aa5c655294d357"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/href=.*?wget2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "02f865ef13cd93291ae12b59dac0eb9c883c9078430e63ba1176bc82b27c911b"
    sha256 arm64_sequoia: "b863537174ece79da6195e2ac5707cd31488d58088bdccb573e189aa75153bff"
    sha256 arm64_sonoma:  "99190ec35480c9addfc7d84e5a026eceb272213914048503ec9c21c5385990cf"
    sha256 arm64_ventura: "c707efb734c4e2338ec805111837642cf423a7aab4439f4743bdcb9bccfd46e7"
    sha256 sonoma:        "fb4276bbc11f84ce2d2b98daf426fd4a1b1aa5ffd10973f3f07d868429059ab3"
    sha256 ventura:       "b0ef99e0d7383df8316c5284d7ff38d02415f6cae006aad83ffe21e078262069"
    sha256 arm64_linux:   "7c20c1db23e50bdc5fdb67333ea80ed932235f79b2a82c28afe92e621a5667d2"
    sha256 x86_64_linux:  "a6580c39554f67d8db6d5817945792dc48c0c9e648d39043aa9bb4fc314e171c"
  end

  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "lzlib" => :build # static lib
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build # Build fails with macOS-provided `texinfo`

  depends_on "brotli"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "gettext"
  end

  def install
    # The pattern used in 'docs/wget2_md2man.sh.in' doesn't work with system sed
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    lzlib = Formula["lzlib"]
    ENV.append "LZIP_CFLAGS", "-I#{lzlib.include}"
    ENV.append "LZIP_LIBS", "-L#{lzlib.lib} -llz"

    args = %w[
      --disable-silent-rules
      --with-bzip2
      --with-lzma
    ]
    args << "--with-libintl-prefix=#{Formula["gettext"].prefix}" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wget2 --version")
  end
end
