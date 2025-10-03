class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v5.0.2/upx-5.0.2-src.tar.xz"
  sha256 "209b219bbcfa58c249ffe6eba3c244e0910fa8be792b5521e4daf938167f05cc"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a10f0dbe257ac5d72be40562532c272d3fe14aa4c49c0f3454ec23f0691806e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "183ba13b8566966fb0f428fe17e887ffeea096c87e59c0be317b8552974f042d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fdcbfa167531022ea0a4fc110c9b96c95fed073027ae048b4357be3189dcaa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21354b0a85693c6c93d65b82ba60ea6d1cbfd13e5710fd8c9e262f5feded4d0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3802c1dede88d78c6d6799e807c0f2cb2b92d8baa1fe09806128c77ea3a0c2d6"
    sha256 cellar: :any_skip_relocation, ventura:       "921b8e0d57058148d566ad538cacfd3566a20b0f7d61eeb02f7c529f6859d0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a8479dbe20775134e426975ca1fcada5c4b0aafd4b9c31ff5b8cc45803d348e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "164093aeaaae9de464485858f091a3c5b7cba6a4f5e589fb12864c9ceb2cfa16"
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
