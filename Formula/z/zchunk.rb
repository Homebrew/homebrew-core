class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https://github.com/zchunk/zchunk"
  url "https://github.com/zchunk/zchunk/archive/refs/tags/1.3.1.tar.gz"
  sha256 "33ba1d6f5c83dbce75f8114ddbef1aa558938381fbaac0fa068eaf30c6ed2c60"
  license "BSD-2-Clause"
  head "https://github.com/zchunk/zchunk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "2bd78de00a11ccce4f9a7e5bbac6babe8d4556213477c72078b925ab83a4651c"
    sha256 cellar: :any, arm64_monterey: "5a0f82b054986fbb09937d2add7b8a8f78039cfae0e8ac925310f20a2e428163"
    sha256 cellar: :any, arm64_big_sur:  "47d1c93a89b2737ac1d73f159e6f50103f1ef57fa0ef04982d6652722bf75da4"
    sha256 cellar: :any, ventura:        "1dbb83b90c897d8468fbf18eec524fa3d3161f949ba9709bb4cde3ba60bb4b66"
    sha256 cellar: :any, monterey:       "279ff295e6c53d56b77f97bafb210b087cd4e3959f679241f19bba4b099a8376"
    sha256 cellar: :any, big_sur:        "92e0f9d5692f7bb7f73fff900d7624ff777c51a06e7cc1d0b73d1f20dbd06a19"
    sha256               x86_64_linux:   "b3dc877550a9e975f1d082c0e3e2949feae5939fddad77273f7f8c4df12ce08e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"zck", test_fixtures("test.png")
    system bin/"unzck", testpath/"test.png.zck"
    assert_equal test_fixtures("test.png").read, (testpath/"test.png").read
  end
end
