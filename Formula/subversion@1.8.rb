class SubversionAT18 < Formula
  desc "Version control system"
  homepage "https://subversion.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=subversion/subversion-1.8.16.tar.bz2"
  mirror "https://archive.apache.org/dist/subversion/subversion-1.8.16.tar.bz2"
  sha256 "f18f6e8309270982135aae54d96958f9ca6b93f8a4e746dd634b1b5b84edb346"

  bottle do
    sha256 "3f6c2f5b14952261bd16b368026725411c6eb6aec91d3af340647a3f9aa92536" => :sierra
    sha256 "fff0c975bfaec2a116b2f4c9ac93d702ee8e06381f31810d582b01bda8610a3e" => :el_capitan
    sha256 "efa3eaee6fc8518354d09b80d2813c7b090495da8691703b31e1297ef0e750cd" => :yosemite
  end

  keg_only :versioned_formula

  deprecated_option "java" => "with-java"
  deprecated_option "perl" => "with-perl"
  deprecated_option "ruby" => "with-ruby"

  option "with-java", "Build Java bindings"
  option "with-perl", "Build Perl bindings"
  option "with-ruby", "Build Ruby bindings"
  option "with-gpg-agent", "Build with support for GPG Agent"

  depends_on "pkg-config" => :build

  depends_on "apr-util"
  depends_on "apr"

  # Always build against Homebrew versions instead of system versions for consistency.
  depends_on "sqlite"
  depends_on :python => :optional

  # Bindings require swig
  depends_on "swig" if build.with?("perl") || build.with?("python") || build.with?("ruby")

  # For Serf
  depends_on "scons" => :build
  depends_on "openssl"

  # Other optional dependencies
  depends_on "gpg-agent" => :optional
  depends_on :java => :optional

  resource "serf" do
    url "https://archive.apache.org/dist/serf/serf-1.3.8.tar.bz2"
    sha256 "e0500be065dbbce490449837bb2ab624e46d64fc0b090474d9acaa87c82b2590"
  end

  # Fix #23993 by stripping flags swig can't handle from SWIG_CPPFLAGS
  # Prevent "-arch ppc" from being pulled in from Perl's $Config{ccflags}
  # Prevent linking into a Python Framework
  patch :DATA

  if build.with?("perl") || build.with?("ruby")
    # When building Perl or Ruby bindings, need to use a compiler that
    # recognizes GCC-style switches, since that's what the system languages
    # were compiled against.
    fails_with :clang do
      build 318
      cause "core.c:1: error: bad value (native) for -march= switch"
    end
  end

  def install
    inreplace "Makefile.in",
      "@APXS@ -i -S LIBEXECDIR=\"$(APACHE_LIBEXECDIR)\"",
      "@APXS@ -i -S LIBEXECDIR=\"#{libexec.to_s.sub("@", "\\@")}\""

    serf_prefix = libexec/"serf"

    resource("serf").stage do
      # SConstruct merges in gssapi linkflags using scons's MergeFlags,
      # but that discards duplicate values - including the duplicate
      # values we want, like multiple -arch values for a universal build.
      # Passing 0 as the `unique` kwarg turns this behaviour off.
      inreplace "SConstruct", "unique=1", "unique=0"

      # scons ignores our compiler and flags unless explicitly passed
      args = %W[PREFIX=#{serf_prefix} GSSAPI=/usr CC=#{ENV.cc}
                CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}
                OPENSSL=#{Formula["openssl"].opt_prefix}]

      if MacOS.version >= :sierra || !MacOS::CLT.installed?
        args << "APR=#{Formula["apr"].opt_prefix}"
        args << "APU=#{Formula["apr-util"].opt_prefix}"
      end

      scons(*args)
      scons "install"
    end

    if build.include? "unicode-path"
      raise <<-EOS.undent
        The --unicode-path patch is not supported on Subversion 1.8.

        Upgrading from a 1.7 version built with this patch is not supported.

        You should stay on 1.7, install 1.7 from homebrew-versions, or
          brew rm subversion && brew install subversion
        to build a new version of 1.8 without this patch.
      EOS
    end

    # Java support doesn't build correctly in parallel: https://github.com/Homebrew/homebrew/issues/20415
    ENV.deparallelize if build.with? "java"

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--with-zlib=/usr",
            "--with-sqlite=#{Formula["sqlite"].opt_prefix}",
            "--with-serf=#{serf_prefix}",
            "--disable-mod-activation",
            "--disable-nls",
            "--without-apache-libexecdir",
            "--without-berkeley-db"]

    args << "--enable-javahl" << "--without-jikes" if build.with? "java"
    args << "--without-gpg-agent" if build.without? "gpg-agent"

    if MacOS::CLT.installed? && MacOS.version < :sierra
      args << "--with-apr=/usr"
      args << "--with-apr-util=/usr"
    else
      args << "--with-apr=#{Formula["apr"].opt_prefix}"
      args << "--with-apr-util=#{Formula["apr-util"].opt_prefix}"
      args << "--with-apxs=no"
    end

    if build.with? "ruby"
      args << "--with-ruby-sitedir=#{lib}/ruby"
      # Peg to system Ruby
      args << "RUBY=/usr/bin/ruby"
    end

    # The system Python is built with llvm-gcc, so we override this
    # variable to prevent failures due to incompatible CFLAGS
    ENV["ac_cv_python_compile"] = ENV.cc

    inreplace "Makefile.in",
              "toolsdir = @bindir@/svn-tools",
              "toolsdir = @libexecdir@/svn-tools"

    system "./configure", *args
    system "make"
    system "make", "install"
    bash_completion.install "tools/client-side/bash_completion" => "subversion"

    system "make", "tools"
    system "make", "install-tools"

    if build.with? "python"
      system "make", "swig-py"
      system "make", "install-swig-py"
      (lib/"python2.7/site-packages").install_symlink Dir["#{lib}/svn-python/*"]
    end

    if build.with? "perl"
      # In theory SWIG can be built in parallel, in practice...
      ENV.deparallelize
      perl_core = Pathname.new(`perl -MConfig -e 'print $Config{archlib}'`)+"CORE"
      unless perl_core.exist?
        onoe "perl CORE directory does not exist in '#{perl_core}'"
      end

      inreplace "Makefile" do |s|
        s.change_make_var! "SWIG_PL_INCLUDES",
          "$(SWIG_INCLUDES) -arch #{MacOS.preferred_arch} -g -pipe -fno-common -DPERL_DARWIN -fno-strict-aliasing -I/usr/local/include -I#{perl_core}"
      end
      system "make", "swig-pl"
      system "make", "install-swig-pl", "DESTDIR=#{prefix}"

      # Some of the libraries get installed into the wrong place, they end up having the
      # prefix in the directory name twice.

      lib.install Dir["#{prefix}/#{lib}/*"]
    end

    if build.with? "java"
      system "make", "javahl"
      system "make", "install-javahl"
    end

    if build.with? "ruby"
      # Peg to system Ruby
      system "make", "swig-rb", "EXTRA_SWIG_LDFLAGS=-L/usr/lib"
      system "make", "install-swig-rb"
    end
  end

  def caveats
    s = <<-EOS.undent
      svntools have been installed to:
        #{opt_libexec}
    EOS

    if build.with? "perl"
      s += <<-EOS.undent

        The perl bindings are located in various subdirectories of:
          #{prefix}/Library/Perl
      EOS
    end

    if build.with? "ruby"
      s += <<-EOS.undent

        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby
      EOS
    end

    if build.with? "java"
      s += <<-EOS.undent

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
  end
end

__END__
diff --git a/configure b/configure
index 445251b..6ff4332 100755
--- a/configure
+++ b/configure
@@ -25366,6 +25366,8 @@ fi
 SWIG_CPPFLAGS="$CPPFLAGS"

   SWIG_CPPFLAGS=`echo "$SWIG_CPPFLAGS" | $SED -e 's/-no-cpp-precomp //'`
+  SWIG_CPPFLAGS=`echo "$SWIG_CPPFLAGS" | $SED -e 's/-F\/[^ ]* //'`
+  SWIG_CPPFLAGS=`echo "$SWIG_CPPFLAGS" | $SED -e 's/-isystem\/[^ ]* //'`



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
