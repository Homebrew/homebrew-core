class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch"
  url "https://root.cern.ch/download/root_v6.14.00.source.tar.gz"
  version "6.14.00"
  sha256 "7946430373489310c2791ff7a3520e393dc059db1371272bcd9d9cf0df347a0b"
  revision 2
  head "http://root.cern.ch/git/root.git"

  bottle do
    sha256 "d21e759311b538c11f5ddf870ca676e23f8255628dd571f9af8c88c911a80b38" => :high_sierra
    sha256 "211c63b9860f5801d88e8f5a6c8a01eadcf4f31133e55a7d0099abe0a8881977" => :sierra
    sha256 "b35598bcca5c050ec6e410f56602433b010747add394cbf3c5019757c90bb78f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "davix"
  depends_on "fftw"
  depends_on "gcc" # for gfortran.
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "lz4"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "tbb"
  depends_on "xrootd"
  depends_on "xz" # For LZMA.
  depends_on "python" => :recommended
  depends_on "python@2" => :optional

  needs :cxx11

  skip_clean "bin"

  # Upstream PR from 30 Jun 2018 "Fixes for Python 3.7"
  patch do
    url "https://github.com/root-project/root/pull/2276.patch?full_index=1"
    sha256 "5c8e404a01b7df801c7fa6ec7c54d0ebfc0f46086b58f34340822e89fc67a750"
  end

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
      -Dgnuinstall=ON
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -Dbuiltin_freetype=ON
      -Dbuiltin_cfitsio=OFF
      -Ddavix=ON
      -Dfitsio=OFF
      -Dfftw3=ON
      -Dfortran=ON
      -Dgdml=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Dmysql=OFF
      -Dpgsql=OFF
      -Droofit=ON
      -Dssl=ON
      -Dimt=ON
      -Dxrootd=ON
    ]

    if build.with?("python") && build.with?("python@2")
      odie "Root: Does not support building both python 2 and 3 wrappers"
    elsif build.with?("python") || build.with?("python@2")
      if build.with? "python@2"
        ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"
        python_executable = Utils.popen_read("which python").strip
        python_version = Language::Python.major_minor_version("python")
      elsif build.with? "python"
        python_executable = Utils.popen_read("which python3").strip
        python_version = Language::Python.major_minor_version("python3")
      end

      python_prefix = Utils.popen_read("#{python_executable} -c 'import sys;print(sys.prefix)'").chomp
      python_include = Utils.popen_read("#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'").chomp
      args << "-Dpython=ON"

      # cmake picks up the system's python dylib, even if we have a brewed one
      if File.exist? "#{python_prefix}/Python"
        python_library = "#{python_prefix}/Python"
      elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
        python_library = "#{python_prefix}/lib/lib#{python_version}.a"
      elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.dylib"
        python_library = "#{python_prefix}/lib/lib#{python_version}.dylib"
      else
        odie "No libpythonX.Y.{a,dylib} file found!"
      end
      args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
      args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
      args << "-DPYTHON_LIBRARY='#{python_library}'"
    else
      args << "-Dpython=OFF"
    end

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

    if build.with? "python"
      ENV["PYTHONPATH"] = lib/"root"
      system "python3", "-c", "import ROOT"
    end
  end
end
