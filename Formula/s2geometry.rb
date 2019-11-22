class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry.git"
  url "https://github.com/google/s2geometry/archive/v0.9.0.tar.gz"
  sha256 "54c09b653f68929e8929bffa60ea568e26f3b4a51e1b1734f5c3c037f1d89062"
  revision 1

  bottle do
    cellar :any
    sha256 "69e0912c7a35acdcd926fa997e0c7e37ee1b8908f113b0d5a6ccc80c1bbe020c" => :catalina
    sha256 "5ecc3866aa3ad158fbb42b3d1b545d5c69a1ad5f1d5a574ae902de320d28d073" => :mojave
    sha256 "cfdbc5dd02ab2ddd7561342f6c225c8de8c86b5dcbf321265e33d3296a8b66f1" => :high_sierra
    sha256 "870466f63d2da435da772eff61412ea7a474bd72234f9e14e61deb850223791b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "glog" => :build
  depends_on "openssl@1.1"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@1.1"].opt_prefix

    (buildpath/"gtest").install resource "gtest"
    (buildpath/"gtest/googletest").cd do
      system "cmake", "."
      system "make"
    end
    ENV["CXXFLAGS"] = "-I../gtest/googletest/include"

    args = std_cmake_args + %w[
      -DWITH_GLOG=1
      ..
    ]

    mkdir "build-shared" do
      system "cmake", *args
      system "make", "s2"
      lib.install "libs2.dylib"
    end
    mkdir "build" do
      system "cmake", *args, "-DBUILD_SHARED_LIBS=OFF",
                             "-DOPENSSL_USE_STATIC_LIBS=TRUE"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cinttypes>
      #include <cstdint>
      #include <cstdio>
      #include "s2/base/commandlineflags.h"
      #include "s2/s2earth.h"
      #include "s2/s1chord_angle.h"
      #include "s2/s2closest_point_query.h"
      #include "s2/s2point_index.h"
      #include "s2/s2testing.h"

      DEFINE_int32(num_index_points, 10000, "Number of points to index");
      DEFINE_int32(num_queries, 10000, "Number of queries");
      DEFINE_double(query_radius_km, 100, "Query radius in kilometers");

      int main(int argc, char **argv) {
        S2PointIndex<int> index;
        for (int i = 0; i < FLAGS_num_index_points; ++i) {
          index.Add(S2Testing::RandomPoint(), i);
        }

        S2ClosestPointQuery<int> query(&index);
        query.mutable_options()->set_max_distance(
            S1Angle::Radians(S2Earth::KmToRadians(FLAGS_query_radius_km)));

        int64_t num_found = 0;
        for (int i = 0; i < FLAGS_num_queries; ++i) {
          S2ClosestPointQuery<int>::PointTarget target(S2Testing::RandomPoint());
          num_found += query.FindClosestPoints(&target).size();
        }

        return  0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}",
                    "-ls2", "-ls2testing",
                    "-o", "test"
    system "./test"
  end
end
