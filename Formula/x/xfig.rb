class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.net/"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.9.tar.xz"
  sha256 "13ed9d04d1bbc2dec09da7ef49ceec278382d290f6cd926474c2f2d016fec2f7"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "00065bb855d889cb03d1b9a6be6b8e379afbdc34eec9bd8a6b295c7c6569f66f"
    sha256 arm64_sonoma:  "fc167af1203cd9c55c4b608d648ec787c0fab60d03addae286b93354edfa4a27"
    sha256 arm64_ventura: "78a6256536cf3979802f06d9c739f1167a9dd1dc79e82973c426c84002616ade"
    sha256 sonoma:        "248e1c225dbae1d8272f3fdde6e7d73ab7c200ced0855e6da9fdfea637b0fb2d"
    sha256 ventura:       "45c8fe0a50ab221a983d50b39016857a07df1a6e753a1fa62d21b100624c7fcf"
    sha256 x86_64_linux:  "d18838b6078735b2015842785ca34e48695ecd25a33569b406bfd125cda965da"
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
