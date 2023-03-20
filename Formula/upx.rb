class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-src.tar.xz"
  sha256 "1221e725b1a89e06739df27fae394d6bc88aedbe12f137c630ec772522cbc76f"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "2e7f9c35cac2e339b6de8a3608f436314e7d8b2c4ee60689195a6bb9b3aeb7c9"
    sha256 cellar: :any_skip_relocation, big_sur:  "2ed424d5f94c10e279b0a03c08de69e07ee96f2eefe77d7ffaea6eddddaefb18"
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
