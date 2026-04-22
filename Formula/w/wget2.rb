class Wget2 < Formula
  desc "Successor of GNU Wget, a file and recursive website downloader"
  homepage "https://gitlab.com/gnuwget/wget2"
  url "https://ftpmirror.gnu.org/gnu/wget/wget2-2.2.1.tar.gz"
  sha256 "d7544b13e37f18e601244fce5f5f40688ac1d6ab9541e0fbb01a32ee1fb447b4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?wget2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d907ed01032e6655193fa18c47e45b5e1b202cdd1f328ebefbff065c180cd9e8"
    sha256 arm64_sequoia: "209e40513c2136920a4eb82e1358efb5ea494bcaf1c460145a9ec74d98e1705b"
    sha256 arm64_sonoma:  "1ab70482bf8fa6f88ea2091003126bc866dd531ae59b2c71c5bc370a858317cd"
    sha256 sonoma:        "a65fde8f14db9841aa9e30890f13693c3a5381d21bf7724fc4f284fa64db91a4"
    sha256 arm64_linux:   "5dfee2ad6e5c7a7ecf5efb3f9afe902df0b8f986e1207775dafc855b2d241cea"
    sha256 x86_64_linux:  "ea2c0e17b1e5d8e0dac92529034ca89b7651f7ba9d065e66a7a0ebc19683133a"
  end

  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build # Build fails with macOS-provided `texinfo`

  depends_on "brotli"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "lzlib" # static lib
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
