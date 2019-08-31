class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.9/tcl8.6.9-src.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.9-src.tar.gz"
  version "8.6.9"
  sha256 "ad0cd2de2c87b9ba8086b43957a0de3eb2eb565c7159d5f53ccbba3feb915f4e"
  revision 1

  bottle do
    sha256 "4c12908cbfbcfd23e6b3c93d6ca3b9a691d302d4d02b39a9e07dfbce391ff094" => :mojave
    sha256 "387d25e7b5ba5a24fed6f7db7153e2c5ce8f068ab1c8bcac4fd6f60043ee0c3f" => :high_sierra
    sha256 "c602f2d305bc7eeac5915b9676bc513c52b7e270cb131bf504edde1b70046587" => :sierra
  end

  keg_only :provided_by_macos,
    "tk installs some X11 headers and macOS provides an (older) Tcl/Tk"

  depends_on "openssl@1.1"

  resource "critcl" do
    url "https://github.com/andreas-kupries/critcl/archive/3.1.17.tar.gz"
    sha256 "fff83b341fc07b8ff23bf1f645133bb4bffe4741da2e6f31155e522a74c228e4"
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.19/tcllib-1.19.tar.gz"
    sha256 "01fe87cf1855b96866cf5394b6a786fd40b314022714b34110aeb6af545f6a9c"
  end

  resource "tcltls" do
    url "https://core.tcl.tk/tcltls/uv/tcltls-1.7.16.tar.gz"
    sha256 "6845000732bedf764e78c234cee646f95bb68df34e590c39434ab8edd6f5b9af"
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.9/tk8.6.9.1-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.9.1-src.tar.gz"
    version "8.6.9.1"
    sha256 "8fcbcd958a8fd727e279f4cac00971eee2ce271dc741650b1fc33375fb74ebb4"

    # Upstream issue 7 Jan 2018 "Build failure with Aqua support on OS X 10.8 and 10.9"
    # See https://core.tcl.tk/tcl/tktview/95a8293a2936e34cc8d0658c21e5214f1ca9b435
    if MacOS.version == :mavericks
      patch :p0 do
        url "https://raw.githubusercontent.com/macports/macports-ports/0a883ad388b/x11/tk/files/patch-macosx-tkMacOSXXStubs.c.diff"
        sha256 "2cdba6bbf2503307fe4f4d7200ad57c9926ebf0ff6ed3e65bf551067a30a04a9"
      end
    end
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

    # Let tk finds our new tclsh
    ENV.prepend_path "PATH", bin

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

    resource("critcl").stage do
      system bin/"tclsh", "build.tcl", "install"
    end

    resource("tcllib").stage do
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
      ENV["SDKROOT"] = MacOS.sdk_path
      system "make", "critcl"
      cp_r "modules/tcllibc", "#{lib}/"
      ln_s "#{lib}/tcllibc/macosx-x86_64-clang", "#{lib}/tcllibc/macosx-x86_64"
    end

    resource("tcltls").stage do
      system "./configure", "--with-ssl=openssl",
                            "--with-openssl-dir=#{Formula["openssl@1.1"].opt_prefix}",
                            "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make", "install"
    end
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp
  end
end
