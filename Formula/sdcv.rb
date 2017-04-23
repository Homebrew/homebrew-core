class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/v0.5.1.tar.gz"
  sha256 "d0c64429547adb127d5ff9f0f0db8c4bc663bc413dfb5b5d32c924a67171c247"
  version_scheme 1
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
