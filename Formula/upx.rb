class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-src.tar.xz"
  sha256 "1221e725b1a89e06739df27fae394d6bc88aedbe12f137c630ec772522cbc76f"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "ad32270c324e07cb3ff55008834932c59394f315e8d82ccd4ebb08c0917a633c"
    sha256 cellar: :any_skip_relocation, big_sur:      "5fc54db6b0fb2e8ebfa630d48c893e569e49b5c6795646d8912c447f3b0a1747"
    sha256 cellar: :any_skip_relocation, catalina:     "c04d7040eeaa8d2842449b86789ece0f0a73ee0ac1c013c6a00596288251abbc"
    sha256 cellar: :any_skip_relocation, mojave:       "a2253a74b3531dc9173eac2ae2ea816ff7b8af3657aee2180ca1253f49cd9fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4a00316a5883460cc1c16c75c93cb5a36d4e6ea1bbca394df82047715171d795"
  end

  depends_on "cmake" => :build
  depends_on "ucl" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{bin}/upx", "."
    chmod 0755, "./upx"

    system "#{bin}/upx", "-1", "--force-execve", "./upx"
    system "./upx", "-V" # make sure the binary we compressed works
    system "#{bin}/upx", "-d", "./upx"
  end
end
