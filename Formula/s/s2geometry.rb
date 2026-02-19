class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://github.com/google/s2geometry/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "df001f8352dce083a87b74646bcbc65fbbcd039646bda5b64adfda1e2ea32d47"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f79d0c4a802ebb6534abcf48d19ff6b23e7b3dd2f00bacab751be2795b17ee5"
    sha256 cellar: :any,                 arm64_sequoia: "97278dc633347c47bdb0ab98b766f3e0d878ddb69ab42d07deae9d28222b7c0f"
    sha256 cellar: :any,                 arm64_sonoma:  "04808ef92b7db6eb5f653296206f4e228136db79fea36ca811ea31d7e3a3b582"
    sha256 cellar: :any,                 sonoma:        "e619f78302f4cf5ec4a2977fc7a1d7f3a03703a7f0d64ffd15190554afaa5b26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0134241899aea80e57425a5acc31198a3d43722551e523186ef9693786ba7c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "781a1286862396a5a038f772d972654fb61087bf9f7d1a872a6d05bcb4982bbe"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "openssl@3"

  def install
    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]

    # Fix missing include of unaligned.h
    # Issue ref: https://github.com/google/s2geometry/issues/481
    inreplace "CMakeLists.txt", "src/s2/util/gtl/requires.h", "\\0 src/s2/util/gtl/unaligned.h"

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
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
      "-L#{lib}", "-ls2", "-L#{Formula["abseil"].lib}", "-labsl_log_internal_message"
    system "./test"
  end
end
