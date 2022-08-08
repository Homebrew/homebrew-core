class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch/"
  url "https://root.cern.ch/download/root_v6.26.06.source.tar.gz"
  sha256 "b1f73c976a580a5c56c8c8a0152582a1dfc560b4dd80e1b7545237b65e6c89cb"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    url "https://root.cern/install/all_releases/"
    regex(%r{Release\s+v?(\d+(?:[./]\d*[02468])+)[ >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("/", ".") }
    end
  end

  bottle do
    sha256 arm64_monterey: "6768f3639e443c4b6bb4e6b6077fb34331656555993e0d4585b2a7f20efd991f"
    sha256 arm64_big_sur:  "34523f8f39f9c268b2bd275b36ec0c48d0d16135ad395bbd9dcc7f8380a23932"
    sha256 monterey:       "083c5bcb1f71f450e481d75b0094ae0988e90b10c70830610e0f969b4a2619c4"
    sha256 big_sur:        "70f913e146aaa74e76f60d886fa6587f2e61325c89da208afc44de6b195610bc"
    sha256 catalina:       "9aef2ca1bc210cfabe196290c7d663afb96d9e2f6730ed4818b272cc82ab1dc9"
    sha256 x86_64_linux:   "c3586902c56bfe0742602b8d6c7de509224cf841890a56921ccda2389d12cb3f"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "gl2ps"
  depends_on "glew"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "lz4"
  depends_on "mysql-client"
  depends_on "numpy" # for tmva
  depends_on "openblas"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.9"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on :xcode
  depends_on "xrootd"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxft"
    depends_on "libxpm"
  end

  skip_clean "bin"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/root"

    inreplace "cmake/modules/SearchInstalledSoftware.cmake" do |s|
      # Enforce secure downloads of vendored dependencies. These are
      # checksummed in the cmake file with sha256.
      s.gsub! "http://lcgpackages", "https://lcgpackages"
      # Patch out check that skips using brewed glew.
      s.gsub! "CMAKE_VERSION VERSION_GREATER 3.15", "CMAKE_VERSION VERSION_GREATER 99.99"
    end

    args = std_cmake_args + %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
      -DCMAKE_CXX_STANDARD=17
      -Dbuiltin_cfitsio=OFF
      -Dbuiltin_freetype=OFF
      -Dbuiltin_glew=OFF
      -Ddavix=ON
      -Dfftw3=ON
      -Dfitsio=ON
      -Dfortran=ON
      -Dgdml=ON
      -Dgnuinstall=ON
      -Dimt=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Dmysql=ON
      -Dpgsql=OFF
      -Dpyroot=ON
      -Droofit=ON
      -Dssl=ON
      -Dtmva=ON
      -Dxrootd=ON
      -GNinja
    ]

    # Homebrew now sets CMAKE_INSTALL_LIBDIR to /lib, which is incorrect
    # for ROOT with gnuinstall, so we set it back here.
    args << "-DCMAKE_INSTALL_LIBDIR=lib/root"

    # Workaround the shim directory being embedded into the output
    inreplace "build/unix/compiledata.sh", "`type -path $CXX`", ENV.cxx

    mkdir "builddir" do
      system "cmake", "..", *args
      system "ninja", "install"

      chmod 0755, Dir[bin/"*.*sh"]

      version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
      pth_contents = "import site; site.addsitedir('#{lib}/root')\n"
      (prefix/"lib/python#{version}/site-packages/homebrew-root.pth").write pth_contents
    end
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
    system "#{bin}/root", "-b", "-l", "-q", "-e", "gSystem->LoadAllLibraries(); 0"

    # Test ROOT executable
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("root -l -b -n -q test.C")

    # Test linking
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <TString.h>
      int main() {
        std::cout << TString("Hello, world!") << std::endl;
        return 0;
      }
    EOS
    flags = %w[cflags libs ldflags].map { |f| "$(root-config --#{f})" }
    flags << "-Wl,-rpath,#{lib}/root"
    shell_output("$(root-config --cxx) test.cpp #{flags.join(" ")}")
    assert_equal "Hello, world!\n", shell_output("./a.out")

    # Test Python module
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import ROOT; ROOT.gSystem.LoadAllLibraries()"
  end
end
