class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.6/tcl8.6.6-src.tar.gz"
  mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl8.6.6-src.tar.gz"
  version "8.6.6"
  sha256 "a265409781e4b3edcc4ef822533071b34c3dc6790b893963809b9fe221befe07"
  revision 1

  bottle do
    sha256 "de26155e0b2fee960af4791d39e3d6c79421c635c0a914be8a0254ff28f4fad2" => :sierra
    sha256 "9481cea8f38c644eb12f6a42463082469f1e91fe7616b167fbda46ded9bef336" => :el_capitan
    sha256 "f137c8176792d8363989981c2f3838f8edee73738a02bf899caddd8460abdd86" => :yosemite
  end

  keg_only :provided_by_osx,
    "tk installs some X11 headers and macOS provides an (older) Tcl/Tk"

  deprecated_option "enable-threads" => "with-threads"

  option "with-threads", "Build with multithreading support"
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
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--enable-threads" if build.with? "threads"
    args << "--enable-64bit" if MacOS.prefer_64_bit?

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
        args = ["--prefix=#{prefix}", "--mandir=#{man}", "--with-tcl=#{lib}"]
        args << "--enable-threads" if build.with? "threads"
        args << "--enable-64bit" if MacOS.prefer_64_bit?
        args << "--enable-aqua=yes" << "--without-x"

        cd "unix" do
          system "./configure", *args
          system "make", "TK_LIBRARY=#{lib}"
          # system "make", "test"  # for maintainers
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
