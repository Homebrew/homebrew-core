class R < Formula
  desc "Software environment for statistical computing"
  homepage "https://www.r-project.org/"
  url "https://cran.r-project.org/src/base/R-4/R-4.5.3.tar.gz"
  sha256 "aa5c1ed4293c7271ac513d654670356ac0e8a6ad5e42be014365d11150b5b8f2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://cran.rstudio.com/banner.shtml"
    regex(%r{href=(?:["']?|.*?/)R[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "105e5063aac542e22cb7a719388b6dd561b0c78ac267559a86c6f06b23860c04"
    sha256 arm64_sequoia: "e6f0ee355146c44928260519c57ebe2df2dc5989a35a8b759c8777a5657ecc91"
    sha256 arm64_sonoma:  "683d06da1605257d59d4c73f8ebd554bae2ada95ab78514a6c3447d3eea430f5"
    sha256 sonoma:        "3e0eda8d501baebbb69ca33c5acc5d338db7b27f31121adac1e983b5542061b3"
    sha256 arm64_linux:   "41c89f763f71a180f6fc5044cd4a57eb413582d7b576159bf1798be84c52076b"
    sha256 x86_64_linux:  "dce56d2b881ae1297a7502b0c5753577a6742aa8cdf6be14229244f24f968c26"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gcc" # for gfortran
  depends_on "gettext"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libxext"
  depends_on "openblas"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "tcl-tk"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libffi"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "libxau"
    depends_on "libxcb"
    depends_on "libxdmcp"
    depends_on "libxrender"
    depends_on "pixman"
  end

  on_linux do
    depends_on "glib"
    depends_on "harfbuzz"
    depends_on "icu4c@78"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libtirpc"
    depends_on "libx11"
    depends_on "libxt"
    depends_on "pango"
    depends_on "zlib-ng-compat"
  end

  # needed to preserve executable permissions on files without shebangs
  skip_clean "lib/R/bin", "lib/R/doc"

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
                                    Formula["gcc"].opt_prefix,
                                    audit_result: OS.mac?
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
