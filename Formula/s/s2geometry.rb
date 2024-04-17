class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://github.com/google/s2geometry/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "bdbeb8ebdb88fa934257caf81bb44b55711617a3ab4fdec2c3cfd6cc31b61734"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4473959018f9e76b44ef6b3adc12101f0aca03e5db19ea98eeb04f51413adef8"
    sha256 cellar: :any,                 arm64_ventura:  "a17ecd18a4b8cbf9b899e7b320dcbda2af0c4ca99874269d8bed86088a2058ed"
    sha256 cellar: :any,                 arm64_monterey: "ea9898f2b559458212fbf91b19cab30c9972f52868ed697c08db6aba8942b291"
    sha256 cellar: :any,                 sonoma:         "43c00ad7f4bf3f4c03b69b134799c48b1d6e892dad77fdaa02e5853454b9bddd"
    sha256 cellar: :any,                 ventura:        "2ad449f93b20c81f8ea1e18b433ce4a419d291fa66296c916c5912eacb0d3c7c"
    sha256 cellar: :any,                 monterey:       "fac9f63cc28b59e4b4f9c0b952471fd39190e9bf57930bfa5834b68d07e257a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea0639e9d5429a205b6f0274a5f52485c2e601767c62bbc7549b8ec2cc14b689"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "glog"
  depends_on "openssl@3"

  fails_with gcc: "5" # C++17

  def install
    args = %W[
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DBUILD_TESTS=OFF
      -DWITH_GFLAGS=1
      -DWITH_GLOG=1
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
    ]

    system "cmake", "-S", ".", "-B", "build/shared", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args,
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DOPENSSL_USE_STATIC_LIBS=TRUE",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libs2.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "s2/s2loop.h"
      #include "s2/s2polygon.h"
      #include "s2/s2latlng.h"

      #include <vector>
      #include <iostream>

      int main() {
          // Define the vertices of a polygon around a block near the Googleplex.
          std::vector<S2LatLng> lat_lngs = {
              S2LatLng::FromDegrees(37.422076, -122.084518),
              S2LatLng::FromDegrees(37.422003, -122.083984),
              S2LatLng::FromDegrees(37.421964, -122.084028),
              S2LatLng::FromDegrees(37.421847, -122.083171),
              S2LatLng::FromDegrees(37.422140, -122.083167),
              S2LatLng::FromDegrees(37.422076, -122.084518) // Last point equals the first one
          };

          std::vector<S2Point> points;
          for (const auto& ll : lat_lngs) {
              points.push_back(ll.ToPoint());
          }
          std::unique_ptr<S2Loop> loop = std::make_unique<S2Loop>(points);

          S2Polygon polygon(std::move(loop));

          S2LatLng test_point = S2LatLng::FromDegrees(37.422, -122.084);
          if (polygon.Contains(test_point.ToPoint())) {
              std::cout << "The point is inside the polygon." << std::endl;
          } else {
              std::cout << "The point is outside the polygon." << std::endl;
          }

          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
      "-L#{lib}", "-ls2", "-L#{Formula["abseil"].lib}", "-labsl_log_internal_message"
    system "./test"
  end
end
