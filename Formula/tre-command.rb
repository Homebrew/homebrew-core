class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.3.3.tar.gz"
  sha256 "321a673e55397e80a0229537399f2c762a7d5196e3a486a684ea3c481e1d7bec"
  license "MIT"
  head "https://github.com/dduan/tre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "980b7e58d8f8f34d6e5b5e8edc99f1f336173c25f4f0310e8922e098ef5758e4" => :big_sur
    sha256 "4a3de40999d02154d60415f318533075ccf4170a918036bfe53c4659217e1c85" => :arm64_big_sur
    sha256 "bef95c814d73de29b1c9cc2e868191b86e9e1d1326c0a7c590dbbb45f159e060" => :catalina
    sha256 "56ffe7b2461747687c0caededfa6b3fd2094c1773744f3ea7660d6c6ce56f0c5" => :mojave
    sha256 "3c7d84087c637c80d13c29938d218ac442b841d1265552a6c383b28ad145204e" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manual/tre.1"
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end
