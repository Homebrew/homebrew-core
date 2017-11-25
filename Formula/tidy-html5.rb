class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.6.0.tar.gz"
  sha256 "08a63bba3d9e7618d1570b4ecd6a7daa83c8e18a41c82455b6308bc11fe34958"
  head "https://github.com/htacg/tidy-html5.git", :branch => "next"

  bottle do
    cellar :any
    sha256 "2592b1f250979b968077b63a9f3d8f5bb128fc865717ebca32f014673ad62371" => :high_sierra
    sha256 "b4f78319077f68e2fabaed0ab36a290959043239433b20f48b1e557bc1d096d7" => :sierra
    sha256 "b4b784e2d662630e9d1c018accbcd3ccf850fce9ec789c92919999ab8c284bbd" => :el_capitan
    sha256 "f83de436c232d1b8abc837c851db4e9f1967c5f8cde409a577097a465bd20bd0" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    cd "build/cmake"
    system "cmake", "../..", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    output = pipe_output(bin/"tidy -q", "<!doctype html><title></title>")
    assert_match /^<!DOCTYPE html>/, output
    assert_match /HTML Tidy for HTML5/, output
  end
end
