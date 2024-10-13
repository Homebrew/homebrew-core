class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://github.com/google/s2geometry/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "bdbeb8ebdb88fa934257caf81bb44b55711617a3ab4fdec2c3cfd6cc31b61734"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "42a3c92e44c8a87963d691a53ef3ea50efeb0aeef11e4678af4e58f4cf673995"
    sha256 cellar: :any,                 arm64_sonoma:   "182a06b04d14b0bbfec1bd35d4b1dc70f19fad84a83886fb206e2867a230c5bf"
    sha256 cellar: :any,                 arm64_ventura:  "93b5347b89211b4644a76a6f2295cb67bbbe7a39d02d2db417b6bde16555d787"
    sha256 cellar: :any,                 arm64_monterey: "2f48215b6cbe1a2adc02816547f5e74451834d8699ec930561cdef84400b3c03"
    sha256 cellar: :any,                 sonoma:         "925bb60f693beab6ecb42552c015359e83c228ff9e2830daf392ea30fe30a4c9"
    sha256 cellar: :any,                 ventura:        "eb04ac86cf47797fbe79dbf6f0d47bef60989751856b90f8d687fb38ed92a0ad"
    sha256 cellar: :any,                 monterey:       "01e0d337b9c57c8143bdafb2f8f669992dd4bf9aa74f7d010bed080ad30ab04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6134ee01fed57ff44842e5131ae7844e0f152c08679aa65a6c6cbdfedd8d5cda"
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
