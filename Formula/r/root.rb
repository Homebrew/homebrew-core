class Root < Formula
  desc "Analyzing petabytes of data, scientifically"
  homepage "https://root.cern"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/root-project/root.git", branch: "master"

  stable do
    url "https://root.cern/download/root_v6.40.02.source.tar.gz"
    sha256 "f631eebee3dbea128f1415f4b784f5e83637a2b431193bce75f10385f71efc56"

    # Fix variable quoting for CMake>v4.4
    # Will be unnecessary as of root v6.40.04
    patch do
      url "https://github.com/root-project/root/commit/1cc376e3bf06ea54880fc4c14f0d3de6af82fdd3.patch?full_index=1"
      sha256 "a3651e7de6c6de2f75e7f2f26c8120763fca74b194c7e5ec43255f7242b507c2"
      type :backport
    end

    # Backport fix for PyROOT to use macOS libffi
    patch do
      url "https://github.com/root-project/root/commit/b2212ae8abdeb01eaed633b7ed243a72763f939d.patch?full_index=1"
      sha256 "9839dd1bc50635643fb4c8d69a52b60f7f8e2ae6721a8c57388eb860f3d48d91"
      type :backport
    end
  end

  livecheck do
    url "https://root.cern/install/all_releases/"
    regex(%r{Release\s+v?(\d+(?:[./]\d*[02468])+)[ >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("/", ".") }
    end
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "1295ee48e44d00747dc07060bac4150da63538b6b430b0aeca7573db8fe82900"
    sha256 arm64_sequoia: "c88684f23d01e226a495ad508bf29fb40b57094402c3cfb33384ef4173de6794"
    sha256 arm64_sonoma:  "97690b0cdaa2225f46df2ffae07a6d659ffe8769df7f9fba6b2c9e5c8f0d01d4"
    sha256 sonoma:        "6c05a5403658d07ce605a9e127a769afbf4382a3323f6c9cb86e6157f1f0fb91"
    sha256 arm64_linux:   "11585005870385af8d1c78b0895405add975a77a9a4234fc8af78433dbe1a38d"
    sha256 x86_64_linux:  "0945ac59403715af213ddba77742db60a85d785a7099411e1cf642316a0d76a1"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "civetweb"
  depends_on "davix"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "gcc" # for gfortran
  depends_on "giflib"
  depends_on "gl2ps"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "llvm@20"
  depends_on "lz4"
  depends_on "nlohmann-json" => :no_linkage
  depends_on "numpy" # for tmva
  depends_on "openblas"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.14"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on "unuran"
  depends_on "vdt"
  depends_on "xrootd"
  depends_on "xxhash"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_ventura :or_older do
    depends_on :xcode
  end

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxft"
    depends_on "libxpm"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  skip_clean "bin"

  def python3
    "python3.14"
  end

  def install
    # Skip modification of CLING_OSX_SYSROOT to the unversioned SDK path
    # Related: https://github.com/Homebrew/homebrew-core/issues/135714
    # Related: https://github.com/root-project/cling/issues/457
    if OS.mac? && MacOS.version > :ventura
      inreplace "interpreter/cling/lib/Interpreter/CMakeLists.txt", '"MacOSX[.0-9]+\.sdk"', '"SKIP"'
    end

    args = %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_CXX_STANDARD=20
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DXROOTD_ROOT_DIR=#{formula_opt_prefix("xrootd")}
      -Dbuiltin_cfitsio=OFF
      -Dbuiltin_civetweb=OFF
      -Dbuiltin_clang=ON
      -Dbuiltin_cling=ON
      -Dbuiltin_cppzmq=OFF
      -Dbuiltin_davix=OFF
      -Dbuiltin_fftw3=OFF
      -Dbuiltin_freetype=OFF
      -Dbuiltin_ftgl=OFF
      -Dbuiltin_gl2ps=OFF
      -Dbuiltin_gsl=OFF
      -Dbuiltin_llvm=OFF
      -Dbuiltin_lz4=OFF
      -Dbuiltin_lzma=OFF
      -Dbuiltin_nlohmannjson=OFF
      -Dbuiltin_openssl=OFF
      -Dbuiltin_openui5=ON
      -Dbuiltin_pcre=OFF
      -Dbuiltin_tbb=OFF
      -Dbuiltin_unuran=OFF
      -Dbuiltin_vc=OFF
      -Dbuiltin_vdt=OFF
      -Dbuiltin_xrootd=OFF
      -Dbuiltin_xxhash=OFF
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
      -Dgnuinstall=ON
      -Dimt=ON
      -Dmathmore=ON
      -Dpyroot=ON
      -Dpythia8=OFF
      -Droofit=ON
      -Dssl=ON
      -Dtmva=ON
      -Dunuran=ON
      -Dvdt=ON
      -Dxrootd=ON
      -GNinja
    ]

    # SetUpMacOS.cmake runs `lipo` on the make program, which fails on Homebrew's ninja shim.
    args << "-DCMAKE_MAKE_PROGRAM=#{formula_opt_bin("ninja")}/ninja"

    # Workaround the shim directory being embedded into the output
    inreplace "cmake/unix/compiledata.sh", "`type -path $CXX`", ENV.cxx

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
    <<~TEXT
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
    TEXT
  end

  test do
    (testpath/"test.C").write <<~CPP
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    CPP

    # Test ROOT command line mode
    system bin/"root", "-b", "-l", "-q", "-e", "gSystem->LoadAllLibraries(); 0"

    # Test ROOT executable
    assert_equal "Processing test.C...\nHello, world!\n",
                 shell_output("#{bin}/root -l -b -n -q test.C")

    # Test ACLiC
    assert_equal "Processing test.C+...\nHello, world!\n",
                 shell_output("#{bin}/root -l -b -n -q test.C+")

    # Test linking
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <TString.h>
      int main() {
        std::cout << TString("Hello, world!") << std::endl;
        return 0;
      }
    CPP
    flags = %w[cflags libs ldflags].map { |f| "$(#{bin}/root-config --#{f})" }
    flags << "-Wl,-rpath,#{lib}/root"
    shell_output("$(#{bin}/root-config --cxx) test.cpp #{flags.join(" ")}")
    assert_equal "Hello, world!\n", shell_output("./a.out")

    # Test Python module
    system python3, "-c", "import ROOT; ROOT.gSystem.LoadAllLibraries()"
  end
end
