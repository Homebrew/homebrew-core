class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v5.3.0/upx-5.3.0-src.tar.xz"
  sha256 "6229b5564dd91dd423a5280a7c15b70fc05449d2605bb853ce076743057fcf55"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0221455439f71bae5c477e0d9bf910d11ce06807ec2eb4ce76060777a1925fd8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d386010d5ee741e78644f2c81ff1f5b4aac24c90d0fd66594967f1669050ea46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d681512b0e136be5bb26c289c69afb0773f2520f02b731e94c3b554eecf8ea0e"
    sha256 cellar: :any,                 arm64_linux:       "8ce472a508224feaf8bda4f20525fbff4917682f95b82590c3121f2cab4935e9"
    sha256 cellar: :any,                 x86_64_linux:      "0ab28030c8c138dac11167b43f2be9c4cec29562b48986e0140ead780bb888f1"
  end

  depends_on "cmake" => :build
  depends_on "ucl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
