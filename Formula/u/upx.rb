class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v5.1.1/upx-5.1.1-src.tar.xz"
  sha256 "8eb914115b306fd9fd2110bd3d27ddb8ae7c5a03bb965f7d10f046a3a4ff9dfe"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea9792e388feed47fb93fa3ac4445c29da427c1c58ce7d61893bfebe07b432ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac81c14ccf5d7568cd7831dda33ee26adc2995f6688443e1d2c76a7034e20898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44cae4d0d58031d25b465bc0694db716baccca93dfbd2b436a2f76a34d54d8bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceace73c72ce5579b77e459c8c2cc0937dd59d996d3318239052de60b73189a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e9ee8e3613ef3434dff4dfed0ff37eb87406446a6c9cd5dfff4f8beff451754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae12d1951368371224a793b2fefbf7f76fb25eca11eaf32caf039fcd348c0b61"
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
