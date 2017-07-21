class Tclreadline < Formula
  desc "Makes the GNU Readline library available for interactive tcl shells"
  homepage "https://tclreadline.sourceforge.io"
  url "https://downloads.sourceforge.net/project/tclreadline/tclreadline/tclreadline-2.1.0/tclreadline-2.1.0.tar.gz"
  sha256 "def2325e45e2b7f30b04ad5078481740596599622c253043c503c2285f5672e7"


  bottle do
  end
  

  depends_on 'readline'
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build


  resource "gold.patch" do
    url "https://raw.githubusercontent.com/gentoo/gentoo/master/dev-tcltk/tclreadline/files/tclreadline-2.1.0-gold.patch"
    sha256 "c36f826c374dfdbe6411d5e13fbd9d90d42f18c0e72f3032ae23bd5348188598"
  end

  resource "alloc-free.patch" do
    url "https://raw.githubusercontent.com/gentoo/gentoo/master/dev-tcltk/tclreadline/files/tclreadline-2.1.0-alloc-free.patch"
    sha256 "41e52a17ab8869dafcb3be290611300853946d5475a8a0ab1ab19698acfa7ed2"
  end

  resource "executing-macro.patch" do
    url "https://raw.githubusercontent.com/gentoo/gentoo/master/dev-tcltk/tclreadline/files/tclreadline-2.1.0-rl-executing-macro.patch"
    sha256 "b27758352df46d77829e9aa97883e18f36f548f162ae8ef30266f78b66da8280"
  end

  resource "history-expand.patch" do
    url "https://raw.githubusercontent.com/gentoo/gentoo/master/dev-tcltk/tclreadline/files/tclreadline-2.1.0-rl-history-expand.patch"
    sha256 "ba37a9354f8ea8f5562d279989248bd6bfa33482b8aeff253fad3d37b360ccb0"
  end

  resource "prompt.patch" do
    url "https://raw.githubusercontent.com/gentoo/gentoo/master/dev-tcltk/tclreadline/files/tclreadline-2.1.0-rl-prompt.patch"
    sha256 "7dda1f9eebb9be2cf88f141a10d64e91d8dc7a21184d93813e209b77c3f1cd10"
  end

  resource "debian_patches" do
    version "15"
    url "http://ftp.us.debian.org/debian/pool/main/t/tclreadline/tclreadline_2.1.0-15.debian.tar.xz"
    sha256 "fa1fc943200f14247356e0157825c91e0c625a5c9783932fe4b7bcdb02822e22"
  end


  def install
    inreplace "configure.in", /AM_CONFIG_HEADER/, "AC_CONFIG_HEADERS"
    mv "configure.in", "configure.ac"
    
    buildpath.install resource("gold.patch")
    buildpath.install resource("alloc-free.patch")
    buildpath.install resource("executing-macro.patch")
    buildpath.install resource("history-expand.patch")
    buildpath.install resource("prompt.patch")
    (buildpath/"debian").install resource("debian_patches")

    safe_system "sed -e 's:configure.in:configure.ac:g' -i '' #{buildpath}/debian/patches/* "

    safe_system "for p in *.patch; do patch -p1 < $p; done"
    rm "debian/patches/tclrldir.patch"
    safe_system "for p in debian/patches/*.patch; do patch -p1 < $p; done"

    safe_system "autoreconf", "-fvi"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"

    system "make", "install" 
  end

  def caveats
    <<-EOS.undent
    To enable readline completion in tclsh put something like this in your ~/.tclshrc

    if {$tcl_interactive} {
      set auto_path [linsert $auto_path 0 #{lib}]
      package require tclreadline
      set tclreadline::historyLength 200
      tclreadline::Loop
    }

    See https://sourceforge.net/p/tclreadline/git/ci/master/tree/sample.tclshrc
    EOS
  end

  test do
    system "echo 'set auto_path [linsert $auto_path 0 /usr/local/lib] ; if {[package require tclreadline] eq {" + version + "} } {exit 0} else {exit 1}' | tclsh -"
  end
end
