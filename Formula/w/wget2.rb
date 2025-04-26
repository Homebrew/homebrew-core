class Wget2 < Formula
  desc "Successor of GNU Wget, a file and recursive website downloader"
  homepage "https://gitlab.com/gnuwget/wget2"
  url "https://ftp.gnu.org/gnu/wget/wget2-2.2.0.tar.gz"
  sha256 "2b3b9c85b7fb26d33ca5f41f1f8daca71838d869a19b406063aa5c655294d357"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?wget2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "477e456159a939aa933ea526619577425aa08eefa1c4dd13b90b83f2701c905e"
    sha256 arm64_sonoma:  "5288526cde424fc1e81ae4add33585d7a70539a0e7dd0f3da0a0b38fd4cee47d"
    sha256 arm64_ventura: "bc2c0f6366d82d759f2171f14fac1101e545e138f0008f30166b381d410c98ad"
    sha256 sonoma:        "e1cac6e4fe46311120be862c3aebe2ee0d452f5da01df5bc6cebeec8fb540af0"
    sha256 ventura:       "6f1f601644a2a7a7acdb1f4d0d7de04e26430f58c80ac9752506b200e3600fba"
    sha256 arm64_linux:   "d845a7c0972eda3799babc84d0a3bfbba8d593fd6bbc9ddea8f4d003e497f5cb"
    sha256 x86_64_linux:  "6a577c25a6df35a432534aef3a9f59e040792b1ce92055a952b1ba9e43aca1c7"
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
