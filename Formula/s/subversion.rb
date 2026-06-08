class Subversion < Formula
  desc "Version control system designed to be a better CVS"
  homepage "https://subversion.apache.org/"
  license "Apache-2.0"
  revision 4
  compatibility_version 1

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
    sha256 arm64_tahoe:   "5e038b0cc26af690210dccba99843496bbfec1aeb880c4dd4e9d46f4d2a730a7"
    sha256 arm64_sequoia: "6b7e822daf9fa486cd647077813e476c261cd86fb444e27ef750377ffb7748c7"
    sha256 arm64_sonoma:  "cf34643fbdd5481f92294d8a4a4d90618f87972ab1994e966c4081e0d7e9b4bc"
    sha256 sonoma:        "6d063196b675e9b5c514d1425061c798cfe78bea4f0a5704e44e4d9302e692c8"
    sha256 arm64_linux:   "b949a958992ca6cdd90fd3c0540f0cff78f52e459b8b73abab8210f39f85e9ea"
    sha256 x86_64_linux:  "c3dfdd9e92e870c396b53d2bdf3f410b4b5369386e467186e4b4fa86214ea02d"
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
    (prefix/Language::Python.site_packages(python3)).install_symlink lib.glob("svn-python/*")

    system "make", "swig-pl-lib"
    system "make", "install-swig-pl-lib"
    cd "subversion/bindings/swig/perl/native" do
      args = OS.mac? ? ["INSTALLSITEMAN3DIR=#{man3}"] : ["INSTALLDIRS=vendor"]
      system perl, "Makefile.PL", "PREFIX=#{prefix}", *args
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

    perl = DevelopmentTools.locate("perl")
    if OS.mac?
      perl_version = Utils.safe_popen_read(perl.to_s, "--version")[/v(\d+\.\d+(?:\.\d+)?)/, 1]
      ENV["PERL5LIB"] = "#{lib}/perl5/site_perl/#{perl_version}/darwin-thread-multi-2level"
    end
    system perl, "-e", "use SVN::Client; new SVN::Client()"

    system python3, "-c", "import svn.client, svn.repos"
  end
end
