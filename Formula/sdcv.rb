class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/v0.5.2.tar.gz"
  sha256 "ec08dc084a0748d5a89df01a20bbf294f09b0366295cd418000f15d2e043c4f7"
  revision 1
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git"

  bottle do
    sha256 "b209cbb4840c5807cfa1c10285d2fe10bcb0e232f002cc55f691f1f5a28acb71" => :mojave
    sha256 "e6308c18ac35af9482344e8144a1adbfdc1acf6ca49aa590f1a8ee4d456f4694" => :high_sierra
    sha256 "e095b55dc837c81a8a5cd003579ed26cdfd20b2263b0ddca3adba1bdbf89390d" => :sierra
    sha256 "43faef6640e9a8a01c78ea7816828966e42fd2aa6a110d947a72e0c930b0ee50" => :el_capitan
    sha256 "f50d16cbcc92cc9bdfdea0aed25e10f8403f877f7a44830de420246eb2a4dfe7" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
