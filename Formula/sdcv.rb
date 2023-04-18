class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/v0.5.4.tar.gz"
  sha256 "9fddec393f5dd6b208991d8225f90cb14d50fa9e7735f2414035d8a2ca065f28"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "7bf9e782fd9126e4d8c582764082573d80cd51d4763dadfa7cc2833f89835c50"
    sha256 arm64_monterey: "f819b0b764e2bba627f0ef84ef247eeb4e989b4be550740b9726c5e223d8d73a"
    sha256 arm64_big_sur:  "897d07ef6ff0e96fa6f80f1b1c03ebab1c71c56cdbb9f1fc4a4ab7642a374970"
    sha256 ventura:        "eed2c91aa0af273e725dc9f15228e814ab8605b92657b1860525b11149549dd8"
    sha256 monterey:       "3f2119bcba5db2e1fe772593aa2fc087a793b803582f74377b7c225b5975d82e"
    sha256 big_sur:        "5a36447672b0da89dbf187884d5cb2f7094c2acc7163e90f8f5ecdd19a078972"
    sha256 catalina:       "19ca163a4628c92850f96f7cf8d66f585670ad136001870dce00f1ab1256ab34"
    sha256 x86_64_linux:   "b713f386abc3931c2dc69c1db11d68f8ee481bef7b93c5658a18e71f04e04312"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"

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
