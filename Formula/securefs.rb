class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
      tag:      "0.11.1",
      revision: "dfeebf8406871d020848edde668234715356158c"
  license "MIT"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    cellar :any
    sha256 "8a8c7dd74f9b3082b2b128cc058714a27206d910273e4148959a25b7d30c51b5" => :catalina
    sha256 "9bee23af87518f68df56b862ad0ef88f842ebe65f8feff02e90bf5ab8e91522e" => :mojave
    sha256 "632496d8e9ed9fe91d18e9a2c9fef49c920dc091e10108246f8ab2056f75ea38" => :high_sierra
  end

  depends_on "cmake" => :build

  on_macos do
    deprecate! date: "2020-11-10", because: "requires FUSE"
    depends_on :osxfuse
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
