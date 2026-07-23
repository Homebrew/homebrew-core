class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v5.2.0/upx-5.2.0-src.tar.xz"
  sha256 "af99e526d5759de94412aea1104d5e4ca406cb725295f8633ecc9e843dc1ce1c"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51da9a0869e6003e6b52150991bc3413e143c2d904463a9b3e02b209c5c96c50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cc5f486361ab55029f268a4e925bda650badf6e84667512ab57cba98534a849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e71dbf87b2e1542670c37ed0857420f207611a90bfac06068d40441ffc3af53"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f706bd6f9dc383bb9de66b4852d3678d524426284ed13cea6e966f94e02ed70"
    sha256 cellar: :any,                 arm64_linux:   "66a9a166ac343471101de74881f623ecf79cc4c7334c78438b83e7220288605e"
    sha256 cellar: :any,                 x86_64_linux:  "842ce458295d0e01a3758c90d85994400ed43c8c158df1c0cdeed14db82e4f21"
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
