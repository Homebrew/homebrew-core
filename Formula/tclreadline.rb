class Tclreadline < Formula
  desc "Makes the GNU Readline library available for interactive tcl shells"
  homepage "https://tclreadline.sourceforge.io"
  url "https://github.com/flightaware/tclreadline/archive/v2.2.0.tar.gz"
  sha256 "6ca811ff8fbb3a9c8c400a8f7a3c2819a232c7b8e216cc10c4b47aef6a07d507"


  bottle do
  end
  

  depends_on 'readline'
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build


  def install
    system "./autogen.sh", "--disable-dependency-tracking",
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
    system "echo 'set auto_path [linsert $auto_path 0 #{lib}] ; if {[package require tclreadline] eq {" + version + "} } {exit 0} else {exit 1}' | tclsh -"
  end
end
