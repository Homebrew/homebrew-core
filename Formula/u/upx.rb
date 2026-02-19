class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v5.1.0/upx-5.1.0-src.tar.xz"
  sha256 "9f7a810b8a810b1ca2c5cb01ffcf23066e3fb8a51ddc406ea05bdd5d37d0b8bd"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea8de1cee73e3c033a070b3fa33c9bed619efe82082d9cbf8c545f6bc1fd17b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b8730e894f00b5f36888f721fb0dee68bedd8b6888bc6b72cad6343d64580cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "269b3401ab172073e318512abb07ae06ca764c294f5b1aeb84cca93427d0a2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c07d79e2aa6fb3635540ed69d390221c00670954cc4ff37f0515881306d376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bbb2b44e8162af055e25a8e384c40fb8f3541f4f45cd5e71ffb330a7e0f7455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b44dc31ec96d3cd2eca8d4cd054fd1dba7bb898661883efb2448c57ae9c9b01e"
  end

  depends_on "cmake" => :build
  depends_on "ucl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"upx", "-1", "-o", "./hello", test_fixtures("elf/c.elf")
    assert_path_exists testpath/"hello"
    system bin/"upx", "-d", "./hello"
  end
end
