class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch"
  url "https://root.cern.ch/download/root_v6.12.04.source.tar.gz"
  version "6.12.04"
  sha256 "f438f2ae6e25496fa81df525935fb0bf2a403855d95c40b3e0f3a3e1e861a085"
  revision 1

  head "http://root.cern.ch/git/root.git"

  bottle do
    sha256 "d4955129369da03358bdc3e6ea0767cfc150b0cd116f0c034cb1256f7e77bc62" => :high_sierra
    sha256 "a46826ce377196223ffda513b18ea6ebca13980fb21efa5b8d78c198d51dfb07" => :sierra
    sha256 "745de6cc7d93fc83e3609a3dbfc21a98c520a29d5961cf15e17374080ab83c49" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran.
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "xrootd"
  depends_on "xz" # For LZMA.
  depends_on "python" => :recommended
  depends_on "python3" => :optional

  needs :cxx11

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
      -Dgnuinstall=ON
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -Dbuiltin_freetype=ON
      -Dfftw3=ON
      -Dfortran=ON
      -Dgdml=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Dmysql=OFF
      -Droofit=ON
      -Dssl=ON
      -Dxrootd=ON
    ]

    if build.with?("python3") && build.with?("python")
      odie "Root: Does not support building both python 2 and 3 wrappers"
    elsif build.with?("python") || build.with?("python3")
      if build.with? "python"
        ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
        python_executable = Utils.popen_read("which python").strip
        python_version = Language::Python.major_minor_version("python")
      elsif build.with? "python3"
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
      system "python2", "-c", "import ROOT"
    end
  end
end
