class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch"
  url "https://root.cern.ch/download/root_v6.10.04.source.tar.gz"
  version "6.10.04"
  sha256 "461bde21d78608422310f04c599e84ce8dfbdd91caf12c2a54db6c01f8228f5b"
  head "http://root.cern.ch/git/root.git"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "openssl"
  depends_on "xrootd"
  depends_on :fortran
  depends_on :python => :recommended
  depends_on :python3 => :optional

  needs :cxx11

  skip_clean "bin"

  def install
    args = std_cmake_args + %W[
      -Dgnuinstall=ON
      -DCMAKE_INSTALL_ELISPDIR=#{share}/emacs/site-lisp/#{name}
      -Dbuiltin_freetype=ON
      -Dfftw3=ON
      -Dfortran=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Droofit=ON
      -Dssl=ON
      -Dxrootd=ON
    ]

    if build.with?("python3") && build.with?("python")
      odie "Root: Does not support building both python 2 and 3 wrappers"
    elsif build.with?("python") || build.with?("python3")
      python_executable = `which python`.strip if build.with? "python"
      python_executable = `which python3`.strip if build.with? "python3"
      python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
      python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
      python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp

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
    end
    args << "-Dpython=" + (build.with?("python") ? "ON" : "OFF")
    args << "-Dpython3=" + (build.with?("python3") ? "ON" : "OFF")

    mkdir "builddir" do
      system "cmake", "..", *args
      system "make", "install"
      chmod 0755, Dir[bin/"*.*sh"]
    end
  end

  def caveats; <<-EOS.undent
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
    (testpath/"test.C").write <<-EOS.undent
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS
    (testpath/"test.bash").write <<-EOS.undent
      . #{bin}/thisroot.sh
      root -l -b -n -q test.C
    EOS
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("/bin/bash test.bash")
  end
end
