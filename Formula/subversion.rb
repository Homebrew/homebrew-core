class Subversion < Formula
  desc "Version control system designed to be a better CVS"
  homepage "https://subversion.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=subversion/subversion-1.10.2.tar.bz2"
  mirror "https://archive.apache.org/dist/subversion/subversion-1.10.2.tar.bz2"
  sha256 "5b35e3a858d948de9e8892bf494893c9f7886782f6abbe166c0487c19cf6ed88"

  bottle do
    sha256 "2115c4455e243a34fe537da1f901779d1fd2668937e2da48ccb5f7bad484249f" => :mojave
    sha256 "b40f591a44176f1e7f7f1c0aaebe8772657687b13e672286f3ab45b69f22db0b" => :high_sierra
    sha256 "274b5e82027f90b8d707c859cf143808672b55e243b4070c4d18f0f6e914d6f3" => :sierra
    sha256 "c5fee4ce6dae3f2c7398dd01a5c6df56f0227ec2323b4be107a2d26196339b6c" => :el_capitan
  end

  head do
    url "https://github.com/apache/subversion.git", :branch => "trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  option "with-java", "Build Java bindings"

  deprecated_option "java" => "with-java"

  depends_on "pkg-config" => :build
  depends_on "scons" => :build # For Serf
  depends_on "swig" => :build
  depends_on "apr"
  depends_on "apr-util"

  # build against Homebrew versions of
  # lz4, perl, sqlite and utf8proc for consistency
  depends_on "lz4"
  depends_on "openssl" # For Serf
  depends_on "perl"
  depends_on "sqlite"
  depends_on "utf8proc"

  # Other optional dependencies
  depends_on :java => ["1.8", :optional]

  # When building Perl or Ruby bindings, need to use a compiler that
  # recognizes GCC-style switches, since that's what the system languages
  # were compiled against.
  fails_with :clang do
    build 318
    cause "core.c:1: error: bad value (native) for -march= switch"
  end

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

    serf_prefix = libexec/"serf"

    resource("serf").stage do
      # scons ignores our compiler and flags unless explicitly passed
      args = %W[
        PREFIX=#{serf_prefix} GSSAPI=/usr CC=#{ENV.cc}
        CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}
        OPENSSL=#{Formula["openssl"].opt_prefix}
        APR=#{Formula["apr"].opt_prefix}
        APU=#{Formula["apr-util"].opt_prefix}
      ]
      scons(*args)
      scons "install"
    end

    if build.with? "java"
      # Java support doesn't build correctly in parallel:
      # https://github.com/Homebrew/homebrew/issues/20415
      ENV.deparallelize
    end

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --enable-optimize
      --disable-mod-activation
      --disable-nls
      --with-apr-util=#{Formula["apr-util"].opt_prefix}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-apxs=no
      --with-ruby-sitedir=#{lib}/ruby
      --with-serf=#{serf_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
      --with-zlib=/usr
      --without-apache-libexecdir
      --without-berkeley-db
      --without-gpg-agent
      RUBY=/usr/bin/ruby
    ]

    args << "--enable-javahl" << "--without-jikes" if build.with? "java"

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

    # In theory SWIG can be built in parallel, in practice...
    ENV.deparallelize

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

    if build.with? "java"
      system "make", "javahl"
      system "make", "install-javahl"
    end

    # Peg to system Ruby
    system "make", "swig-rb", "EXTRA_SWIG_LDFLAGS=-L/usr/lib"
    system "make", "install-swig-rb"
  end

  def caveats
    s = <<~EOS
      svntools have been installed to:
        #{opt_libexec}

      The perl bindings are located in various subdirectories of:
        #{opt_lib}/perl5

      If you wish to use the Ruby bindings you may need to add:
        #{HOMEBREW_PREFIX}/lib/ruby
      to your RUBYLIB.
    EOS

    if build.with? "java"
      s += "\n"
      s += <<~EOS
        You may need to link the Java bindings into the Java Extensions folder:
          sudo mkdir -p /Library/Java/Extensions
          sudo ln -s #{HOMEBREW_PREFIX}/lib/libsvnjavahl-1.dylib /Library/Java/Extensions/libsvnjavahl-1.dylib
      EOS
    end

    s
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
