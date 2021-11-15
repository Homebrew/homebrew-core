class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://github.com/google/s2geometry/archive/v0.9.0.tar.gz"
  sha256 "54c09b653f68929e8929bffa60ea568e26f3b4a51e1b1734f5c3c037f1d89062"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, monterey: "48041de390b83abe6f77dd9b624b99846a444643077885745ec2f6f1fa212b54"
    sha256 cellar: :any, big_sur:  "68903a12c6383cbfef68c89a82c224aa5f51fc7fb03cd416b67f395aa134c218"
    sha256 cellar: :any, catalina: "be6efced1d7d6339598aa104619fafb57b8f3b8f87837882369a17511a1d4800"
    sha256 cellar: :any, mojave:   "bb270713b3f271b75d992cd0bc76e594163c319104e9aac8ac58605dd7e31135"
  end

  depends_on "cmake" => :build
  depends_on "glog" => :build
  depends_on "googletest" => :build
  depends_on "openssl@1.1"

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV.append "CXXFLAGS", "-I#{Formula["googletest"].opt_include}"

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
