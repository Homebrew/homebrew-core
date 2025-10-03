class Uvw < Formula
  desc "Header-only, event based, tiny and easy to use libuv wrapper in modern C++"
  homepage "https://github.com/skypjack/uvw"
  url "https://github.com/skypjack/uvw/archive/refs/tags/v3.4.0_libuv_v1.48.tar.gz"
  version "3.4.0"
  sha256 "c16600573871a5feeb524234b378ab832c8971b2a68d030c6bd0e3077d416ade"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]libuv[._-]v?\d+(?:\.\d+)*)?$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "594413006be49d686f144c3122cb960e9eb204a9dbc3503dd7622b8051b61e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9ffd8957741528fa17ff2883d204d9a86f58bf13f1d2d12e11b9e23436412c1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd6b702c8f2b647f207611e843ec0d36731982a20b61759e9aae7465f5e8cb8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9cdb35b83cb69c02172ba1e43007e5d605d3fb4c3b3af40ebf24e34cd7dcba1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dfb062fab38ca015d435f5f324208a67a9414e2a823541eba2c720fb884af6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e9929a431e28be34456a3c4eeffa04c4b045a98e416acc4727423d54a2c6815"
    sha256 cellar: :any_skip_relocation, ventura:        "d4a069f5c1bbb5d81410483e2a1989498acd3788827abb2ee38d30f590f5b65e"
    sha256 cellar: :any_skip_relocation, monterey:       "8bc362bc8cb3cf30ea27a8d4f4f9b5cd44b8290b45b440f6b6da97a6b22a7284"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "612431aeef05fad9b635b106bdd5fde18f7d03b30de86ff5e64f0655696aed45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1df5b81661883a5eb47d2156a1def7b605a78d8270c255e8c367b347d8b06ceb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :test
  depends_on "libuv"

  def install
    args = %w[
      -DBUILD_UVW_LIBS=ON
      -DBUILD_DOCS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test_uvw)

      set(CMAKE_CXX_STANDARD 17)

      find_package(uvw REQUIRED)
      find_package(PkgConfig REQUIRED)
      pkg_check_modules(LIBUV REQUIRED libuv)

      add_executable(test main.cpp)
      target_include_directories(test PRIVATE ${uvw_INCLUDE_DIRS})
      target_link_libraries(test PRIVATE uvw::uvw uv)
    CMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <iostream>
      #include <uvw.hpp>

      int main() {
        auto loop = uvw::loop::get_default();
        auto timer = loop->resource<uvw::timer_handle>();

        timer->on<uvw::timer_event>([](const uvw::timer_event &, uvw::timer_handle &handle) {
          std::cout << "Timer event triggered!" << std::endl;
          handle.close();
        });

        timer->start(uvw::timer_handle::time{1000}, uvw::timer_handle::time{0});
        loop->run();
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
