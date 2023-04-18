class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "https://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.8.0.tar.gz"
  sha256 "59c86d5b2e452f63c5cdb29c866a12a4c55b1741d7025cf2f3ce0cde99b0660e"
  license "Zlib"
  head "https://github.com/htacg/tidy-html5.git", branch: "next"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*?[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "25de41a82adac06447528f20ebe466530708c86a7440c6d9f3dd122df90e5684"
    sha256 cellar: :any,                 arm64_monterey: "15f70f84c933bc11475f62c0cda4e1ccc72e5786bdbd64da76249fbfb35be8e5"
    sha256 cellar: :any,                 arm64_big_sur:  "de46584bc851655bae8d839b27b4423f8309e0c8de3923deb5be554a57617f45"
    sha256 cellar: :any,                 ventura:        "254a9044ebeb9ac00b4c45fa1df1513ab9f912acbcd82e2bf5afc31c8bb71245"
    sha256 cellar: :any,                 monterey:       "eb97c832fbe63a48464dee4dbef7a9e370906360dc36cd664af6a6abe738faec"
    sha256 cellar: :any,                 big_sur:        "9127cf10347816285db70f0ec794a08433e44426f9f4320d5fecedbdcfb15e2b"
    sha256 cellar: :any,                 catalina:       "fe486f6a2455b7c59eac3ba8a5e4b2e1a6ff49bb6440465d9470013a23a5fe0f"
    sha256 cellar: :any,                 mojave:         "4ae3afab500044dfd0fb4cf982ce9411859f50548149cc4f99f8720de1bbd754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f80a0abaed47dfa224213a413fbe6f23d1a538cf4bfeb633296f5e7e465fb2d"
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
    assert_match(/^<!DOCTYPE html>/, output)
    assert_match "HTML Tidy for HTML5", output
  end
end
