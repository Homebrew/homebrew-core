class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://github.com/google/s2geometry/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1c17b04f1ea20ed09a67a83151ddd5d8529716f509dde49a8190618d70532a3d"
  license "Apache-2.0"
  revision 6

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80e9962267439af1de9f48231bf5fd2843f09825c62498f50bbd66290f3d3f9e"
    sha256 cellar: :any,                 arm64_ventura:  "97ede51316899c6f4f34dfe092c3b8ccec4276bb3b637c53c92e8b5be0fe45df"
    sha256 cellar: :any,                 arm64_monterey: "839e1ee4dbbf7bac0eef6584f509f01d3a2e311c1311b6a3b0665060b931ce56"
    sha256 cellar: :any,                 arm64_big_sur:  "261c1a2494e5a665d7412774939f9de44b13ec1c383471ca19dc670c23ed331c"
    sha256 cellar: :any,                 sonoma:         "11af3c270a33a4e54c50686bee8a518eebcf2d1beff675a761ca66888d633c19"
    sha256 cellar: :any,                 ventura:        "41574127892178f975b9288302a173d95531aa1660d3603ea097a8447b331a67"
    sha256 cellar: :any,                 monterey:       "c32c79613a93dddf1c44c1453d670cded5fb9a046388e7627f637d5bf19adc00"
    sha256 cellar: :any,                 big_sur:        "a132c68316515afc343b9edd8047786d53260ffc98569aa334a532885c74ba5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bc799fb810424ce3052a520c01f7ac7245c343efef46becb68ea383b1328e3d"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "glog"
  depends_on "openssl@3"

  fails_with gcc: "5" # C++17

  def install
    # Abseil is built with C++17 and s2geometry needs to use the same C++ standard.
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 11)", "set(CMAKE_CXX_STANDARD 17)"

    args = std_cmake_args + %W[
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_GFLAGS=1
      -DWITH_GLOG=1
    ]

    system "cmake", "-S", ".", "-B", "build/shared", *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args,
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DOPENSSL_USE_STATIC_LIBS=TRUE"
    system "cmake", "--build", "build/static"
    lib.install "build/static/libs2.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cinttypes>
      #include <cmath>
      #include <cstdint>
      #include <cstdio>
      #include "s2/base/commandlineflags.h"
      #include "s2/s2earth.h"
      #include "absl/flags/flag.h"
      #include "s2/s1chord_angle.h"
      #include "s2/s2closest_point_query.h"
      #include "s2/s2point_index.h"

      S2_DEFINE_int32(num_index_points, 10000, "Number of points to index");
      S2_DEFINE_int32(num_queries, 10000, "Number of queries");
      S2_DEFINE_double(query_radius_km, 100, "Query radius in kilometers");

      inline uint64 GetBits(int num_bits) {
        S2_DCHECK_GE(num_bits, 0);
        S2_DCHECK_LE(num_bits, 64);
        static const int RAND_BITS = 31;
        uint64 result = 0;
        for (int bits = 0; bits < num_bits; bits += RAND_BITS) {
          result = (result << RAND_BITS) + random();
        }
        if (num_bits < 64) {  // Not legal to shift by full bitwidth of type
          result &= ((1ULL << num_bits) - 1);
        }
        return result;
      }

      double RandDouble() {
        const int NUM_BITS = 53;
        return ldexp(GetBits(NUM_BITS), -NUM_BITS);
      }

      double UniformDouble(double min, double limit) {
        S2_DCHECK_LT(min, limit);
        return min + RandDouble() * (limit - min);
      }

      S2Point RandomPoint() {
        double x = UniformDouble(-1, 1);
        double y = UniformDouble(-1, 1);
        double z = UniformDouble(-1, 1);
        return S2Point(x, y, z).Normalize();
      }

      int main(int argc, char **argv) {
        S2PointIndex<int> index;
        for (int i = 0; i < absl::GetFlag(FLAGS_num_index_points); ++i) {
          index.Add(RandomPoint(), i);
        }

        S2ClosestPointQuery<int> query(&index);
        query.mutable_options()->set_max_distance(S1Angle::Radians(
          S2Earth::KmToRadians(absl::GetFlag(FLAGS_query_radius_km))));

        int64_t num_found = 0;
        for (int i = 0; i < absl::GetFlag(FLAGS_num_queries); ++i) {
          S2ClosestPointQuery<int>::PointTarget target(RandomPoint());
          num_found += query.FindClosestPoints(&target).size();
        }

        return  0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-ls2"
    system "./test"
  end
end
