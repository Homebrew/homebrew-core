class Snzip < Formula
  desc "Compression/decompression tool based on snappy"
  homepage "https://github.com/kubo/snzip"
  url "https://github.com/kubo/snzip/releases/download/v1.0.5/snzip-1.0.5.tar.gz"
  sha256 "fbb6b816619628f385b62f44a00a1603be157fba6ed2d30de490b0c5e645bff8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "661bdc7469cf8ec9c6311512507b930896e62e5b86c97ee12b2ba5ef57c34dd4"
    sha256 cellar: :any,                 arm64_monterey: "f6e7e23067b3b7a345478140297d5eb874f3ab0d674fd1327e331ad44704c9c1"
    sha256 cellar: :any,                 arm64_big_sur:  "23f40e27a4ad634c07f15e736c6ed868ad78c780de0076c9c9d0206295f0d39f"
    sha256 cellar: :any,                 ventura:        "a6adec1343968056e505aea67415c4a8cd147fa82088dbc940ab1d69f9675d30"
    sha256 cellar: :any,                 monterey:       "fc6766844ef54540722dac85eb882b946db05d9db9d69fec810d77333c502224"
    sha256 cellar: :any,                 big_sur:        "60e584c91dcbc5f21a74cdeddd239a432911f99785350499873e04a7a91fcb7e"
    sha256 cellar: :any,                 catalina:       "41e8c6ce6c722fb30c57c820e2fee38d080b19332884284866b22b5584945c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba8de3ad67c0529384b55511515d68e132f76b8b7a6da0772c62c2fde0a5a8f5"
  end

  depends_on "snappy"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.out").write "test"
    system "#{bin}/snzip", "test.out"
    system "#{bin}/snzip", "-d", "test.out.sz"
  end
end
