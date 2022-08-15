class R < Formula
  desc "Software environment for statistical computing"
  homepage "https://www.r-project.org/"
  url "https://cran.r-project.org/src/base/R-4/R-4.2.1.tar.gz"
  sha256 "4d52db486d27848e54613d4ee977ad952ec08ce17807e1b525b10cd4436c643f"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://cran.rstudio.com/banner.shtml"
    regex(%r{href=(?:["']?|.*?/)R[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "08fc9805e886677b4e0541d25bbc68015a2ead9aa36c010a1fb497c2170083e7"
    sha256 arm64_big_sur:  "249105acf739d38431f7ef30734c088c473147e09b5c621d38464c1ab90d908d"
    sha256 monterey:       "f05ec76c9379def7c5f4d421a02187e1b8e502cf55b9495157198352c507bd11"
    sha256 big_sur:        "2e953482043fac8db10397769116111ed7119837c62315eddb219c1122540547"
    sha256 catalina:       "b545ae8ab4195f289ab3e1026632ba895f61d31c812791bb8cc6709c12385860"
    sha256 x86_64_linux:   "26f5b7ee26e2f94c802ebe8e882b1bb04c17e8322e8f93cbbfac6a5d80ab6c24"
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

  def install
    # BLAS detection fails with Xcode 12 due to missing prototype
    # https://bugs.r-project.org/bugzilla/show_bug.cgi?id=18024
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

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
    short_version =
      `#{bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
    site_library = HOMEBREW_PREFIX/"lib/R/#{short_version}/site-library"
    site_library.mkpath
    ln_s site_library, lib/"R/site-library"
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
