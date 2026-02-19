class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "https://leethomason.github.io/tinyxml2/"
  url "https://github.com/leethomason/tinyxml2/archive/refs/tags/11.0.0.tar.gz"
  sha256 "5556deb5081fb246ee92afae73efd943c889cef0cafea92b0b82422d6a18f289"
  license "Zlib"
  head "https://github.com/leethomason/tinyxml2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13273ba8306a9e264423051435f0af43915ab99d865a537e39bf4fb517e06c24"
    sha256 cellar: :any,                 arm64_sequoia: "547cd64f4a05b78839ba3b1aa14f062a0bfe39c54fe22d34229c729f5258fbd4"
    sha256 cellar: :any,                 arm64_sonoma:  "c2003e2db45283b198c1bdedde97f4802da748639ccf484d1bd88a7802bd6149"
    sha256 cellar: :any,                 arm64_ventura: "1e5668be8fa0aa9055dd729b63c8e588093e2ed7142f3f1987b646ede0cd46eb"
    sha256 cellar: :any,                 sonoma:        "7e9a788c39b407964a7c3fe4314597f9dcd79ccfb2e0285bed668400a683f656"
    sha256 cellar: :any,                 ventura:       "65a3ebdb7165567537c04c772f7bda89bf86c76aaeae1bed179807be0925b04f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7f5f7fc450393d4fc812c231db8b66464ee6f40be800b5e77bfb89ea819e6b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13c9eee32ef5d3a82e63177c56653c9514b179a4c07f42c4b1bccbae27e0670b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-Dtinyxml2_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2", "-o", "test"
    system "./test"
  end
end
