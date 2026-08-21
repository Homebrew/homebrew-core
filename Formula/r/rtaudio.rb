class Rtaudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://github.com/thestk/rtaudio"
  url "https://github.com/thestk/rtaudio/archive/refs/tags/6.0.1.tar.gz"
  sha256 "7206c8b6cee43b474f43d64988fefaadfdcfc4264ed38d8de5f5d0e6ddb0a123"
  license "MIT"
  head "https://github.com/thestk/rtaudio.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "636ce2d8b737d54f783dc197c20333d6476aa1c3f6a4999c43667d8b34caf7d3"
    sha256 cellar: :any,                 arm64_sequoia: "b68191b6cb2a95518f1287e8edc1a0a8891797be09d9bded1505e867e42c5864"
    sha256 cellar: :any,                 arm64_sonoma:  "09c7f13747d8cea17f268baf52de92bf1663a177dd891f86ea9641100903fef2"
    sha256 cellar: :any,                 sonoma:        "86d1af2e2535c239c7f101e9e6f9b7eb6e0843fca2564a37a63c3165800da785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "490c370e0ad9885447cc173c281ddc593c0d3be86536fcc293fd874758f61382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04dbca1518d5695c5c3f0123b05362787ab22f090c2a5fde271f52906fec5c4e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.cxx11
    system "./autogen.sh", "--no-configure"
    system "./configure", *std_configure_args
    system "make", "install"
    (pkgshare/"tests").install "tests/testall.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"tests/testall.cpp", "-o", "test", "-std=c++11",
           "-I#{include}/rtaudio", "-L#{lib}", "-lrtaudio"
    system "./test"
  end
end
