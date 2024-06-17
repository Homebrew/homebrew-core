class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch/"
  url "https://root.cern.ch/download/root_v6.32.00.source.tar.gz"
  sha256 "12f203681a59041c474ce9523761e6f0e8861b3bee78df5f799a8db55189e5d2"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    url "https://root.cern/install/all_releases/"
    regex(%r{Release\s+v?(\d+(?:[./]\d*[02468])+)[ >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("/", ".") }
    end
  end

  bottle do
    sha256 arm64_sonoma:   "52ebc420074f1a2ed7b30f8368cac429a8a67a1fd426cc2a3768c5d63c521464"
    sha256 arm64_ventura:  "c05213a6b1064a19f671198858c01e0cd378adcec0260383a466e03219713d7b"
    sha256 arm64_monterey: "0ed9d2882a2262eaca2ff0548695a6a79e2d75b1e2a48393f6bf5677012d18bf"
    sha256 sonoma:         "4ce7d5c42529d183e8780aa5c5ff24655c5de70ee230a0476ed6b1ed775800dc"
    sha256 ventura:        "e487717828953c9ea55c856ea3d837aed6d65afd37b2c629caf18e001b7a621e"
    sha256 monterey:       "fcb48b17b9d52fded67e53f110487f97865a1f364be3f6a4ee1b10ba04880079"
    sha256 x86_64_linux:   "486c338e22ac7351b57bb836ef32d63de36a95c81708886951b0252972951d93"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "gcc" # for gfortran
  depends_on "gl2ps"
  depends_on "glew"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "lz4"
  depends_on "mysql-client"
  depends_on "nlohmann-json"
  depends_on "numpy" # for tmva
  depends_on "openblas"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on :xcode
  depends_on "xrootd"
  depends_on "xxhash"
  depends_on "xz" # for LZMA
  depends_on "zlib"
  depends_on "zstd"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "giflib"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxft"
    depends_on "libxpm"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  skip_clean "bin"

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/root"
    ENV.remove "HOMEBREW_INCLUDE_PATHS", Formula["util-linux"].opt_include if OS.mac?

    inreplace "cmake/modules/SearchInstalledSoftware.cmake" do |s|
      # Enforce secure downloads of vendored dependencies. These are
      # checksummed in the cmake file with sha256.
      s.gsub! "http://lcgpackages", "https://lcgpackages"
      # Patch out check that skips using brewed glew.
      s.gsub! "CMAKE_VERSION VERSION_GREATER 3.15", "CMAKE_VERSION VERSION_GREATER 99.99"
    end

    args = std_cmake_args + %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DXROOTD_ROOT_DIR=#{Formula["xrootd"].opt_prefix}
      -Dbuiltin_afterimage=ON
      -Dbuiltin_cfitsio=OFF
      -Dbuiltin_clang=ON
      -Dbuiltin_cling=ON
      -Dbuiltin_cppzmq=OFF
      -Dbuiltin_davix=OFF
      -Dbuiltin_fftw3=OFF
      -Dbuiltin_freetype=OFF
      -Dbuiltin_ftgl=OFF
      -Dbuiltin_gl2ps=OFF
      -Dbuiltin_glew=OFF
      -Dbuiltin_gsl=OFF
      -Dbuiltin_llvm=ON
      -Dbuiltin_lz4=OFF
      -Dbuiltin_lzma=OFF
      -Dbuiltin_nlohmannjson=OFF
      -Dbuiltin_openssl=OFF
      -Dbuiltin_openui5=ON
      -Dbuiltin_pcre=OFF
      -Dbuiltin_tbb=OFF
      -Dbuiltin_unuran=OFF
      -Dbuiltin_vc=OFF
      -Dbuiltin_vdt=ON
      -Dbuiltin_veccore=OFF
      -Dbuiltin_xrootd=OFF
      -Dbuiltin_xxhash=OFF
      -Dbuiltin_zeromq=OFF
      -Dbuiltin_zlib=OFF
      -Dbuiltin_zstd=OFF
      -Dcfitsio=ON
      -Ddavix=ON
      -Ddev=OFF
      -Dfail-on-missing=ON
      -Dfftw3=ON
      -Dfitsio=ON
      -Dfortran=ON
      -Dfreetype=ON
      -Dgdml=ON
      -Dgfal=OFF
      -Dgnuinstall=ON
      -Dimt=ON
      -Dmathmore=ON
      -Dmysql=ON
      -Docaml=OFF
      -Doracle=OFF
      -Dpgsql=OFF
      -Dpyroot=ON
      -Dpythia6=OFF
      -Dpythia8=OFF
      -Droofit=ON
      -Dssl=ON
      -Dtmva=ON
      -Dvdt=ON
      -Dxrootd=ON
      -GNinja
    ]

    # Workaround the shim directory being embedded into the output
    inreplace "build/unix/compiledata.sh", "`type -path $CXX`", ENV.cxx

    # Homebrew now sets CMAKE_INSTALL_LIBDIR to /lib, which is incorrect
    # for ROOT with gnuinstall, so we set it back here.
    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args(install_libdir: "lib/root")
    system "cmake", "--build", "builddir"
    system "ctest", "-R", "tutorial-tree", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "builddir"
    system "cmake", "--install", "builddir"

    chmod 0755, bin.glob("*.*sh")

    pth_contents = "import site; site.addsitedir('#{lib}/root')\n"
    (prefix/Language::Python.site_packages(python3)/"homebrew-root.pth").write pth_contents
  end

  def caveats
    <<~EOS
      As of ROOT 6.22, you should not need the thisroot scripts; but if you
      depend on the custom variables set by them, you can still run them:

      For bash users:
        . #{HOMEBREW_PREFIX}/bin/thisroot.sh
      For zsh users:
        pushd #{HOMEBREW_PREFIX} >/dev/null; . bin/thisroot.sh; popd >/dev/null
      For csh/tcsh users:
        source #{HOMEBREW_PREFIX}/bin/thisroot.csh
      For fish users:
        . #{HOMEBREW_PREFIX}/bin/thisroot.fish
    EOS
  end

  test do
    (testpath/"test.C").write <<~EOS
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS

    # Test ROOT command line mode
    system bin/"root", "-b", "-l", "-q", "-e", "gSystem->LoadAllLibraries(); 0"

    # Test ROOT executable
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("#{bin}/root -l -b -n -q test.C")

    # Test ACLiC
    assert_equal "\nProcessing test.C+...\nHello, world!\n",
                 shell_output("#{bin}/root -l -b -n -q test.C+")

    # Test linking
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <TString.h>
      int main() {
        std::cout << TString("Hello, world!") << std::endl;
        return 0;
      }
    EOS
    flags = %w[cflags libs ldflags].map { |f| "$(#{bin}/root-config --#{f})" }
    flags << "-Wl,-rpath,#{lib}/root"
    shell_output("$(#{bin}/root-config --cxx) test.cpp #{flags.join(" ")}")
    assert_equal "Hello, world!\n", shell_output("./a.out")

    # Test Python module
    system python3, "-c", "import ROOT; ROOT.gSystem.LoadAllLibraries()"
  end
end
