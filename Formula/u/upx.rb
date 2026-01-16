class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v5.1.0/upx-5.1.0-src.tar.xz"
  sha256 "9f7a810b8a810b1ca2c5cb01ffcf23066e3fb8a51ddc406ea05bdd5d37d0b8bd"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4ebde3877f05d87b6de56f376f781973138dd7cd571b8226b8f5909ed2366d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5764837b7a4307a62ab3dacee48265d9403d4a3ad943a0c6e3ebd6f2afacc18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00a0b48fe65fcfe3685d2a15e49069296978326ba58656c793d11194d34026b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "acdf3dac97fdaa2db80c1594edd245ffcfa0434e6d1e90cdf929b9b5a4fe920a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ddb61d7777d87a7553fe292b17738f23e48772dcb7c27bc85256c80c1aa25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12eac546886d5fca0594fd1a704c7449456cf25e50b8e3d84704223a81695300"
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
    system bin/"upx", "-1", "-o", "./hello", test_fixtures("elf/c.elf")
    assert_path_exists testpath/"hello"
    system bin/"upx", "-d", "./hello"
  end
end
