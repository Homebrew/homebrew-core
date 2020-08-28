class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "http://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.9.0/zint-2.9.0.tar.gz"
  sha256 "fa02fa637f1cecb242bcc751f02710cda4026d41f8f60e0c60a8884525e56fea"
  license "GPL-3.0"
  head "https://git.code.sf.net/p/zint/code.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "18c124be12f21675b75c0fffca89bc9b219ab275f95fcd50bf96ccd7ca55195e" => :catalina
    sha256 "4860681d8e49db5793ffff5f54a5fd3c08b4a64ecea55683e9ed8d29f52e1a2f" => :mojave
    sha256 "ff0ffd2099c20c6574ddab3bd2a89eff262eda7b884a9c4983177d05fc7769df" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Sandbox fix: install FindZint.cmake in zint's prefix, not cmake's.
    inreplace "CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"

    mkdir "zint-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
