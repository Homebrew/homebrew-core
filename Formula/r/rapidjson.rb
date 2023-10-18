class Rapidjson < Formula
  desc "JSON parser/generator for C++ with SAX and DOM style APIs"
  homepage "https://rapidjson.org/"
  url "https://github.com/Tencent/rapidjson/archive/v1.1.0.tar.gz"
  sha256 "bf7ced29704a1e696fbccf2a2b4ea068e7774fa37f6d7dd4039d0787f8bed98e"
  license "MIT"
  head "https://github.com/Tencent/rapidjson.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "97a2dc11fc6d7359450d3bee8c9b06b4ad1f141ea23b2b1b57eae9f9c9bcb0cf"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-DRAPIDJSON_BUILD_DOC=OFF",
                    "-DRAPIDJSON_BUILD_EXAMPLES=OFF",
                    "-DRAPIDJSON_BUILD_TESTS=OFF",
                    ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system ENV.cxx, "#{share}/doc/RapidJSON/examples/capitalize/capitalize.cpp", "-o", "capitalize"
    assert_equal '{"A":"B"}', pipe_output("./capitalize", '{"a":"b"}')
  end
end
