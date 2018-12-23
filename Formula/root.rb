class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch/"
  url "https://root.cern.ch/download/root_v6.14.06.source.tar.gz"
  version "6.14.06"
  sha256 "0fb943b61396f282b289e35c455a9ab60126229be1bd3f04a8f00b37c13ab432"
  head "https://github.com/root-project/root.git"

  bottle do
    sha256 "d2ba62a7e1a888db4ce32e26217335c101b926e5b2748f218c95c32f409eaf29" => :mojave
    sha256 "740f87c0c8709ee8b84c72bdf076cbd289ec2f65df553564d70d9f7e6af3615d" => :high_sierra
    sha256 "b577e12850f46851f8a8066b006cae307af559ba96015d9d98f07b257d1f375a" => :sierra
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
  depends_on "davix"
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "gsl"
  # Temporarily depend on Homebrew libxml2 to work around a brew issue:
  # https://github.com/Homebrew/brew/issues/5068
  depends_on "libxml2" if MacOS.version >= :mojave
  depends_on "lz4"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "python"
  depends_on "tbb"
  depends_on "xrootd"
  depends_on "xz" # for LZMA

  skip_clean "bin"

  needs :cxx11

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

    py_exe = Utils.popen_read("which python3").strip
    py_prefix = Utils.popen_read("python3 -c 'import sys;print(sys.prefix)'").chomp
    py_inc = Utils.popen_read("python3 -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'").chomp

    args = std_cmake_args + %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{py_exe}
      -DPYTHON_INCLUDE_DIR=#{py_inc}
      -DPYTHON_LIBRARY=#{py_prefix}/Python
      -Dbuiltin_cfitsio=OFF
      -Dbuiltin_freetype=ON
      -Ddavix=ON
      -Dfftw3=ON
      -Dfitsio=OFF
      -Dfortran=ON
      -Dgdml=ON
      -Dgnuinstall=ON
      -Dimt=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Dmysql=OFF
      -Dpgsql=OFF
      -Dpython=ON
      -Droofit=ON
      -Dssl=ON
      -Dtmva=ON
      -Dxrootd=ON
    ]

    mkdir "builddir" do
      system "cmake", "..", *args

      # Work around superenv stripping out isysroot leading to errors with
      # libsystem_symptoms.dylib (only available on >= 10.12) and
      # libsystem_darwin.dylib (only available on >= 10.13)
      if MacOS.version < :high_sierra
        system "xcrun", "make", "install"
      else
        system "make", "install"
      end

      chmod 0755, Dir[bin/"*.*sh"]
    end
  end

  def caveats; <<~EOS
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For bash users:
      . #{HOMEBREW_PREFIX}/bin/thisroot.sh
    For zsh users:
      pushd #{HOMEBREW_PREFIX} >/dev/null; . bin/thisroot.sh; popd >/dev/null
    For csh/tcsh users:
      source #{HOMEBREW_PREFIX}/bin/thisroot.csh
  EOS
  end

  test do
    (testpath/"test.C").write <<~EOS
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS
    (testpath/"test.bash").write <<~EOS
      . #{bin}/thisroot.sh
      root -l -b -n -q test.C
    EOS
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("/bin/bash test.bash")

    # Test Python module
    ENV["PYTHONPATH"] = lib/"root"
    system "python3", "-c", "import ROOT"
  end
end
