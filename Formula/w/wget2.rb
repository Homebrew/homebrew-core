class Wget2 < Formula
  desc "Successor of GNU Wget, a file and recursive website downloader"
  homepage "https://gitlab.com/gnuwget/wget2"
  url "https://ftp.gnu.org/gnu/wget/wget2-2.1.0.tar.gz"
  sha256 "a05dc5191c6bad9313fd6db2777a78f5527ba4774f665d5d69f5a7461b49e2e7"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?wget2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ef2a63a1dbdcbf6740e35e5f3eae82a1f42576a8efae930cb32f8f63917e7b85"
    sha256 arm64_ventura:  "32529d4489f2d1b1b8e13c7ad927e3b59a41ce85dee1e97b0b2dea000f7a7975"
    sha256 arm64_monterey: "cad93ddee2849136995c9cd0b445d0e100fcb28883b5a8636ebf30e125a524b9"
    sha256 sonoma:         "919cd8a3394efb64eeb4f5e5299f660cd28fd5f7a548d45ac83fa9a7a17329f5"
    sha256 ventura:        "135ee4db00d16eef5936f577333761dedca0587c3e178a37c03e38e09d83d41d"
    sha256 monterey:       "781261bcd9d702f5dfa8af0ed877ed5b6e0b149ca4457b2ee7e451c577dc8ccb"
    sha256 x86_64_linux:   "e88b3e5451829851b61086d3a3962ed71e14ec41264bcefdaf474f4782c1f427"
  end

  depends_on "doxygen" => :build
  # The pattern used in 'docs/wget2_md2man.sh.in' doesn't work with system sed
  depends_on "gnu-sed" => :build
  depends_on "graphviz" => :build
  depends_on "lzip" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build # Build fails with macOS-provided `texinfo`

  depends_on "brotli"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "libtasn1"
  depends_on "lzlib"
  depends_on "nettle"
  depends_on "p11-kit"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "icu4c"
  uses_from_macos "zlib"

  def install
    gnused = Formula["gnu-sed"]
    lzlib = Formula["lzlib"]
    gettext = Formula["gettext"]

    # The pattern used in 'docs/wget2_md2man.sh.in' doesn't work with system sed
    ENV.prepend_path "PATH", gnused.libexec/"gnubin"
    ENV.append "LZIP_CFLAGS", "-I#{lzlib.include}"
    ENV.append "LZIP_LIBS", "-L#{lzlib.lib} -llz"

    system "./configure", *std_configure_args,
           "--with-bzip2",
           "--with-lzma",
           "--with-libintl-prefix=#{gettext.prefix}"

    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wget2 --version")
  end
end
