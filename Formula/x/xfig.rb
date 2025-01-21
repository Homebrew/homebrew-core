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
    sha256 arm64_sequoia: "15314f47823b47202f5589b9392d3f7240efd9be0550edf3a7708f918f7e11a7"
    sha256 arm64_sonoma:  "d7bfff29e140007a73340cb17675c39f525904647202c08e9905856c90ed24eb"
    sha256 arm64_ventura: "e851f86fd326aed56aa0fbef6f266764bc6670ec2fdaa1ba24634babe165898f"
    sha256 sonoma:        "5465a1183061357a7a8a3a7455488fd8df9182efab574fe6812f256ad881087e"
    sha256 ventura:       "b8f02cb2ff2cc65c1c64ce3400e7e1ad5fa7e48b4ab09fece650ec6013bc11b8"
    sha256 x86_64_linux:  "421fbe1c1fffddf7545aa6e360430958758b4b2b211f80653ec8854660b864ca"
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
