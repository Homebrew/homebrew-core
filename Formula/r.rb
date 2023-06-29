class R < Formula
  desc "Software environment for statistical computing"
  homepage "https://www.r-project.org/"
  url "https://cran.r-project.org/src/base/R-4/R-4.3.1.tar.gz"
  sha256 "8dd0bf24f1023c6f618c3b317383d291b4a494f40d73b983ac22ffea99e4ba99"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://cran.rstudio.com/banner.shtml"
    regex(%r{href=(?:["']?|.*?/)R[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "03572aa09e9d6e8ed06dde44121aae8fe6a28940c3c62d9e054ab17e688de796"
    sha256 arm64_monterey: "38f64327801c7477652fdcb0e5d2d2445aa64702e6f88385a8326ee74da98185"
    sha256 arm64_big_sur:  "b3400b4a83c742dc67a830ff89da9ca69a78a95b232d6adbd873ed8ce1e0dcab"
    sha256 ventura:        "371c52d60ab6b05a465117bb46caf5a30d215fbb06dec5102a52b3c87cdaf02c"
    sha256 monterey:       "29874a13f3db112cf2522b143b8bacf062df7faebfc0823b70a31840cc56536f"
    sha256 big_sur:        "542e95192e5357723d75072f67700d48ee139f7bcaf58fea769e4ea158cd313e"
    sha256 x86_64_linux:   "84e5cc4ff05da320cc75260a8c38f8171822a410261c1b6ef51b92b80d1513dd"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gcc" # for gfortran
  depends_on "gettext"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openblas"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "tcl-tk"
  depends_on "xz"

  uses_from_macos "curl"
  uses_from_macos "icu4c"
  uses_from_macos "libffi", since: :catalina

  on_linux do
    depends_on "libice"
    depends_on "libtirpc"
    depends_on "libx11"
    depends_on "libxt"
    depends_on "pango"
  end

  # needed to preserve executable permissions on files without shebangs
  skip_clean "lib/R/bin", "lib/R/doc"

  fails_with :gcc do
    version "11"
    cause "Unknown. FIXME."
  end

  def install
    # `configure` doesn't like curl 8+, but convince it that everything is ok.
    # TODO: report this upstream.
    ENV["r_cv_have_curl728"] = "yes"

    args = [
      "--prefix=#{prefix}",
      "--enable-memory-profiling",
      "--with-tcl-config=#{Formula["tcl-tk"].opt_lib}/tclConfig.sh",
      "--with-tk-config=#{Formula["tcl-tk"].opt_lib}/tkConfig.sh",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--enable-R-shlib",
      "--disable-java",
      "--with-cairo",
      # This isn't necessary to build R, but it's saved in Makeconf
      # and helps CRAN packages find gfortran when Homebrew may not be
      # in PATH (e.g. under RStudio, launched from Finder)
      "FC=#{Formula["gcc"].opt_bin}/gfortran",
    ]

    if OS.mac?
      args << "--without-x"
      args << "--with-aqua"
    else
      args << "--libdir=#{lib}" # avoid using lib64 on CentOS

      # Avoid references to homebrew shims
      args << "LD=ld"

      # If LDFLAGS contains any -L options, configure sets LD_LIBRARY_PATH to
      # search those directories. Remove -LHOMEBREW_PREFIX/lib from LDFLAGS.
      ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

      ENV.append "CPPFLAGS", "-I#{Formula["libtirpc"].opt_include}/tirpc"
      ENV.append "LDFLAGS", "-L#{Formula["libtirpc"].opt_lib}"
    end

    # Help CRAN packages find gettext and readline
    ["gettext", "readline", "xz"].each do |f|
      ENV.append "CPPFLAGS", "-I#{Formula[f].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula[f].opt_lib}"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize do
      system "make", "install"
    end

    cd "src/nmath/standalone" do
      system "make"
      ENV.deparallelize do
        system "make", "install"
      end
    end

    r_home = lib/"R"

    # make Homebrew packages discoverable for R CMD INSTALL
    inreplace r_home/"etc/Makeconf" do |s|
      s.gsub!(/^CPPFLAGS =.*/, "\\0 -I#{HOMEBREW_PREFIX}/include")
      s.gsub!(/^LDFLAGS =.*/, "\\0 -L#{HOMEBREW_PREFIX}/lib")
      s.gsub!(/.LDFLAGS =.*/, "\\0 $(LDFLAGS)")
    end

    include.install_symlink Dir[r_home/"include/*"]
    lib.install_symlink Dir[r_home/"lib/*"]

    # avoid triggering mandatory rebuilds of r when gcc is upgraded
    check_replace = OS.mac?
    inreplace lib/"R/etc/Makeconf", Formula["gcc"].prefix.realpath,
                                    Formula["gcc"].opt_prefix,
                                    check_replace
  end

  def post_install
    short_version = Utils.safe_popen_read(bin/"Rscript", "-e", "cat(as.character(getRversion()[1,1:2]))")
    site_library = HOMEBREW_PREFIX/"lib/R"/short_version/"site-library"
    site_library.mkpath
    touch site_library/".keepme"
    site_library_cellar = lib/"R/site-library"
    site_library_cellar.unlink if site_library_cellar.exist?
    site_library_cellar.parent.install_symlink site_library
  end

  test do
    assert_equal "[1] 2", shell_output("#{bin}/Rscript -e 'print(1+1)'").chomp
    assert_equal shared_library(""), shell_output("#{bin}/R CMD config DYLIB_EXT").chomp
    system bin/"Rscript", "-e", "if(!capabilities('cairo')) stop('cairo not available')"

    system bin/"Rscript", "-e", "install.packages('gss', '.', 'https://cloud.r-project.org')"
    assert_predicate testpath/"gss/libs/gss.so", :exist?,
                     "Failed to install gss package"

    winsys = "[1] \"aqua\""
    if OS.linux?
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      winsys = "[1] \"x11\""
    end
    assert_equal winsys,
                 shell_output("#{bin}/Rscript -e 'library(tcltk)' -e 'tclvalue(.Tcl(\"tk windowingsystem\"))'").chomp
  end
end
