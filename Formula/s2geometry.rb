class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry.git"
  url "https://github.com/google/s2geometry/archive/v0.9.0-2019.02.11.00.tar.gz"
  version "0.9.0-2019.02.11.00"
  sha256 "226315d1b720c12e9209c21f084f0570a069a02bea624886b69816291506edff"

  depends_on "cmake" => :build
  depends_on "glog" => :build
  depends_on "ninja" => :build
  depends_on "openssl" => :build

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  def install
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl"].include

    (buildpath/"gtest").install resource "gtest"
    (buildpath/"gtest/googletest").cd do
      system "cmake", "."
      system "make"
    end
    ENV["CXXFLAGS"] = "-I../gtest/googletest/include"

    mkdir "build" do
      args = std_cmake_args
      args << "-DWITH_GLOG=1"
      args << "-DCMAKE_OSX_SYSROOT=/" unless MacOS::Xcode.installed?
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "s2testing"
      system "ninja", "install"
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
    system ENV.cxx, "test.cpp",
      "-std=c++11",
      "-L#{lib}", "-ls2", "-ls2testing",
      "-o", "test"
    system "./test"
  end
end
