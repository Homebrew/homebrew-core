class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry.git"
  url "https://github.com/google/s2geometry/archive/v0.9.0.tar.gz"
  sha256 "54c09b653f68929e8929bffa60ea568e26f3b4a51e1b1734f5c3c037f1d89062"
  revision 1

  bottle do
    cellar :any
    sha256 "8da23e65efaf589541edbc5175d660a25f77fe561638cec60aa2ac8bb060eb27" => :mojave
    sha256 "20ddf938193fdab274d143c291d1ace3fafc9805809fb8ee94f4268b614e6c59" => :high_sierra
    sha256 "88dab2878c97148b09b3bb611336ea1327e7c1b9cb2a98b429213a33a59160ae" => :sierra
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
