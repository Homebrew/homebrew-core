class Tclreadline < Formula
  desc "GNU Readline library for interactive Tcl shells"
  homepage "https://github.com/flightaware/tclreadline/"
  url "https://github.com/flightaware/tclreadline/archive/v2.3.1.tar.gz"
  sha256 "1b0941fabb1f7494201079caff3ff96401fbc26b1c56245034b0b5e7f33c20d1"

  option "with-tcl-tk",  "Link against a brewed Tcl/Tk instead of the macOS stock one"
  option "with-tclshrl", "Build readline enhanced replacement for tclsh"
  option "with-wishrl",  "Build readline enhanced replacement for wish"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "readline"
  depends_on "tcl-tk" => :optional
  depends_on :x11 if build.with? "wishrl"

  patch :DATA if build.with? "wishrl" unless build.with? "tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    args << "--enable-tclshrl" if build.with? "tclshrl"
    args << "--enable-wishrl"  if build.with? "wishrl"

    stock_tcl  = "#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    stock_tk   = "#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework"
    brewed_tcl = Formula["tcl-tk"].lib

    args << "--with-tcl=#{(build.with?("tcl-tk") ? brewed_tcl : stock_tcl)}"
    args << "--with-tk=#{(build.with?("tcl-tk") ? brewed_tcl : stock_tk)}" if build.with? "wishrl" unless build.with? "tcl-tk"

    system "./autogen.sh", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Copy the sample.tclshrc to $HOME/.tclshrc.
      See https://github.com/flightaware/tclreadline for further instructions.
    EOS
  end

  test do
    system "echo 'set auto_path [linsert $auto_path 0 #{lib}] ; if {[package require tclreadline] eq {" + version + "} } {exit 0} else {exit 1}' | tclsh -"
  end
end
__END__
diff --git a/configure.ac b/configure.ac
index e40b5c5d7..de1cd4b23 100644
--- a/configure.ac
+++ b/configure.ac
@@ -78,6 +78,38 @@ if test $TCL_MAJOR_VERSION -lt 8; then
 fi
 
 
+# -- WHICH TK TO USE
+AC_ARG_WITH(
+    tk,
+    [  --with-tk=DIR          where to look for tkConfig.sh],
+    tk_search=$withval,
+    tk_search=""
+)
+
+AC_MSG_CHECKING([which tkConfig.sh to use])
+TK_LIB_DIR=""
+for dir in $tk_search /usr/lib /usr/local/lib $exec_prefix/lib /usr/local/lib/unix /opt/tcl/lib; do
+    if test -r $dir/tkConfig.sh; then
+        TK_LIB_DIR=$dir
+        break
+    fi
+done
+
+if test -z "$TK_LIB_DIR"; then
+    AC_MSG_ERROR(Can't find Tk libraries.  Use --with-tk to specify the directory containing tkConfig.sh on your system.)
+fi
+
+. $TK_LIB_DIR/tkConfig.sh
+AC_MSG_RESULT($TK_LIB_DIR/tkConfig.sh)
+AC_MSG_CHECKING([for your tk version])
+AC_MSG_RESULT([$TK_VERSION, patchlevel $TK_PATCH_LEVEL])
+
+# Check, if tk_version is > 8.0
+if test $TK_MAJOR_VERSION -lt 8; then
+    AC_MSG_ERROR(need tk 8.0 or higher.)
+fi
+
+
 # -----------------------------------------------------------------------
 #   Set up a new default --prefix.
 # -----------------------------------------------------------------------
@@ -245,7 +277,7 @@ AC_ARG_ENABLE(wishrl,
         yes)
         enable_static=true
         dnl source the tkConfig.sh which defines TK_LIB_SPEC
-        . $TCL_LIB_DIR/tkConfig.sh
+        . $TK_LIB_DIR/tkConfig.sh
         AC_SUBST(TK_LIB_SPEC)
         ;;
         no)  enable_static=false ;;
