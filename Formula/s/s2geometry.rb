class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://github.com/google/s2geometry/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c09ec751c3043965a0d441e046a73c456c995e6063439a72290f661c1054d611"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "689158bec4823af485222c6becf747c71e7228e1388be24953b8fa07e0fe5093"
    sha256 cellar: :any,                 arm64_sonoma:  "3774ce8d8512a86d582d9a0658f6e09f47a4b6ad00ef978b5400dc0075d3cdf1"
    sha256 cellar: :any,                 arm64_ventura: "512c98088e5127681bccb469d255b64439fae1da123007ad08aaf7ed5deee29f"
    sha256 cellar: :any,                 sonoma:        "a119d4af6a3ce4a6c009d79d2f9cf79baeab8b30675ecc85b466e7627e99b4ac"
    sha256 cellar: :any,                 ventura:       "1935fbab3203bf75e46e5ee0a6007f6b483c10deb1138670b302bc976616e9ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22d6b564e53396c0f7aaf51394f83b96712f7c72aeb5b93ac70a6ccec9101aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "556106b11abf63169864a474b0add52cc2b1badec45f720fae8283246a2f2068"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "glog"
  depends_on "openssl@3"

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
