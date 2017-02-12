class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/cliffordwolf/yosys/archive/yosys-0.7.tar.gz"
  sha256 "3df986d0c6bf20b78193456e11c660f2ad935cc126537c2dc5726e78896d6e6e"

  option "without-abc", "Build without support for ABC"
  option "without-tcl", "Build without support for Tcl language bindings"

  depends_on "python3"
  depends_on "libffi" => :recommended
  depends_on "readline" => :recommended
  depends_on "pkg-config" => :build
  depends_on "bison" => :build

  # Prevent the makefile from trying to automatically locate homebrew and macports libraries
  patch :DATA

  # This ABC revision is specified in the makefile.
  # The makefile by default checks it out using mercurial,
  # but this recipe instead downloads a tar.gz archive.
  resource "abc" do
    url "https://bitbucket.org/alanmi/abc/get/eb6eca6807cc.tar.gz"
    sha256 "ae9acddad38a950d48466e2f66de8116f2d21d03c78f5a270fa3bf77c3fd7b5b"
  end

  def install
    extra_args = []

    if build.with? "abc"
      resource("abc").stage buildpath/"abc"
      extra_args.push "ABCREV=default"
    else
      extra_args.push "ENABLE_ABC=0"
    end

    if build.without? "tcl"
      extra_args.push "ENABLE_TCL=0"
    end

    if build.without? "readline"
      extra_args.push "ENABLE_READLINE=0"
    end

    if build.without? "libffi"
      extra_args.push "ENABLE_PLUGINS=0"
    end

    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0", *extra_args
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 0a61fe65..061102b3 100644
--- a/Makefile
+++ b/Makefile
@@ -58,15 +58,6 @@ SED = sed
 BISON = bison
 
 ifeq (Darwin,$(findstring Darwin,$(shell uname)))
-	# add macports/homebrew include and library path to search directories, don't use '-rdynamic' and '-lrt':
-	CXXFLAGS += -I/opt/local/include -I/usr/local/opt/readline/include
-	LDFLAGS += -L/opt/local/lib -L/usr/local/opt/readline/lib
-	# add homebrew's libffi include and library path
-	CXXFLAGS += $(shell PKG_CONFIG_PATH=$$(brew list libffi | grep pkgconfig | xargs dirname) pkg-config --silence-errors --cflags libffi)
-	LDFLAGS += $(shell PKG_CONFIG_PATH=$$(brew list libffi | grep pkgconfig | xargs dirname) pkg-config --silence-errors --libs libffi)
-	# use bison installed by homebrew if available
-	BISON = $(shell (brew list bison | grep -m1 "bin/bison") || echo bison)
-	SED = sed
 else
 	LDFLAGS += -rdynamic
 	LDLIBS += -lrt
