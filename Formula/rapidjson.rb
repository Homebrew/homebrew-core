class Rapidjson < Formula
  desc "JSON parser/generator for C++ with SAX and DOM style APIs"
  homepage "https://miloyip.github.io/rapidjson/"
  url "https://github.com/miloyip/rapidjson/archive/v1.0.2.tar.gz"
  sha256 "c3711ed2b3c76a5565ee9f0128bb4ec6753dbcc23450b713842df8f236d08666"
  head "https://github.com/miloyip/rapidjson.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "173bf62f8508a599f7524d8148d73fda3cbbd3ccff93e899359e4b0d889d2469" => :el_capitan
    sha256 "6557b78fa261a98c758bbffeb186c6e6219438f320793d7d7b02c75cccd049cc" => :yosemite
    sha256 "9a7dc86016ecb62a3583000542c3a394b72d7cc34d10c149ecbd66d73fd35aed" => :mavericks
  end

  option "without-docs", "Don't build documentation"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"

  def install
    args = std_cmake_args
    args << "-DRAPIDJSON_BUILD_DOC=OFF" if build.without? "docs"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system ENV.cxx, "#{share}/doc/RapidJSON/examples/capitalize/capitalize.cpp", "-o", "capitalize"
    assert_equal '{"A":"B"}', pipe_output("./capitalize", '{"a":"b"}')
  end
end
