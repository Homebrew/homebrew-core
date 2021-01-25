class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch/"
  url "https://root.cern.ch/download/root_v6.22.06.source.tar.gz"
  sha256 "c4688784a7e946cd10b311040b6cf0b2f75125a7520e04d1af0b746505911b57"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/root-project/root.git"

  livecheck do
    url "https://root.cern.ch/download/"
    regex(/href=.*?root[._-]v?(\d+(?:\.\d*[02468])+)\.source\.t/i)
  end

  bottle do
    sha256 "b3789e14153fb1ff967322a6fab0ce3f2248103e6d50d04ba7da1326411935a9" => :big_sur
    sha256 "3d01849d366be92882668a7c0a270371d50fa803c782d8ea4020800f37b7504d" => :catalina
    sha256 "7d9440901fb0440771ea3ca6906f53f8f3bba6610564fb47962890f955d40d40" => :mojave
  end

  # https://github.com/Homebrew/homebrew-core/issues/30726
  # strings libCling.so | grep Xcode:
  #  /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
  #  /Applications/Xcode.app/Contents/Developer
  pour_bottle? do
    reason "The bottle hardcodes locations inside Xcode.app"
    satisfy do
      MacOS::Xcode.installed? &&
        MacOS::Xcode.prefix.to_s.include?("/Applications/Xcode.app/")
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "gl2ps"
  depends_on "graphviz"
  depends_on "gsl"
  # Temporarily depend on Homebrew libxml2 to work around a brew issue:
  # https://github.com/Homebrew/brew/issues/5068
  depends_on "libxml2" if MacOS.version >= :mojave
  depends_on "lz4"
  depends_on "numpy" # for tmva
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.9"
  depends_on "tbb"
  depends_on "xrootd"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  conflicts_with "glew", because: "root ships its own copy of glew"

  skip_clean "bin"

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    # Freetype/afterimage/gl2ps/lz4 are vendored in the tarball, so are fine.
    # However, this is still permitting the build process to make remote
    # connections. As a hack, since upstream support it, we inreplace
    # this file to "encourage" the connection over HTTPS rather than HTTP.
    inreplace "cmake/modules/SearchInstalledSoftware.cmake",
              "http://lcgpackages",
              "https://lcgpackages"

    args = std_cmake_args + %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
      -Dbuiltin_cfitsio=OFF
      -Dbuiltin_freetype=ON
      -Dbuiltin_glew=ON
      -Ddavix=ON
      -Dfftw3=ON
      -Dfitsio=ON
      -Dfortran=ON
      -Dgdml=ON
      -Dgnuinstall=ON
      -Dimt=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Dmysql=OFF
      -Dpgsql=OFF
      -Dpyroot=ON
      -Droofit=ON
      -Dssl=ON
      -Dtmva=ON
      -Dxrootd=ON
      -GNinja
    ]

    cxx_version = (MacOS.version < :mojave) ? 14 : 17
    args << "-DCMAKE_CXX_STANDARD=#{cxx_version}"

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
    (testpath/"test_compile.bash").write <<~EOS
      $(root-config --cxx) $(root-config --cflags) $(root-config --libs) $(root-config --ldflags) test.cpp
      ./a.out
    EOS
    assert_equal "Hello, world!\n",
                 shell_output("/bin/bash test_compile.bash")

    # Test Python module
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import ROOT; ROOT.gSystem.LoadAllLibraries()"
  end
end
