class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-src.tar.xz"
  sha256 "5ed6561607d27fb4ef346fc19f08a93696fa8fa127081e7a7114068306b8e1c4"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "784eb4d2d244872be35b8a8bd82900ce5789740950620b1a1119141361230b72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "228b152ff34d6dbd0b7e8aef959013f47b7401cb210fca682c991198cbe2e6c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ae84e5f420df6e56821d79bcaf34297b279f73a1b7bbf05c0f6c854358f5b0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "440dfc0b6936d53746398813a75c4f25d2dbe225692905e18f16d31484a263e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c9a802a2baa5dd6dbc36af16408984436a03fcac927ca62961e4c0e524a2258"
    sha256 cellar: :any_skip_relocation, ventura:        "aff62cfdbe4bd2c8ddfa370517d6b2a985ff9854dfc7e2ca930cb3b23ca3f9a8"
    sha256 cellar: :any_skip_relocation, monterey:       "269bbeecc1ba01485fe0f3a591e1f156e2eef1b35bf72b06d9f7969d9213815f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68bbcadfda1328f3a1cd71707feb194434f0a79b8c4542f43cdab27fe2a2c1cc"
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
    system bin/"upx", "-1", "-o", "./hello", test_fixtures("elf/hello")
    assert_path_exists testpath/"hello"
    system bin/"upx", "-d", "./hello"
  end
end
