class Vdt < Formula
  desc "Math library of fast, approximate and vectorisable trascendental functions"
  homepage "https://github.com/dpiparo/vdt"
  url "https://github.com/dpiparo/vdt/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "1820feae446780763ec8bbb60a0dbcf3ae1ee548bdd01415b1fb905fd4f90c54"
  license "LGPL-3.0-or-later"
  head "https://github.com/dpiparo/vdt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dba33e62c7f2a02c6d0c12c9f6c6698f83217e6c3487daba6945e1a8f702fdff"
    sha256 cellar: :any, arm64_sequoia: "5430c565dff0459c09b20a89b3148c5f9e9561d4531618fdcf8efe456e087889"
    sha256 cellar: :any, arm64_sonoma:  "9a63cb2f1c99df9f158652f0b6c1a353d6855a5b7b7041c71415d39ae2871825"
    sha256 cellar: :any, sonoma:        "f62fe36d5368d6a73e8b652b264eb8c35514365b726dfb453f7a5da8644f2e06"
    sha256 cellar: :any, arm64_linux:   "e8db8af9e3fe52072fedf77791c45576148a6df7728ea267e98f2c8c22a6efdb"
    sha256 cellar: :any, x86_64_linux:  "4646f8d3d52213b75664b84f74304a43b748a58e1103269d3dcb2cd34312b7e6"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  def install
    # https://github.com/dpiparo/vdt/issues/21
    args = %w[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    args << "-DSSE=OFF" if Hardware::CPU.arm?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~C
      #include <vdt/cos.h>
      #include <cmath>
      int main() {
          return vdt::fast_cos(0.5) == std::cos(0.5) ? 0 : 1;
      }
    C
    system ENV.cxx, "test.cxx", "-L#{lib}", "-lvdt", "-o", "test"
    system "./test"
  end
end
