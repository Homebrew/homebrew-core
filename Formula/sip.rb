class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/sip/4.19.24/sip-4.19.24.tar.gz"
  sha256 "edcd3790bb01938191eef0f6117de0bf56d1136626c0ddb678f3a558d62e41e5"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  livecheck do
    url "https://riverbankcomputing.com/software/sip/download"
    regex(/href=.*?sip[._-]v?(\d+(\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8325e469dc8c267c526034ce3ea3bc014c3f66dc05471e0af81bef9725cdb671" => :big_sur
    sha256 "000960d8619e5dba18a9e5585e6eac8b9123977c448ea08024bf8fcab777d000" => :arm64_big_sur
    sha256 "20c9e0745b80d218317e81bb81227b513c59d84524ad6cf44439d446cb289616" => :catalina
    sha256 "5a64babc3b0e9058fce2b9963ef8193d6b8437de1d8119e43966b4ad42092590" => :mojave
    sha256 "c555ded74a09732751261cfe7cd243ceb69bed86f489df8a80cc4e6a5819220c" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_bin
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
                      "--sipdir=#{HOMEBREW_PREFIX}/share/sip",
                      "--sip-module", "PyQt5.sip"
    system "make"
    system "make", "install"
  end

  def post_install
    (HOMEBREW_PREFIX/"share/sip").mkpath
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

    system ENV.cxx, "-shared", "-Wl,-install_name,#{testpath}/libtest.dylib",
                    "-o", "libtest.dylib", "test.cpp"
    system bin/"sip", "-b", "test.build", "-c", ".", "test.sip"
  end
end
