class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "755ee0c1e3eb78ee3b822a5797dea3f1ce6a85e1d61de7f6d2d8bb7d4df3c8ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f76ac684564650a5d7cf83089dd0d8b352b0633d43e3c423ca417953a969e6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8f50accc836e72b8d56a4ce543e38ff4bf87a141cbef8de787a66ef74f80abb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e752eadc644d214c763ea1d400f90ad95c06289f9c8937dca1313afcdd2abb75"
    sha256 cellar: :any_skip_relocation, ventura:        "7dfe6e355785199291c1cd9fae5a85ea120e4e7979c56aed7e1876fb55f8dc62"
    sha256 cellar: :any_skip_relocation, monterey:       "cbfec70dc88c64085f7131e2fc41442e7f09c82b364fe595ce967bdf1b1e3f18"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0a382a086a3479cc8125b151627c3a383fbddb51ef064a53a4a00a9e980f01a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca8fb62999788f7e7e9f8393e4c8a6fbeb14ab5318d135eedbbb51d1622656b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "cases"
  end

  test do
    cp_r pkgshare/"cases", testpath
    system bin/"rdb", "-c", "memory", "-o", testpath/"mem1.csv", testpath/"cases/memory.rdb"
    assert_match "0,hash,hash,131,131B,2,ziplist,", (testpath/"mem1.csv").read
  end
end
