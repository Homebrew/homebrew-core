class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.4.0.tar.gz"
  sha256 "a2d754b7349982e33f12d798780316c047a3b264240dc6bbd4641542e57a0b7a"
  head "https://github.com/htacg/tidy-html5.git"

  bottle do
    cellar :any
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
