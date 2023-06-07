class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://github.com/google/s2geometry/archive/v0.10.0.tar.gz"
  sha256 "1c17b04f1ea20ed09a67a83151ddd5d8529716f509dde49a8190618d70532a3d"
  license "Apache-2.0"
  revision 4

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7c3d433e915ffd03e92c73b1d3be5e1cbf127041c6cedb761ea266831a9d0d57"
    sha256 cellar: :any,                 arm64_monterey: "f5017d82e3624b783074ffc704819fb3c278ccce7b4f7749cba5f18c80de01d1"
    sha256 cellar: :any,                 arm64_big_sur:  "3b4b5686c10ebddf04b5faa31520c8f80f91e0457596cad877b8ca123b5b2411"
    sha256 cellar: :any,                 ventura:        "c8521cc65e3e8de4ecd1080a7e6186f03e90696bdd09176effc21ef5af1cc4d2"
    sha256 cellar: :any,                 monterey:       "4a166d13c69aa0089127fd0c4b9a49f11007f85437649f4a0466c75113af0c79"
    sha256 cellar: :any,                 big_sur:        "ec151db9a713cf396de417583f4e2c72e77a200852d0bad3dfc76dedfa54baed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e929ca8b220797e1dac8396b1da10dac728f022d421072e43ef76e94583f73c"
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
