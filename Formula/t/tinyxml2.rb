class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "https://leethomason.github.io/tinyxml2/"
  url "https://github.com/leethomason/tinyxml2/archive/refs/tags/10.0.0.tar.gz"
  sha256 "3bdf15128ba16686e69bce256cc468e76c7b94ff2c7f391cc5ec09e40bff3839"
  license "Zlib"
  head "https://github.com/leethomason/tinyxml2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b1381b9a6caaa5ef675098d7d1b8eb6bf3d9db3cfa9fac81583096587a6eaa21"
    sha256 cellar: :any,                 arm64_sonoma:   "06a3ca5d84a41d897f5d303d2484f343ba516531a0efb596a1b4bbfe0743024c"
    sha256 cellar: :any,                 arm64_ventura:  "21ff74d7f6c4c49c53b68a0740a570dbd3867ec9d77c5f025b4a87813f19abe5"
    sha256 cellar: :any,                 arm64_monterey: "47b57551b8a816d40ee5c0f63e9293b8a9cf29f4c14dcb3bfb972715a24612bf"
    sha256 cellar: :any,                 sonoma:         "73eb82df5d628a8ace54ff37ec4e46d5afdaf7815a6d3008c298857d6e928d82"
    sha256 cellar: :any,                 ventura:        "6e21df3cebd2648c87b89d4476189d68faab14ec314e151262facc3a90bb7ccb"
    sha256 cellar: :any,                 monterey:       "ede0c2a39f7278272a57040f653cee188899ecc26360cc1063227846e8ba566d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75dbe5e041fef9e70a8770ada43b74cd327d1806f4fac459665d967af937e6c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-Dtinyxml2_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2", "-o", "test"
    system "./test"
  end
end
