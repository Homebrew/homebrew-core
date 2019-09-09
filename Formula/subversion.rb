class Subversion < Formula
  desc "Version control system designed to be a better CVS"
  homepage "https://subversion.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=subversion/subversion-1.12.2.tar.bz2"
  sha256 "3bd0b5c8e4c5175263dc9a92fd9aef94ce917e80af034f26fe5c45fde7e0f771"
  revision 1

  bottle do
    sha256 "adb6e43f78b343c2f693e29e0ba1fe7ba938255dfe28dd610b5bc40697472c3b" => :mojave
    sha256 "c8081073fc95bb6814fd11b30c37b1933350f149214ebe471596d2a66d50fab3" => :high_sierra
    sha256 "fffe67b24474c9282effd394dfba786b6056dd3b479a26f66bd843da23486c16" => :sierra
  end

  head do
    url "https://github.com/apache/subversion.git", :branch => "trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on :java => ["1.8+", :build]
  depends_on "pkg-config" => :build
  depends_on "scons" => :build # For Serf
  depends_on "swig@3" => :build # https://issues.apache.org/jira/browse/SVN-4818
  depends_on "apr"
  depends_on "apr-util"

  # build against Homebrew versions of
  # gettext, lz4, perl, sqlite and utf8proc for consistency
  depends_on "gettext"
  depends_on "lz4"
  depends_on "openssl@1.1" # For Serf
  depends_on "perl"
  depends_on "sqlite"
  depends_on "utf8proc"

  resource "serf" do
    url "https://www.apache.org/dyn/closer.cgi?path=serf/serf-1.3.9.tar.bz2"
    mirror "https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2"
    sha256 "549c2d21c577a8a9c0450facb5cca809f26591f048e466552240947bdf7a87cc"
  end

  # Fix #23993 by stripping flags swig can't handle from SWIG_CPPFLAGS
  # Prevent "-arch ppc" from being pulled in from Perl's $Config{ccflags}
  # Prevent linking into a Python Framework
  patch :DATA

  def install
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/2.7/bin"
    # Fix #33530 by ensuring the system Ruby can build test programs.
    ENV.delete "SDKROOT"

    serf_prefix = libexec/"serf"

    resource("serf").stage do
      # scons ignores our compiler and flags unless explicitly passed
      args = %W[
        PREFIX=#{serf_prefix} GSSAPI=/usr CC=#{ENV.cc}
        CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}
        OPENSSL=#{Formula["openssl@1.1"].opt_prefix}
        APR=#{Formula["apr"].opt_prefix}
        APU=#{Formula["apr-util"].opt_prefix}
      ]
      system "scons", *args
      system "scons", "install"
    end

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --enable-optimize
      --disable-mod-activation
      --disable-plaintext-password-storage
      --with-apr-util=#{Formula["apr-util"].opt_prefix}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-apxs=no
      --with-ruby-sitedir=#{lib}/ruby
      --with-serf=#{serf_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
      --with-zlib=#{MacOS.sdk_path_if_needed}/usr
      --without-apache-libexecdir
      --without-berkeley-db
      --without-gpg-agent
      --enable-javahl
      --without-jikes
      RUBY=/usr/bin/ruby
    ]

    # The system Python is built with llvm-gcc, so we override this
    # variable to prevent failures due to incompatible CFLAGS
    ENV["ac_cv_python_compile"] = ENV.cc

    inreplace "Makefile.in",
              "toolsdir = @bindir@/svn-tools",
              "toolsdir = @libexecdir@/svn-tools"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
    bash_completion.install "tools/client-side/bash_completion" => "subversion"

    system "make", "tools"
    system "make", "install-tools"

    system "make", "swig-py"
    system "make", "install-swig-py"
    (lib/"python2.7/site-packages").install_symlink Dir["#{lib}/svn-python/*"]

    # Peg to system Ruby
    system "make", "swig-rb", "EXTRA_SWIG_LDFLAGS=-L/usr/lib"
    system "make", "install-swig-rb"

    # Java and Perl support don't build correctly in parallel:
    # https://github.com/Homebrew/homebrew/issues/20415
    ENV.deparallelize
    system "make", "javahl"
    system "make", "install-javahl"

    archlib = Utils.popen_read("perl -MConfig -e 'print $Config{archlib}'")
    perl_core = Pathname.new(archlib)/"CORE"
    onoe "'#{perl_core}' does not exist" unless perl_core.exist?

    inreplace "Makefile" do |s|
      s.change_make_var! "SWIG_PL_INCLUDES",
        "$(SWIG_INCLUDES) -arch #{MacOS.preferred_arch} -g -pipe -fno-common -DPERL_DARWIN -fno-strict-aliasing -I#{HOMEBREW_PREFIX}/include -I#{perl_core}"
    end
    system "make", "swig-pl"
    system "make", "install-swig-pl"

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    rm_rf prefix/"Library/Perl"
  end

  def caveats
    <<~EOS
      svntools have been installed to:
        #{opt_libexec}

      The perl bindings are located in various subdirectories of:
        #{opt_lib}/perl5

      If you wish to use the Ruby bindings you may need to add:
        #{HOMEBREW_PREFIX}/lib/ruby
      to your RUBYLIB.

      You may need to link the Java bindings into the Java Extensions folder:
        sudo mkdir -p /Library/Java/Extensions
        sudo ln -s #{HOMEBREW_PREFIX}/lib/libsvnjavahl-1.dylib /Library/Java/Extensions/libsvnjavahl-1.dylib
    EOS
  end

  test do
    system "#{bin}/svnadmin", "create", "test"
    system "#{bin}/svnadmin", "verify", "test"
    system "perl", "-e", "use SVN::Client; new SVN::Client()"
  end
end

__END__
diff --git a/subversion/bindings/swig/perl/native/Makefile.PL.in b/subversion/bindings/swig/perl/native/Makefile.PL.in
index a60430b..bd9b017 100644
--- a/subversion/bindings/swig/perl/native/Makefile.PL.in
+++ b/subversion/bindings/swig/perl/native/Makefile.PL.in
@@ -76,10 +76,13 @@ my $apr_ldflags = '@SVN_APR_LIBS@'

 chomp $apr_shlib_path_var;

+my $config_ccflags = $Config{ccflags};
+$config_ccflags =~ s/-arch\s+\S+//g;
+
 my %config = (
     ABSTRACT => 'Perl bindings for Subversion',
     DEFINE => $cppflags,
-    CCFLAGS => join(' ', $cflags, $Config{ccflags}),
+    CCFLAGS => join(' ', $cflags, $config_ccflags),
     INC  => join(' ', $includes, $cppflags,
                  " -I$swig_srcdir/perl/libsvn_swig_perl",
                  " -I$svnlib_srcdir/include",

diff --git a/build/get-py-info.py b/build/get-py-info.py
index 29a6c0a..dd1a5a8 100644
--- a/build/get-py-info.py
+++ b/build/get-py-info.py
@@ -83,7 +83,7 @@ def link_options():
   options = sysconfig.get_config_var('LDSHARED').split()
   fwdir = sysconfig.get_config_var('PYTHONFRAMEWORKDIR')

-  if fwdir and fwdir != "no-framework":
+  if fwdir and fwdir != "no-framework" and sys.platform != 'darwin':

     # Setup the framework prefix
     fwprefix = sysconfig.get_config_var('PYTHONFRAMEWORKPREFIX')
