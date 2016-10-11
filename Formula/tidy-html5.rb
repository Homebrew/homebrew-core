class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.2.0.tar.gz"
  sha256 "80533415acf11ac55f24b874ab39448e390ffec3c2b93df4b857d15602fc7c4d"

  bottle do
    cellar :any
    sha256 "13c0baa6b6195b8adc948328177d4bc3bd9777b7ed7c756a76155ce4defe18c0" => :sierra
    sha256 "ea943c15cd5e364901517f2f423aa615eb701f180d0db617428bf5cbd03362be" => :el_capitan
    sha256 "c6bd4b2ff01a8e2c0583fdbe665cf5f9a282cafe548c52bfd5c180d36c56ef89" => :yosemite
    sha256 "0ab1735f830a593c4bb6567e427457abfc501e6211f12c547f5017b72dff8696" => :mavericks
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
