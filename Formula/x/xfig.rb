class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.net/"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.9.tar.xz"
  sha256 "13ed9d04d1bbc2dec09da7ef49ceec278382d290f6cd926474c2f2d016fec2f7"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "2ce377c656dab395b95d498c03b8b3b95a1153f63cef176c3039291c55760834"
    sha256 arm64_ventura:  "ab1c86c5044e495596fe576e1c053478251d70a5faece3f221d165d29b9c3ee5"
    sha256 arm64_monterey: "39f08a4ba5383fa90cb2a4b76d0b8b5d6929843f6fac04450249e85ef647ac43"
    sha256 arm64_big_sur:  "7626ebc11c73a512392640c29e57a1579ef4cfc4bbfe1ec774cc42692c44554d"
    sha256 sonoma:         "c147b060e3cafb4a5932294471a3b808faffc1c46dc321a50471e6e22b27e4a2"
    sha256 ventura:        "680fc82cd8fb6aeb17cfc09c4de0d98eeec23a86e71d580757bebaf857fe0688"
    sha256 monterey:       "18fff7f110a0e27f75e4a99c3116900af986814aa1dadd3fc7cb947bffca2852"
    sha256 big_sur:        "0ff1ddc946b12ba65d183737b31678b6c4baedcb0cc012557bec0128f74b28f7"
    sha256 x86_64_linux:   "b07b185ca2339fe988e5b4b379da797c1760874feead0d5029131953e4a78427"
  end

  depends_on "fig2dev"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxaw3d"
  depends_on "libxft"
  depends_on "libxpm"
  depends_on "libxt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    # Use GNU sed on macOS to avoid this build failure:
    # `sed: 1: " /^[ \t]*\(!\|$\)/ d; s ...": bad flag in substitute command: '}'`
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    # Xft #includes <ft2build.h>, not <freetype2/ft2build.h>, hence freetype2
    # must be put into the search path.
    ENV.append "CFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"

    system "./configure", "--with-appdefaultdir=#{etc}/X11/app-defaults",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install-strip"
  end

  test do
    assert_equal "Xfig #{version}", shell_output("#{bin}/xfig -V 2>&1").strip
  end
end
