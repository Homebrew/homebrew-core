class Subversion < Formula
  desc "Version control system designed to be a better CVS"
  homepage "https://subversion.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=subversion/subversion-1.15.0.tar.bz2"
  mirror "https://archive.apache.org/dist/subversion/subversion-1.15.0.tar.bz2"
  sha256 "dfb7b1e5270c7def971ccbd5938b0c03b1b5bd60b6674a2d8a74a9560839fb8c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "e57dec28a5f11bcf11f8ba204a4067dd831097ce3087fae3d621756b670dd48a"
    sha256 arm64_tahoe:       "33e911ec83ea6db1147065875c787523253c281340ab5c83536a4d105c9d6f3c"
    sha256 arm64_sequoia:     "560f093e7676d74f8f503463c870706b28ec109cb8980ce6e818306aceb55aa2"
    sha256 arm64_linux:       "dd6488e77bc63167748bef73f18ecb415118e13f6662d8ec73fa5da2bdef29f8"
    sha256 x86_64_linux:      "bb1b3c72ad3a545d05f9b1674b4a822177675e2a32909254460ac5ff570a9f7e"
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
  depends_on "python@3.15" => [:build, :test]
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
    depends_on "cyrus-sasl"
    depends_on "zlib-ng-compat"
  end

  resource "py3c" do
    url "https://github.com/encukou/py3c/archive/refs/tags/v1.4.tar.gz"
    sha256 "abc745079ef906148817f4472c3fb4bc41d62a9ea51a746b53e09819494ac006"

    livecheck do
      url :url
    end
  end

  def install
    py3c_prefix = buildpath/"py3c"
    resource("py3c").stage(py3c_prefix)

    # Use existing system zlib and sqlite
    if OS.mac?
      zlib = sqlite = MacOS.sdk_for_formula(self).path/"usr"
    else
      zlib = formula_opt_prefix("zlib")
      sqlite = formula_opt_prefix("sqlite")
    end

    perl = DevelopmentTools.locate("perl")
    ruby = DevelopmentTools.locate("ruby")

    args = %W[
      --enable-optimize
      --disable-mod-activation
      --disable-plaintext-password-storage
      --with-apr-util=#{formula_opt_prefix("apr-util")}
      --with-apr=#{formula_opt_prefix("apr")}
      --with-apxs=no
      --with-ruby-sitedir=#{lib}/ruby
      --with-py3c=#{py3c_prefix}
      --with-serf=#{formula_opt_prefix("apache-serf")}
      --with-sqlite=#{sqlite}
      --with-swig-perl=#{perl}
      --with-swig-python=#{python3}
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
