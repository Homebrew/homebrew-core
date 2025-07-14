class Rapidjson < Formula
  desc "JSON parser/generator for C++ with SAX and DOM style APIs"
  homepage "https://rapidjson.org/"
  license "MIT"
  head "https://github.com/Tencent/rapidjson.git", branch: "master"

  stable do
    url "https://github.com/Tencent/rapidjson/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "bf7ced29704a1e696fbccf2a2b4ea068e7774fa37f6d7dd4039d0787f8bed98e"

    # Backport fix for usage with recent GCC and Clang
    patch do
      url "https://github.com/Tencent/rapidjson/commit/9bd618f545ab647e2c3bcbf2f1d87423d6edf800.patch?full_index=1"
      sha256 "ce341a69d6c17852fddd5469b6aabe995fd5e3830379c12746a18c3ae858e0e1"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "ba505c9a587b3c26539eae5dd732ae36bca53b67daf94579fee177d88094fa52"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DRAPIDJSON_BUILD_DOC=OFF",
                    "-DRAPIDJSON_BUILD_EXAMPLES=OFF",
                    "-DRAPIDJSON_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    system ENV.cxx, "#{share}/doc/RapidJSON/examples/capitalize/capitalize.cpp", "-o", "capitalize"
    assert_equal '{"A":"B"}', pipe_output("./capitalize", '{"a":"b"}')
  end
end
