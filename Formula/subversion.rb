class Subversion < Formula
  desc "Version control system designed to be a better CVS"
  homepage "https://subversion.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=subversion/subversion-1.14.1.tar.bz2"
  mirror "https://archive.apache.org/dist/subversion/subversion-1.14.1.tar.bz2"
  sha256 "2c5da93c255d2e5569fa91d92457fdb65396b0666fad4fd59b22e154d986e1a9"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 arm64_big_sur: "b423d18ba80a53c6ed46b56d79a5a5de2ed481eaefd13517ad1f320a4ed9a722"
    sha256 big_sur:       "06616fa9d0ad78cafa32614ed7a2058d8e0ab576df463e0b717ba7971c2f3950"
    sha256 catalina:      "257063523f77a6107cd0e58cd93952a7f35b6cdb918f0d00ad4ca6ecaa287058"
    sha256 mojave:        "4c5231f495c38edcf838878a256e65db321d8977bcae96877370cf80c6942bff"
    sha256 x86_64_linux:  "becc6b133c39dc0e23861d3af0fb90ae54ed5ad7256c4f435c036629fb25249d"
  end

  head do
    url "https://github.com/apache/subversion.git", branch: "trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "scons" => :build # For Serf
  depends_on "swig" => :build
  depends_on "apr"
  depends_on "apr-util"

  # build against Homebrew versions of
  # gettext, lz4 and utf8proc for consistency
  depends_on "gettext"
  depends_on "lz4"
  depends_on "openssl@1.1" # For Serf
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "krb5"
  uses_from_macos "perl"
  uses_from_macos "ruby"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    # Prevent "-arch ppc" from being pulled in from Perl's $Config{ccflags}
    patch :DATA
  end

  on_linux do
    depends_on "libtool"
  end

  resource "py3c" do
    url "https://github.com/encukou/py3c/archive/v1.1.tar.gz"
    sha256 "c7ffc22bc92dded0ca859db53ef3a0b466f89a9f8aad29359c9fe4ff18ebdd20"
  end

  resource "serf" do
    url "https://www.apache.org/dyn/closer.lua?path=serf/serf-1.3.9.tar.bz2"
    mirror "https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2"
    sha256 "549c2d21c577a8a9c0450facb5cca809f26591f048e466552240947bdf7a87cc"
  end

  def install
    py3c_prefix = buildpath/"py3c"
    serf_prefix = libexec/"serf"

    resource("py3c").unpack py3c_prefix
    resource("serf").stage do
      on_linux do
        inreplace "SConstruct" do |s|
          s.gsub! "env.Append(LIBPATH=['$OPENSSL\/lib'])",
          "\\1\nenv.Append(CPPPATH=['$ZLIB\/include'])\nenv.Append(LIBPATH=['$ZLIB/lib'])"
        end
      end

      inreplace "SConstruct" do |s|
        s.gsub! "print 'Warning: Used unknown variables:', ', '.join(unknown.keys())",
        "print('Warning: Used unknown variables:', ', '.join(unknown.keys()))"
        s.gsub! "match = re.search('SERF_MAJOR_VERSION ([0-9]+).*'",
        "match = re.search(b'SERF_MAJOR_VERSION ([0-9]+).*'"
        s.gsub! "'SERF_MINOR_VERSION ([0-9]+).*'",
        "b'SERF_MINOR_VERSION ([0-9]+).*'"
        s.gsub! "'SERF_PATCH_VERSION ([0-9]+)'",
        "b'SERF_PATCH_VERSION ([0-9]+)'"
      end

      # scons ignores our compiler and flags unless explicitly passed
      krb5 = "/usr"
      on_linux do
        krb5 = Formula["krb5"].opt_prefix
      end

      args = %W[
        PREFIX=#{serf_prefix} GSSAPI=#{krb5} CC=#{ENV.cc}
        CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}
        OPENSSL=#{Formula["openssl@1.1"].opt_prefix}
        APR=#{Formula["apr"].opt_prefix}
        APU=#{Formula["apr-util"].opt_prefix}
      ]

      on_linux do
        args << "ZLIB=#{Formula["zlib"].opt_prefix}"
      end

      system "scons", *args
      system "scons", "install"
    end

    # Use existing system zlib and sqlite
    on_linux do
      # svn can't find libserf-1.so.1 at runtime without this
      ENV.append "LDFLAGS", "-Wl,-rpath=#{serf_prefix}/lib"
    end

    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    zlib = "#{MacOS.sdk_path_if_needed}/usr"
    on_linux do
      zlib = Formula["zlib"].opt_prefix
    end

    ruby = "/usr/bin/ruby"
    on_linux do
      ruby = "#{Formula["ruby"].opt_bin}/ruby"
    end

    sqlite = "#{MacOS.sdk_path_if_needed}/usr"
    on_linux do
      sqlite = Formula["sqlite"].opt_prefix
    end

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --enable-optimize
      --disable-mod-activation
      --disable-plaintext-password-storage
      --with-apr-util=#{Formula["apr-util"].opt_prefix}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-apxs=no
      --with-jdk=#{Formula["openjdk"].opt_prefix}
      --with-ruby-sitedir=#{lib}/ruby
      --with-py3c=#{py3c_prefix}
      --with-serf=#{serf_prefix}
      --with-sqlite=#{sqlite}
      --with-swig=#{Formula["swig"].opt_prefix}
      --with-zlib=#{zlib}
      --without-apache-libexecdir
      --without-berkeley-db
      --without-gpg-agent
      --enable-javahl
      --without-jikes
      PYTHON=#{Formula["python@3.9"].opt_bin}/python3
      RUBY=#{ruby}
    ]

    inreplace "Makefile.in",
              "toolsdir = @bindir@/svn-tools",
              "toolsdir = @libexecdir@/svn-tools"

    # regenerate configure file as we patched `build/ac-macros/swig.m4`
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    ENV.deparallelize { system "make", "install" }
    bash_completion.install "tools/client-side/bash_completion" => "subversion"

    system "make", "tools"
    system "make", "install-tools"

    system "make", "swig-py"
    system "make", "install-swig-py"
    (lib/"python3.9/site-packages").install_symlink Dir["#{lib}/svn-python/*"]

    # Java and Perl support don't build correctly in parallel:
    # https://github.com/Homebrew/homebrew/issues/20415
    ENV.deparallelize
    system "make", "javahl"
    system "make", "install-javahl"

    if Hardware::CPU.intel?
      perl_archlib = Utils.safe_popen_read("perl", "-MConfig", "-e", "print $Config{archlib}")
      perl_core = Pathname.new(perl_archlib)/"CORE"
      perl_extern_h = perl_core/"EXTERN.h"

      unless perl_extern_h.exist?
        # No EXTERN.h, maybe it's system perl
        perl_version = Utils.safe_popen_read("perl", "--version")[/v(\d+\.\d+)(?:\.\d+)?/, 1]
        perl_core = MacOS.sdk_path/"System/Library/Perl"/perl_version/"darwin-thread-multi-2level/CORE"
        perl_extern_h = perl_core/"EXTERN.h"
      end

      onoe "'#{perl_extern_h}' does not exist" unless perl_extern_h.exist?

      on_macos do
        inreplace "Makefile" do |s|
          s.change_make_var! "SWIG_PL_INCLUDES",
            "$(SWIG_INCLUDES) -arch x86_64 -g -pipe -fno-common " \
            "-DPERL_DARWIN -fno-strict-aliasing -I#{HOMEBREW_PREFIX}/include -I#{perl_core}"
        end
      end
      system "make", "swig-pl"
      system "make", "install-swig-pl"

      # This is only created when building against system Perl, but it isn't
      # purged by Homebrew's post-install cleaner because that doesn't check
      # "Library" directories. It is however pointless to keep around as it
      # only contains the perllocal.pod installation file.
      rm_rf prefix/"Library/Perl"
    end
  end

  def caveats
    <<~EOS
      svntools have been installed to:
        #{opt_libexec}

      The perl bindings are located in various subdirectories of:
        #{opt_lib}/perl5

      You may need to link the Java bindings into the Java Extensions folder:
        sudo mkdir -p /Library/Java/Extensions
        sudo ln -s #{HOMEBREW_PREFIX}/lib/libsvnjavahl-1.dylib /Library/Java/Extensions/libsvnjavahl-1.dylib
    EOS
  end

  test do
    system "#{bin}/svnadmin", "create", "test"
    system "#{bin}/svnadmin", "verify", "test"

    if Hardware::CPU.intel?
      platform = "darwin-thread-multi-2level"
      on_linux do
        platform = "x86_64-linux-thread-multi"
      end

      perl = "/usr/bin/perl"
      on_linux do
        perl = "#{Formula["perl"].opt_bin}/perl"
      end

      perl_version = Utils.safe_popen_read(perl.to_s, "--version")[/v(\d+\.\d+(?:\.\d+)?)/, 1]
      ENV["PERL5LIB"] = "#{lib}/perl5/site_perl/#{perl_version}/#{platform}"
      system perl, "-e", "use SVN::Client; new SVN::Client()"
    end
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
