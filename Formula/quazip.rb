class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v1.1.tar.gz"
  sha256 "54edce9c11371762bd4f0003c2937b5d8806a2752dd9c0fd9085e90792612ad0"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_monterey: "8dfc18198f69a4c025127fc0843c08a029ec2cd433a0c81253a9f9fff9611bdd"
    sha256 cellar: :any, arm64_big_sur:  "1976479aab99b66660df7c4cb9cf5124885df1f4c579dea8d6efa019d3425139"
    sha256 cellar: :any, big_sur:        "343bb099db746afecb32ef268aeacf45522e67fe063975815cfb980ed1576fda"
    sha256 cellar: :any, catalina:       "cd85589dcc4e2f401000c786a57320a4773665c11992247a1065f6e23a4f70c0"
    sha256 cellar: :any, mojave:         "bab3b293744908346e3438f9ed49659b8be8594ab60dd1e0bc0c88864ea359d2"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt@5"

  def install
    system "cmake", ".", "-DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}", *std_cmake_args
    system "make"
    system "make", "install"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qt@5"].version.major}-#{version}/quazip" => "quazip"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lquazip#{version.major}-qt#{Formula["qt@5"].version.major}
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system "#{Formula["qt@5"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
