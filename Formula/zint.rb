class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.12.0/zint-2.12.0-src.tar.gz"
  sha256 "bf0a221b798abce65f48b003c0a23fa2fb184f5d35abd0eacc67d091aa9ac4bf"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/zint/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d89c9e5f12e807affc8246832cf6fc09b9142686f1e2b98a094056c7e18393e7"
    sha256 cellar: :any,                 arm64_monterey: "10a1e211d546ef3e6399a3bb9792463581eeb5d4173367ee10bba468d96557ef"
    sha256 cellar: :any,                 arm64_big_sur:  "b652ea342bec05e42f8a6c57b34e0832d2b0398be2c4a516f92afb5ba9c5da84"
    sha256 cellar: :any,                 ventura:        "6762ce448cfe022f44e0e11e508d988a135df4ab67ae07f3a02b16e104098912"
    sha256 cellar: :any,                 monterey:       "3c55cabca38ac6e88e80d829590932059e2712c89518929da281526f10e5cb27"
    sha256 cellar: :any,                 big_sur:        "2c3ffef826c78424b147a0cc40c62b4161b6a5470de6794caacbdb02460d3fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ee703a2ed639d7bcc32ac6d4c46e749585fd24b51f53126db3e09fbcf23076c"
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
