class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.net/"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.9a.tar.xz"
  sha256 "bc572a1881e5e20987ac590158b041ab7803845a9691036d3ba5e982f66d9ca3"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c847f3f5d301242e39854aaa5a240f927fe20f54ea5122933de39b7fc67ce5e0"
    sha256 arm64_sequoia: "161b47e43d5412e6277eff6ba8f2884e0a345c238db8ed1601ece4501f05ee5c"
    sha256 arm64_sonoma:  "a8acd5f5d17d4bbef98332d6ece0de046b023c8485a1ce713bc183f10110db5e"
    sha256 arm64_ventura: "e5ae9151e1f3e865317d32e0355445922d46e080e60d583b65df77591322b54b"
    sha256 sonoma:        "9ed33c2acaeb19e8826d4e82057ffccd949e7de53334d924b3005a02b50baf78"
    sha256 ventura:       "1cfeb80f07bbdd495c33c152b606f352e2785c421b50ba0816470ae99cc7676a"
    sha256 arm64_linux:   "ffa26e011fab5d5d529bab92892b47c4911b9126bf1a0d8f7f62de152e6d7c56"
    sha256 x86_64_linux:  "f4faa9ef548b215a82a5098c94bfcb09ad1acd51eebfa0539818f1a5fd20a112"
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

    if OS.mac?
      (etc/"X11/app-defaults/Fig").append_lines <<~X11_DEFAULTS
        ! Disable internationalization to stop segfaults
        ! https://github.com/Homebrew/homebrew-core/issues/221146
        ! https://sourceforge.net/p/mcj/tickets/177/#7c23
        Fig.international: False
      X11_DEFAULTS
    end
  end

  test do
    assert_equal "Xfig #{version}", shell_output("#{bin}/xfig -V 2>&1").strip
    assert_equal "Error: Can't open display:", shell_output("DISPLAY= #{bin}/xfig 2>&1", 1).strip
  end
end
