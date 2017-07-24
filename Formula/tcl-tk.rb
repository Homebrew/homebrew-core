class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.6/tcl8.6.6-src.tar.gz"
  mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl8.6.6-src.tar.gz"
  version "8.6.6"
  sha256 "a265409781e4b3edcc4ef822533071b34c3dc6790b893963809b9fe221befe07"
  revision 2

  bottle do
    sha256 "00cb0c31a7a9fb3820685bb5a0baee3e8b3d81e2b3b7f021277bbb833a710ee0" => :sierra
    sha256 "7821833c62e38916e07c2c2a491db4d8ad7d5016a95abb39e3678dbfe3821502" => :el_capitan
    sha256 "c0449527355ede1293309ff674ec02e9df91188f9d85173d134ed388cee0afb3" => :yosemite
  end

  keg_only :provided_by_osx,
    "tk installs some X11 headers and macOS provides an (older) Tcl/Tk"

  option "without-tcllib", "Don't build tcllib (utility modules)"
  option "without-tk", "Don't build the Tk (window toolkit)"

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.6/tk8.6.6-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tk8.6.6-src.tar.gz"
    version "8.6.6"
    sha256 "d62c371a71b4744ed830e3c21d27968c31dba74dd2c45f36b9b071e6d88eb19d"
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.18/tcllib-1.18.tar.gz"
    sha256 "72667ecbbd41af740157ee346db77734d1245b41dffc13ac80ca678dd3ccb515"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh8.6", bin/"tclsh"
    end

    if build.with? "tk"
      ENV.prepend_path "PATH", bin # so that tk finds our new tclsh

      resource("tk").stage do
        cd "unix" do
          system "./configure", *args, "--enable-aqua=yes",
                                "--without-x", "--with-tcl=#{lib}"
          system "make", "TK_LIBRARY=#{lib}"
          system "make", "install"
          system "make", "install-private-headers"
          ln_s bin/"wish8.6", bin/"wish"
        end
      end
    end

    if build.with? "tcllib"
      resource("tcllib").stage do
        system "./configure", "--prefix=#{prefix}",
                              "--mandir=#{man}"
        system "make", "install"
      end
    end
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp
  end
end
