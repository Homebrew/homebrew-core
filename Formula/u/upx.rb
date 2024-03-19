class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v4.1.0/upx-4.1.0-src.tar.xz"
  sha256 "0582f78b517ea87ba1caa6e8c111474f58edd167e5f01f074d7d9ca2f81d47d0"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "db18963055dd657d579824a7daaf69f79e1639a10fd1accb399e84ddcd5d649c"
    sha256 cellar: :any_skip_relocation, big_sur:  "8e6aa21f689985270ff1cc3857ef9848f63f3c79a96604884ee846ce76e6401b"
  end

  # https://github.com/upx/upx/issues/612
  deprecate! date: "2023-10-14", because: "is crashing for macOS Ventura or above"

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
