class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"

  stable do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.8/tcl8.6.8-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl8.6.8-src.tar.gz"
    version "8.6.8"
    sha256 "c43cb0c1518ce42b00e7c8f6eaddd5195c53a98f94adc717234a65cbcfd3f96a"

    resource "tk" do
      url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.8/tk8.6.8-src.tar.gz"
      mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tk8.6.8-src.tar.gz"
      version "8.6.8"
      sha256 "49e7bca08dde95195a27f594f7c850b088be357a7c7096e44e1158c7a5fd7b33"
    end
  end

  bottle do
    sha256 "cd4dec2b564dcad86b151803c852142366bc48ec1b13d48a2e495c83fc32a688" => :high_sierra
    sha256 "96144fc3d7eaeec6125ff9f534f0aa21b61b673914dd8cb4898b10ca0530d90e" => :sierra
    sha256 "79222749d221013eb7d1fb529ace13293a819b43d6633b964d1f8f318ac66f33" => :el_capitan
  end

  devel do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.7a1/tcl8.7a1-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_7/tk8.7a1-src.tar.gz"
    version "8.7a1"
    sha256 "2bbd4e0bbdebeaf5dc6cc823d0805afb45c764292f6667d9ce2b9fcf5399e0dc"

    resource "tk" do
      url "https://downloads.sourceforge.net/project/tcl/Tcl/8.7a1/tk8.7a1-src.tar.gz"
      mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_7/tk8.7a1-src.tar.gz"
      sha256 "131e4bae43a15dff0324c0479358bb42cfd7b8de0e1ca8d93c9207643c7144dd"
    end
  end

  keg_only :provided_by_osx,
    "tk installs some X11 headers and macOS provides an (older) Tcl/Tk"

  option "without-tcllib", "Don't build tcllib (utility modules)"
  option "without-tk", "Don't build the Tk (window toolkit)"

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
      ln_s bin/"tclsh#{version.to_f}", bin/"tclsh"
    end

    if build.with? "tk"
      ENV.prepend_path "PATH", bin # so that tk finds our new tclsh

      resource("tk").stage do
        cd "unix" do
          system "./configure", *args, "--enable-aqua=yes",
                                "--without-x", "--with-tcl=#{lib}"
          system "make"
          system "make", "install"
          system "make", "install-private-headers"
          ln_s bin/"wish#{version.to_f}", bin/"wish"
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
