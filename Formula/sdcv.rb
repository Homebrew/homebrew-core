class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  # Requested a tag 16 Sep 2016 https://github.com/Dushistov/sdcv/issues/10
  url "https://github.com/Dushistov/sdcv.git",
      :revision => "c347ae7da9b7969e00696b18035d9a7d200e43e3"
  version "0.5-2013-09-10"
  revision 2

  head "https://github.com/Dushistov/sdcv.git"

  bottle do
    sha256 "09a194ebd5c0b549df0e5b23d42e39ecf9e4103acc94940a00cc5ca9a3e75cc7" => :sierra
    sha256 "4e8d8fe4b13b92c82dc0047dcf8b0f1aaee482d355ec1a19ad49623675d4e371" => :el_capitan
    sha256 "481df7fdcbacc61fdde3706b750c6e7e2c873f2134bbbac8044262a192af2e2f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"

  # see: https://github.com/Homebrew/homebrew/issues/26321
  needs :cxx11

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "lang"
      system "make", "install"
    end
  end

  test do
    system bin/"sdcv", "-h"
  end
end
