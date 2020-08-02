class Tlx < Formula
  desc "Collection of Sophisticated C++ Data Structures, Algorithms and Helpers"
  homepage "https://tlx.github.io"
  url "https://github.com/tlx/tlx/archive/v0.5.20200222.tar.gz"
  sha256 "99e63691af3ada066682243f3a65cd6eb32700071cdd6cfedb18777b5ff5ff4d"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5feb247e39d672770af736845dcf642619eaef47816252f085a855e61479b258" => :catalina
    sha256 "d9306942815fa8499df14ad4e5de524acd0fb85ce3055ae344be4bce10720dfb" => :mojave
    sha256 "37a9d67e4cc9a36137d339bd7ebebcc2a351ff3bff631dd0d358db03cf8a6e2a" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + [".."]
    mkdir "build" do
      system "cmake", ".", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tlx/math/aggregate.hpp>
      int main()
      {
        tlx::Aggregate<int> agg;
        for (int i = 0; i < 30; ++i) {
          agg.add(i);
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltlx", "-o", "test", "-std=c++17"
    system "./test"
  end
end
