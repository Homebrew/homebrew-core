class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https://github.com/zchunk/zchunk"
  url "https://github.com/zchunk/zchunk/archive/refs/tags/1.5.3.tar.gz"
  sha256 "832381dafe192109742c141ab90a6bc0a9d7e9926a4bafbdf98f596680da2a95"
  license "BSD-2-Clause"
  head "https://github.com/zchunk/zchunk.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7feea8c537bef441a0f60256f5d3b2aeb6a638f457046193a9a4516cae340591"
    sha256 cellar: :any, arm64_sequoia: "46d65e395c918847f94dcf2c15e2d70ae11bac1c958ef1327ef4938b0e6da602"
    sha256 cellar: :any, arm64_sonoma:  "d29d020334ff33c8baf0e51e01abb8c10ebd015130113c1f7739e6c08985fb94"
    sha256 cellar: :any, sonoma:        "4405ca51d11f44a125c9f8f01ba44f75a03291bde66614b0e2cf661f259b72ee"
    sha256               arm64_linux:   "7b24464b573af8a39c03bc310a9b4459fb09b735859352f56522d78cb30dec1b"
    sha256               x86_64_linux:  "2149273e6d030878b48169a874ad91eeec79bc53fb3ccdd13a9cdd6c4bb473a6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"
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
