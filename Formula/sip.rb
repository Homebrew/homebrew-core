class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/sip/4.19.19/sip-4.19.19.tar.gz"
  sha256 "5436b61a78f48c7e8078e93a6b59453ad33780f80c644e5f3af39f94be1ede44"
  revision 3
  head "https://www.riverbankcomputing.com/hg/sip", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "1ef5a30819f19edb17a6a9713579d16df45444b73aee1a36064256c86ed8f6a7" => :catalina
    sha256 "522daae973dbc9459cc9d55a26af17fad7ce750ea4c07bb4ad23c99f24274a1b" => :mojave
    sha256 "bf79abc59421b46b43a95a87cb759c1178167d27e958850a1f625e52eb74461b" => :high_sierra
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
