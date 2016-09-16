class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  # Requested a tag 16 Sep 2016 https://github.com/Dushistov/sdcv/issues/10
  url "https://github.com/Dushistov/sdcv.git",
      :revision => "c347ae7da9b7969e00696b18035d9a7d200e43e3"
  version "0.5-2013-09-10"
  revision 1

  head "https://github.com/Dushistov/sdcv.git"

  bottle do
    sha256 "4d90fd23226a42bad21b652dc061feaf17d9340d35800e9806c00fa39161ae05" => :el_capitan
    sha256 "36c6097ca4bf57f0d84235d9143a3ab5ec6e542e122e94dc83cf88af0b3fd187" => :yosemite
    sha256 "c45cafd202569c4be52a68089a7fe1531dc7edc2a7b9bdd84b0749e7141cc6c6" => :mavericks
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
