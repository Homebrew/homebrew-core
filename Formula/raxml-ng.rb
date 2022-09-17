class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "1.1.0",
      revision: "9b8150852c21fd0caa764752797e17382fc03aa0"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 monterey:     "bc14e35183077c0a9bf381aea75f73d08e9acbf3c02e8285c558c4dc1ea4f42b"
    sha256 cellar: :any,                 big_sur:      "fff2eeb8aa6e98b22debfb85bbc87ada14144223ca252e5ece4a7197c1771adf"
    sha256 cellar: :any,                 catalina:     "14a55e52a083ded0b9c9c35778c73303f1d968a9826ac2049457a319ae823c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17a1c0ffcb195cdcf3d3ed4aa70f7de5b863452b3139e9b01851a3a25b939ef5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "open-mpi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # Backport ARM support. Remove in the next release.
  # Ref: https://github.com/amkozlov/raxml-ng/commit/6a8f3d98ba0243b9f1452e0f7aab928e45d59b6f
  on_arm do
    patch :DATA
    patch do
      url "https://github.com/xflouris/libpll-2/commit/201983d128aa34e658d145e99ad775f441b42197.patch?full_index=1"
      sha256 "6f14c55450567672aa7c2b82dcce19c6e00395f7f9b8ed7529a18b3030e70e16"
      directory "libs/pll-modules/libs/libpll"
    end
  end

  resource "homebrew-example" do
    url "https://sco.h-its.org/exelixis/resource/download/hands-on/dna.phy"
    sha256 "c2adc42823313831b97af76b3b1503b84573f10d9d0d563be5815cde0effe0c2"
  end

  def install
    args = std_cmake_args + ["-DUSE_GMP=ON"]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
    mkdir "build_mpi" do
      ENV["CC"] = "mpicc"
      ENV["CXX"] = "mpicxx"
      system "cmake", "..", *args, "-DUSE_MPI=ON", "-DRAXML_BINARY_NAME=raxml-ng-mpi"
      system "make", "install"
    end
  end

  test do
    testpath.install resource("homebrew-example")
    system "#{bin}/raxml-ng", "--msa", "dna.phy", "--start", "--model", "GTR"
  end
end

__END__
diff --git a/src/util/sysutil.cpp b/src/util/sysutil.cpp
index 8d6501f..cdc4c72 100644
--- a/src/util/sysutil.cpp
+++ b/src/util/sysutil.cpp
@@ -1,4 +1,4 @@
-#ifndef _WIN32
+#if (!defined(_WIN32) && !defined(__aarch64__))
 #include <cpuid.h>
 #endif
 #include <sys/time.h>
@@ -170,7 +170,9 @@ unsigned long sysutil_get_memtotal(bool ignore_errors)

 static void get_cpuid(int32_t out[4], int32_t x)
 {
-#ifdef _WIN32
+#ifdef __aarch64__
+// not supported
+#elif defined(_WIN32)
   __cpuid(out, x);
 #else
   __cpuid_count(x, 0, out[0], out[1], out[2], out[3]);
