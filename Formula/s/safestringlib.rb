class Safestringlib < Formula
  desc "Safe string operations and memory routines"
  homepage "https://github.com/intel/safestringlib"
  url "https://github.com/intel/safestringlib/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "29a97a4f385172cd72326cb52e58b3b010c3148e741c7685ff3937d92ce516c8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cd1d353906b2f20fc6d9dfd6caedfdd1a04c8e993dbe563957bd9ca9877d0749"
    sha256 cellar: :any, arm64_sequoia: "e51be3a24f959119e11ae27daa5ae3f5903320fffa2141150bbfdeeabf5ebff5"
    sha256 cellar: :any, arm64_sonoma:  "46fa2365133925ea6837613dd177bae181b2baa411b3efe0c26ea18cc520f24a"
    sha256 cellar: :any, sonoma:        "a4d38d707d83c35c51828b319546b965d0038af18090cfdda745f0841fbf7e5f"
    sha256 cellar: :any, arm64_linux:   "966a660c303fa3a548b32709a65ef2837bee69a717b48c1f19e56d3fc09c9b03"
    sha256 cellar: :any, x86_64_linux:  "f6961d8a780e8574747673c2ab2ab52b8b670c49d11507dc2a2013bb20461fd0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <safe_lib.h>

      int main()
      {
        memzero_s(NULL, 1);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lsafestring_shared", "-o", "test"
    system "./test"
  end
end
