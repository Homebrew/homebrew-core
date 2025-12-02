class Root < Formula
  desc "Analyzing petabytes of data, scientifically"
  homepage "https://root.cern"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  stable do
    url "https://root.cern/download/root_v6.36.06.source.tar.gz"
    sha256 "62f9d38d2f2ed3d46653529c98e8cbc9b8866776494eb40ba0c23e2f46b681c4"

    # Backport part of https://github.com/root-project/root/commit/b2acf687d6b5f887b8f97f35d9b3b011adad5be4
    patch :DATA
  end

  livecheck do
    url "https://root.cern/install/all_releases/"
    regex(%r{Release\s+v?(\d+(?:[./]\d*[02468])+)[ >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("/", ".") }
    end
  end

  bottle do
    sha256 arm64_tahoe:   "fc6b42454754722d424d448d86566a6ba9d5640df7687fbcff76b913118465c6"
    sha256 arm64_sequoia: "d87ffd237d5d1da1101390fe23299b52728f6408611ebd44796a55987e3d52b8"
    sha256 arm64_sonoma:  "a68bd58a5f5004428d786e3078e08dc10e706f8c39cade5581c0fe74cd852bf7"
    sha256 sonoma:        "4a511e186dd8ed972be0a948bf951a9f225f9eef96eae72d83113e3a4f44016a"
    sha256 arm64_linux:   "46efd01341c7abd2ed38b63a00beec0410011b0206e5ae3492c92933619cf1a8"
    sha256 x86_64_linux:  "7a76d2f94ea851152653af7876ee4d27fce8997b04984ea37b49c8a8f85606c0"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "gcc" # for gfortran
  depends_on "giflib"
  depends_on "gl2ps"
  depends_on "glew"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "mariadb-connector-c"
  depends_on "nlohmann-json"
  depends_on "numpy" # for tmva
  depends_on "openblas"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.14"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on "xrootd"
  depends_on "xxhash"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
  end

  skip_clean "bin"

  def python3
    "python3.14"
  end

  def install
    # Workaround for CMake 4 due to VDT, https://github.com/dpiparo/vdt/blob/master/CMakeLists.txt
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    # Skip modification of CLING_OSX_SYSROOT to the unversioned SDK path
    # Related: https://github.com/Homebrew/homebrew-core/issues/135714
    # Related: https://github.com/root-project/cling/issues/457
    if OS.mac? && MacOS.version > :ventura
      inreplace "interpreter/cling/lib/Interpreter/CMakeLists.txt", '"MacOSX[.0-9]+\.sdk"', '"SKIP"'
    end

    inreplace "cmake/modules/SearchInstalledSoftware.cmake" do |s|
      # Enforce secure downloads of vendored dependencies. These are
      # checksummed in the cmake file with sha256.
      s.gsub! "http://lcgpackages", "https://lcgpackages"
      # Patch out check that skips using brewed glew.
      s.gsub! "CMAKE_VERSION VERSION_GREATER 3.15", "CMAKE_VERSION VERSION_GREATER 99.99"
    end

    args = %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DXROOTD_ROOT_DIR=#{Formula["xrootd"].opt_prefix}
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
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("#{bin}/root -l -b -n -q test.C")

    # Test ACLiC
    assert_equal "\nProcessing test.C+...\nHello, world!\n",
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

__END__
diff --git a/bindings/pyroot/cppyy/CPyCppyy/CMakeLists.txt b/bindings/pyroot/cppyy/CPyCppyy/CMakeLists.txt
index 911517294b..03406a9663 100644
--- a/bindings/pyroot/cppyy/CPyCppyy/CMakeLists.txt
+++ b/bindings/pyroot/cppyy/CPyCppyy/CMakeLists.txt
@@ -104,6 +104,11 @@ target_include_directories(${libname}
 
 set_property(GLOBAL APPEND PROPERTY ROOT_EXPORTED_TARGETS ${libname})
 
+if(NOT MSVC)
+  # Make sure that relative RUNPATH to main ROOT libraries is always correct.
+  ROOT_APPEND_LIBDIR_TO_INSTALL_RPATH(${libname} ${CMAKE_INSTALL_PYTHONDIR})
+endif()
+
 # Install library
 install(TARGETS ${libname} EXPORT ${CMAKE_PROJECT_NAME}Exports
                             RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT libraries
diff --git a/bindings/pyroot/cppyy/cppyy-backend/CMakeLists.txt b/bindings/pyroot/cppyy/cppyy-backend/CMakeLists.txt
index f296f3886d..25862bfa44 100644
--- a/bindings/pyroot/cppyy/cppyy-backend/CMakeLists.txt
+++ b/bindings/pyroot/cppyy/cppyy-backend/CMakeLists.txt
@@ -38,6 +38,11 @@ add_dependencies(${libname} move_headers)
 
 set_property(GLOBAL APPEND PROPERTY ROOT_EXPORTED_TARGETS ${libname})
 
+if(NOT MSVC)
+  # Make sure that relative RUNPATH to main ROOT libraries is always correct.
+  ROOT_APPEND_LIBDIR_TO_INSTALL_RPATH(${libname} ${CMAKE_INSTALL_PYTHONDIR})
+endif()
+
 # Install library
 install(TARGETS ${libname} EXPORT ${CMAKE_PROJECT_NAME}Exports
                             RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT libraries
diff --git a/bindings/pyroot/pythonizations/CMakeLists.txt b/bindings/pyroot/pythonizations/CMakeLists.txt
index e222e04c0e..30ef38edd9 100644
--- a/bindings/pyroot/pythonizations/CMakeLists.txt
+++ b/bindings/pyroot/pythonizations/CMakeLists.txt
@@ -210,6 +210,11 @@ endforeach()
 add_library(PyROOT INTERFACE)
 target_link_libraries(PyROOT INTERFACE cppyy_backend cppyy ROOTPythonizations)
 
+if(NOT MSVC)
+  # Make sure that relative RUNPATH to main ROOT libraries is always correct.
+  ROOT_APPEND_LIBDIR_TO_INSTALL_RPATH(${libname} ${CMAKE_INSTALL_PYTHONDIR})
+endif()
+
 # Install library
 install(TARGETS ${libname} EXPORT ${CMAKE_PROJECT_NAME}Exports
                             RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT libraries
