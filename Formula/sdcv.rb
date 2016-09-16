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
    sha256 "9ae2c835816921fbe2a6189b78509d5a92408a77723fcc3e7a4cf7c56d3a2a0f" => :el_capitan
    sha256 "f4aef462462c318d8649c07b23b31c1cff699de820e0fa2a6f908d7357f92086" => :yosemite
    sha256 "4c8b281d47b0a90f457eed9074349d5e8d8d32d481e9cec8b4ed05810c787380" => :mavericks
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
