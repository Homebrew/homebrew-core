class Tlx < Formula
  desc "Collection of Sophisticated C++ Data Structures, Algorithms and Helpers"
  homepage "https://tlx.github.io"
  url "https://github.com/tlx/tlx/archive/v0.5.20191212.tar.gz"
  sha256 "5e67d3042a390dbb831b6d46437e3c7fadf738bff362aa7376b210b10ecd532d"

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
