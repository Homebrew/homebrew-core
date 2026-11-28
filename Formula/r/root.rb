class Root < Formula
  desc "Analyzing petabytes of data, scientifically"
  homepage "https://github.com/root-project/root"
  url "https://github.com/root-project/root/releases/download/v6-42-00/root_v6.42.00.source.tar.gz"
  sha256 "9649ad16d5773bd05199eb5e3cca1580847a30c959e3e68c3717b471c154c4b2"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+-\d*[02468]-\d*[02468])$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    manifest_sha256 "8a47249b54bb1438674d3406a7efebcd3c2cc6ba3c77a4849d7d10a9911cc49c"
    sha256 arm64_golden_gate: "8dcb60d86809f034627b260032a735e0901b8b7eb4b6265827aaad9119e10a85"
    sha256 arm64_tahoe:       "c87d87a1b5ffb2b8e9d95ca297a92237081ee10a0ba5703d218b658813d82369"
    sha256 arm64_sequoia:     "f4faf5924b0fb03c02f58189517a11f2f890ab0b8ae3f9ce0633f25c96baa7ce"
    sha256 arm64_linux:       "dc154a6b99100dcf87525b6802e15c35ef640ede13e637e522a4a23506449951"
    sha256 x86_64_linux:      "807c5d6b81129a019af5817207b525d3b1494a619c37db05d2a5f7ea8f690f32"
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
  depends_on "lz4"
  depends_on "nlohmann-json" => :no_linkage
  depends_on "numpy" # for tmva
  depends_on "openblas"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "python@3.15"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on "unuran"
  depends_on "vdt"
  depends_on "xrootd"
  depends_on "xxhash"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  uses_from_macos "curl"
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

  def install
    args = %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_CXX_STANDARD=20
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{python3}
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
