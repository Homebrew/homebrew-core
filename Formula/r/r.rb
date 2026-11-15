class R < Formula
  desc "Software environment for statistical computing"
  homepage "https://www.r-project.org/"
  url "https://cran.r-project.org/src/base/R-4/R-4.6.2.tar.gz"
  sha256 "c297040f6392b1dac6e5c0eb398422cfdaedf540ae2205edb9ad0d10cb10ee00"
  license "GPL-2.0-or-later"
  compatibility_version 2

  livecheck do
    url "https://cran.rstudio.com/banner.shtml"
    regex(%r{href=(?:["']?|.*?/)R[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "cf990e2739ad2d52c02563a3016b70423489733c35eddd6432c333393c947b2e"
    sha256 arm64_tahoe:       "cf6f4ae138301d670a64a1d73e663cb6efeab416c2590878d0c74f7a4be0368b"
    sha256 arm64_sequoia:     "693465d972470df591d0badb722aa2d647519dc38000973a1bec8ce20cfa3ab9"
    sha256 arm64_linux:       "b8c4dc4642336ac31c6ae35847f2ff20c71e6cc4e88d808144f26c965d2a3f25"
    sha256 x86_64_linux:      "aac2321bae195fb93c24e4395f3d79b99940948d82a3e6363359b06a8ce6e714"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gcc" # for gfortran
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "openblas"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "tcl-tk"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_macos do
    depends_on "brotli"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "libxau"
    depends_on "libxcb"
    depends_on "libxdmcp"
    depends_on "libxext"
    depends_on "libxrender"
    depends_on "pixman"
  end

  on_linux do
    depends_on "glib"
    depends_on "icu4c@79"
    depends_on "libtirpc"
    depends_on "libxt"
    depends_on "pango"
    depends_on "zlib-ng-compat"
  end

  # needed to preserve executable permissions on files without shebangs
  skip_clean "lib/R/bin", "lib/R/doc"
  skip_clean "lib/R/site-library"

  allow_network_access! :test

  def install
    # `configure` doesn't like curl 8+, but convince it that everything is ok.
    # TODO: report this upstream.
    ENV["r_cv_have_curl728"] = "yes"

    args = [
      "--prefix=#{prefix}",
      "--enable-memory-profiling",
      "--with-tcl-config=#{formula_opt_lib("tcl-tk")}/tclConfig.sh",
      "--with-tk-config=#{formula_opt_lib("tcl-tk")}/tkConfig.sh",
      "--with-blas=-L#{formula_opt_lib("openblas")} -lopenblas",
      "--enable-R-shlib",
      "--disable-java",
      "--with-cairo",
      # This isn't necessary to build R, but it's saved in Makeconf
      # and helps CRAN packages find gfortran when Homebrew may not be
      # in PATH (e.g. under RStudio, launched from Finder)
      "FC=#{formula_opt_bin("gcc")}/gfortran",
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

      ENV.append "CPPFLAGS", "-I#{formula_opt_include("libtirpc")}/tirpc"
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("libtirpc")}"
    end

    # Help CRAN packages find gettext and readline
    %w[gettext readline xz].each do |f|
      ENV.append "CPPFLAGS", "-I#{formula_opt_include(f)}"
      ENV.append "LDFLAGS", "-L#{formula_opt_lib(f)}"
    end

    ENV["TZ"] = "UTC"
    system "./configure", *args
    system "make"
    ENV.deparallelize do
      system "make", "install"
    end

    system "make", "-C", "src/nmath/standalone"
    ENV.deparallelize do
      system "make", "-C", "src/nmath/standalone", "install"
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
    inreplace lib/"R/etc/Makeconf", Formula["gcc"].prefix.realpath,
                                    formula_opt_prefix("gcc"),
                                    audit_result: OS.mac?

    # `lib/R` is a :mkpath link directory
    short_version = Utils.safe_popen_read(bin/"Rscript", "-e", "cat(as.character(getRversion()[1,1:2]))")
    site_library = lib/"R"/short_version/"site-library"
    site_library.mkpath
    touch site_library/".keepme"
    site_library_cellar = lib/"R/site-library"
    site_library_cellar.parent.install_symlink HOMEBREW_PREFIX/"lib/R"/short_version/"site-library"
  end

  test do
    assert_equal "[1] 2", shell_output("#{bin}/Rscript -e 'print(1+1)'").chomp
    assert_equal shared_library(""), shell_output("#{bin}/R CMD config DYLIB_EXT").chomp
    system bin/"Rscript", "-e", "if(!capabilities('cairo')) stop('cairo not available')"

    system bin/"Rscript", "-e", "install.packages('gss', '.', 'https://cloud.r-project.org')"
    assert_path_exists testpath/"gss/libs/gss.so", "Failed to install gss package"

    winsys = "[1] \"aqua\""
    if OS.linux?
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      winsys = "[1] \"x11\""
    end
    assert_equal winsys,
                 shell_output("#{bin}/Rscript -e 'library(tcltk)' -e 'tclvalue(.Tcl(\"tk windowingsystem\"))'").chomp
  end
end
