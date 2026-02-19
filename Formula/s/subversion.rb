class Subversion < Formula
  desc "Version control system designed to be a better CVS"
  homepage "https://subversion.apache.org/"
  license "Apache-2.0"
  revision 3

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=subversion/subversion-1.14.5.tar.bz2"
    mirror "https://archive.apache.org/dist/subversion/subversion-1.14.5.tar.bz2"
    sha256 "e78a29e7766b8b7b354497d08f71a55641abc53675ce1875584781aae35644a1"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ce4f041d63dc7d7d82169f6078adf8644689694185ec1cf97449aa675f28f8a8"
    sha256 arm64_sequoia: "9af120df151d3839df30fd71222e6b2bb4a3ff5d6130a6d01d88c91c32251397"
    sha256 arm64_sonoma:  "955bb3e745dc2953621198bb183460c405c63287a8c9e05da9a0812a5af10aa0"
    sha256 sonoma:        "311df2025d05d11e0404c8945b086fc954074e9ca11e1cf936528c12abad69ed"
    sha256 arm64_linux:   "9e2b9ba8f2a5ba0efaa5db767baefa2d228ab2192f7a88b3fb13e82e82038648"
    sha256 x86_64_linux:  "c6c2674be10507ef292f4cb4385f184d74171f414efd95c1c99727e8bf100d66"
  end

  head do
    url "https://github.com/apache/subversion.git", branch: "trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "swig" => :build
  depends_on "apache-serf"
  depends_on "apr"
  depends_on "apr-util"
  depends_on "lz4"
  depends_on "utf8proc"

  uses_from_macos "perl" => [:build, :test]
  uses_from_macos "ruby" => :build
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "py3c" do
    url "https://github.com/encukou/py3c/archive/refs/tags/v1.4.tar.gz"
    sha256 "abc745079ef906148817f4472c3fb4bc41d62a9ea51a746b53e09819494ac006"
  end

  def python3
    "python3.14"
  end

  def install
    py3c_prefix = buildpath/"py3c"
    resource("py3c").stage(py3c_prefix)

    # Use existing system zlib and sqlite
    if OS.mac?
      zlib = sqlite = MacOS.sdk_for_formula(self).path/"usr"
    else
      zlib = Formula["zlib"].opt_prefix
      sqlite = Formula["sqlite"].opt_prefix
    end

    perl = DevelopmentTools.locate("perl")
    ruby = DevelopmentTools.locate("ruby")

    args = %W[
      --enable-optimize
      --disable-mod-activation
      --disable-plaintext-password-storage
      --with-apr-util=#{Formula["apr-util"].opt_prefix}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-apxs=no
      --with-ruby-sitedir=#{lib}/ruby
      --with-py3c=#{py3c_prefix}
      --with-serf=#{Formula["apache-serf"].opt_prefix}
      --with-sqlite=#{sqlite}
      --with-swig-perl=#{perl}
      --with-swig-python=#{which(python3)}
      --with-swig-ruby=#{ruby}
      --with-zlib=#{zlib}
      --without-apache-libexecdir
      --without-berkeley-db
      --without-gpg-agent
      --without-jikes
    ]

    # preserve compatibility with macOS 12.0–12.2
    args << "--enable-sqlite-compatibility-version=3.36.0" if OS.mac? && MacOS.version == :monterey

    inreplace "Makefile.in",
              "toolsdir = @bindir@/svn-tools",
              "toolsdir = @libexecdir@/svn-tools"

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize { system "make", "install" }
    bash_completion.install "tools/client-side/bash_completion" => "subversion"

    system "make", "tools"
    system "make", "install-tools"

    system "make", "swig-py"
    system "make", "install-swig-py"
    (prefix/Language::Python.site_packages(python3)).install_symlink Dir["#{lib}/svn-python/*"]

    perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
    perl_core = Pathname.new(perl_archlib)/"CORE"
    perl_extern_h = perl_core/"EXTERN.h"

    if OS.mac? && !perl_extern_h.exist?
      # No EXTERN.h, maybe it's system perl
      perl_version = Utils.safe_popen_read(perl.to_s, "--version")[/v(\d+\.\d+)(?:\.\d+)?/, 1]
      perl_core = MacOS.sdk_path/"System/Library/Perl"/perl_version/"darwin-thread-multi-2level/CORE"
      perl_extern_h = perl_core/"EXTERN.h"
    end

    onoe "'#{perl_extern_h}' does not exist" unless perl_extern_h.exist?

    if OS.mac?
      inreplace "Makefile" do |s|
        s.change_make_var! "SWIG_PL_INCLUDES",
          "$(SWIG_INCLUDES) -arch #{Hardware::CPU.arch} -g -pipe -fno-common " \
          "-DPERL_DARWIN -fno-strict-aliasing -I#{HOMEBREW_PREFIX}/include -I#{perl_core}"
      end
    end
    system "make", "swig-pl-lib"
    system "make", "install-swig-pl-lib"
    cd "subversion/bindings/swig/perl/native" do
      system perl, "Makefile.PL", "PREFIX=#{prefix}", "INSTALLSITEMAN3DIR=#{man3}"
      ENV.deparallelize { system "make", "install" }
    end

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    rm_r(prefix/"Library/Perl") if (prefix/"Library/Perl").exist?
  end

  def caveats
    <<~EOS
      svntools have been installed to:
        #{opt_libexec}

      The perl bindings are located in various subdirectories of:
        #{opt_lib}/perl5
    EOS
  end

  test do
    system bin/"svnadmin", "create", "test"
    system bin/"svnadmin", "verify", "test"
    system bin/"svn", "checkout", "file://#{testpath}/test", "svn-test"

    platform = if OS.mac?
      "darwin-thread-multi-2level"
    else
      arch = Hardware::CPU.arm? ? :aarch64 : Hardware::CPU.arch
      "#{arch}-#{OS.kernel_name.downcase}-thread-multi"
    end

    perl = DevelopmentTools.locate("perl")

    perl_version = Utils.safe_popen_read(perl.to_s, "--version")[/v(\d+\.\d+(?:\.\d+)?)/, 1]
    ENV["PERL5LIB"] = "#{lib}/perl5/site_perl/#{perl_version}/#{platform}"
    system perl, "-e", "use SVN::Client; new SVN::Client()"

    system python3, "-c", "import svn.client, svn.repos"
  end
end
