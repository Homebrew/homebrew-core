class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/sip/4.19.25/sip-4.19.25.tar.gz"
  sha256 "b39d93e937647807bac23579edbff25fe46d16213f708370072574ab1f1b4211"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  livecheck do
    url "https://riverbankcomputing.com/software/sip/download"
    regex(/href=.*?sip[._-]v?(\d+(\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "71ce74e4246ef979c64023470b0d5d6d33cf108bbedc3d7423c410b145444971"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f80f89a34ee8addbefe89fc8a858e25f374e4bb35f989b6e00f6f5d9a91e5a1"
    sha256 cellar: :any_skip_relocation, catalina:      "e6d4c1765eee476b786dc0f4d42f207df4f44210b70874ee6ba6f7538f2cd56f"
    sha256 cellar: :any_skip_relocation, mojave:        "9381bd79e617700717fe0e915df652ec5d223171be3edf760580df1529fc2b8f"
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
