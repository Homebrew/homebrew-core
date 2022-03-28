class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch/"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/root-project/root.git", branch: "master"

  stable do
    url "https://root.cern.ch/download/root_v6.26.00.source.tar.gz"
    sha256 "5fb9be71fdf0c0b5e5951f89c2f03fcb5e74291d043f6240fb86f5ca977d4b31"

    # ROOT 6.26.00 doesn't support installation in directories starting with a
    # dot (.linuxbrew, for example) - two commit merge
    patch do
      url "https://github.com/root-project/root/commit/6802514256e948582c26ad938c2c34f22b2d1bc3.patch?full_index=1"
      sha256 "7988fa9e842c821c9be681c0e783dc299ecc74805750a4323e2921da26e7fc5b"
    end
    patch do
      url "https://github.com/root-project/root/commit/efc67e432206771fe934ad7763529cf3621696a1.patch?full_index=1"
      sha256 "b3ca4e06abd9c69315433717ae3a75677d8175cb53b8731c93f655634df1e22c"
    end
  end

  livecheck do
    url "https://root.cern.ch/download/"
    regex(/href=.*?root[._-]v?(\d+(?:\.\d*[02468])+)\.source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ef02cb001110ae59b8b2ae762872260bfde1343468f55138953067f0c4a0af31"
    sha256 arm64_big_sur:  "1a4f2a4c76c8f4b5e3156cd93a8b711575e4c3fe5dfb48ba7e20a565f665cc88"
    sha256 monterey:       "d4178f39a5d0ab0929a53064f88c94f3f7aa425bcd85827a4b452633c6f5b677"
    sha256 big_sur:        "2152d73f05514fb43b8e752ac825177c543063de89fb75ff884d29acbb4a7660"
    sha256 catalina:       "3182efe7a1972bd95bd3a1639ef89042a587678ea278046d95ae950436554eed"
    sha256 x86_64_linux:   "6fd84e34aa4d53a951a8a802da84b8990ac95bd6d0ae6733fb2857dd60a79b66"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
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
      -Dbuiltin_freetype=ON
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
