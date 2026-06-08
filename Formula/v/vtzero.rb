class Vtzero < Formula
  desc "Minimalist vector tile decoder and encoder in C++"
  homepage "https://github.com/mapbox/vtzero"
  url "https://github.com/mapbox/vtzero/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bdbd4a70404fbd6efc8588cc34065aa401b3bcd2533b532e68ff790267f4fc23"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7edfaf64ec1282ee246f33e362201810ea0c633a609569f021f80c5b4e207601"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "protozero" => :no_linkage

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <vtzero/builder.hpp>
      #include <vtzero/vector_tile.hpp>
      #include <cassert>
      #include <string>

      int main() {
          vtzero::tile_builder tile;
          vtzero::layer_builder layer{tile, "test_layer"};
          vtzero::point_feature_builder feature{layer};
          feature.set_id(42);
          feature.add_point(10, 20);
          feature.add_property("name", "homebrew");
          feature.commit();

          const std::string data = tile.serialize();
          assert(!data.empty());

          vtzero::vector_tile decoded{data};
          assert(decoded.count_layers() == 1);
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}",
                    "-I#{Formula["protozero"].opt_include}", "-o", "test"
    system "./test"
  end
end
