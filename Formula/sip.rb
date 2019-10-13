class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/sip/4.19.19/sip-4.19.19.tar.gz"
  sha256 "5436b61a78f48c7e8078e93a6b59453ad33780f80c644e5f3af39f94be1ede44"
  revision 1
  head "https://www.riverbankcomputing.com/hg/sip", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "ba3355ad200e1f9386171fcbf895fd57fb0fe63a450611942b822d5920296932" => :catalina
    sha256 "ce13e1599a99f64e0b76048fb6082359e6721a2455d172cb63391abbd08d7fc8" => :mojave
    sha256 "7d58704f2abdd6d07b69284c800f4ecd3096b8c4733aad77f4718b5083d728d1" => :high_sierra
  end

  depends_on "python"

  def install
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
    ENV.delete("SDKROOT") # Avoid picking up /Application/Xcode.app paths

    if build.head?
      # Link the Mercurial repository into the download directory so
      # build.py can use it to figure out a version number.
      ln_s cached_download/".hg", ".hg"
      # build.py doesn't run with python3
      system "python", "build.py", "prepare"
    end

    version = Language::Python.major_minor_version "python3"
    system "python3", "configure.py",
                      "--deployment-target=#{MacOS.version}",
                      "--destdir=#{lib}/python#{version}/site-packages",
                      "--bindir=#{bin}",
                      "--incdir=#{include}",
                      "--sipdir=#{HOMEBREW_PREFIX}/share/sip"
    system "make"
    system "make", "install"
    system "make", "clean"
  end

  def post_install
    (HOMEBREW_PREFIX/"share/sip").mkpath
  end

  def caveats; <<~EOS
    The sip-dir for Python is #{HOMEBREW_PREFIX}/share/sip.
  EOS
  end

  test do
    (testpath/"test.h").write <<~EOS
      #pragma once
      class Test {
      public:
        Test();
        void test();
      };
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "test.h"
      #include <iostream>
      Test::Test() {}
      void Test::test()
      {
        std::cout << "Hello World!" << std::endl;
      }
    EOS
    (testpath/"test.sip").write <<~EOS
      %Module test
      class Test {
      %TypeHeaderCode
      #include "test.h"
      %End
      public:
        Test();
        void test();
      };
    EOS
    (testpath/"generate.py").write <<~EOS
      from sipconfig import SIPModuleMakefile, Configuration
      m = SIPModuleMakefile(Configuration(), "test.build")
      m.extra_libs = ["test"]
      m.extra_lib_dirs = ["."]
      m.generate()
    EOS
    (testpath/"run.py").write <<~EOS
      from test import Test
      t = Test()
      t.test()
    EOS
    system ENV.cxx, "-shared", "-Wl,-install_name,#{testpath}/libtest.dylib",
                    "-o", "libtest.dylib", "test.cpp"
    system bin/"sip", "-b", "test.build", "-c", ".", "test.sip"

    version = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"
    system "python3", "generate.py"
    system "make", "-j1", "clean", "all"
    system "python3", "run.py"
  end
end
