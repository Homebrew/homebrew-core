class Tlx < Formula
  desc "Collection of Sophisticated C++ Data Structures, Algorithms and Helpers"
  homepage "https://tlx.github.io"
  url "https://github.com/tlx/tlx/archive/v0.5.20200222.tar.gz"
  sha256 "99e63691af3ada066682243f3a65cd6eb32700071cdd6cfedb18777b5ff5ff4d"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4a3813275fd74097015538e989b512c2e9c7e1bb770402a80a8fb02f49e897c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ca6c8f813d2992803a39d3c707c0d56f9a0d4c5e9ea1afdf5c28bd24c456408"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d08dae9b28680ddbdb24ef98a60110e743d72d702bf8df24eb0568eac35bb536"
    sha256 cellar: :any_skip_relocation, ventura:        "465d86f02ea70196195a307b1c15ed252912c4912f9a19dd1ef70f34e5f03a8a"
    sha256 cellar: :any_skip_relocation, monterey:       "5f0fa9dcfbeeac87aacadbe122cdd0c77cd1c78145acd55751c68689b178f157"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd7aca4d147c132cd31909e0e99f6eb6192d63ba98805d1ae5da6b7ea04826e1"
    sha256 cellar: :any_skip_relocation, catalina:       "c27858a2595d4fe9444821160e85aa6924fcc7194e13baadd5fda0b79252b9a1"
    sha256 cellar: :any_skip_relocation, mojave:         "5038cd9dff7968390f0e4208059c02a667fb9c3308ce88f444bd57ef60bd8895"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9a81855db3041742ac4e6ae96c3bc8bc9f15e0dc30436afbcbbf36bace3ef633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "317d28d9c3979d8bff510eebf3dfadd74c8d2e5239fb04f7c03fce41b45fc4bb"
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
