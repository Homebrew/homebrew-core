class SubversionAT18 < Formula
  desc "Version control system"
  homepage "https://subversion.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=subversion/subversion-1.8.19.tar.bz2"
  mirror "https://archive.apache.org/dist/subversion/subversion-1.8.19.tar.bz2"
  sha256 "56e869b0db59519867f7077849c9c0962c599974f1412ea235eab7f98c20e6be"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "d471619f345885cff74ff22c7c1783ff31d2a979471f8b55dba9851fd7872fdc" => :catalina
    sha256 "f1ddeb0830e05709298f49b05131297e079a20cdf115a57d84e8c336b2c97aca" => :mojave
    sha256 "4f5837d367ff776070c2d0a1a20a17a14fb56ec5296a00969c5fd5914888da02" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "scons" => :build # For Serf
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@1.1" # For Serf
  depends_on "sqlite" # build against Homebrew version for consistency

  resource "serf" do
    url "https://www.apache.org/dyn/closer.cgi?path=serf/serf-1.3.9.tar.bz2"
    mirror "https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2"
    sha256 "549c2d21c577a8a9c0450facb5cca809f26591f048e466552240947bdf7a87cc"
  end

  # Fix #23993 by stripping flags swig can't handle from SWIG_CPPFLAGS
  # Prevent "-arch ppc" from being pulled in from Perl's $Config{ccflags}
  # Prevent linking into a Python Framework
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/subversion@1.8/1.8.16.patch"
    sha256 "3d8bb24db773c713a1301986f71e018b7d0ff95425738964b575562841f8dc64"
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
                OPENSSL=#{Formula["openssl@1.1"].opt_prefix}]

      if MacOS.version >= :sierra || !MacOS::CLT.installed?
        args << "APR=#{Formula["apr"].opt_prefix}"
        args << "APU=#{Formula["apr-util"].opt_prefix}"
      end

      system "scons", *args
      system "scons", "install"
    end

    if build.include? "unicode-path"
      raise <<~EOS
        The --unicode-path patch is not supported on Subversion 1.8.

        Upgrading from a 1.7 version built with this patch is not supported.

        You should stay on 1.7, install 1.7 from homebrew-versions, or
          brew rm subversion && brew install subversion
        to build a new version of 1.8 without this patch.
      EOS
    end

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

    if MacOS::CLT.installed? && MacOS.version < :sierra
      args << "--with-apr=/usr"
      args << "--with-apr-util=/usr"
    else
      args << "--with-apr=#{Formula["apr"].opt_prefix}"
      args << "--with-apr-util=#{Formula["apr-util"].opt_prefix}"
      args << "--with-apxs=no"
    end

    inreplace "Makefile.in",
              "toolsdir = @bindir@/svn-tools",
              "toolsdir = @libexecdir@/svn-tools"

    system "./configure", *args
    system "make"
    system "make", "install"
    bash_completion.install "tools/client-side/bash_completion" => "subversion"

    system "make", "tools"
    system "make", "install-tools"
  end

  def caveats; <<~EOS
    svntools have been installed to:
      #{opt_libexec}
  EOS
  end

  test do
    system "#{bin}/svnadmin", "create", "test"
    system "#{bin}/svnadmin", "verify", "test"
  end
end
