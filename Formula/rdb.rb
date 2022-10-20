class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "a0b1dc198f9d38c36f0f6e502644ea060c84d352303cd53055497f0211871f13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "937c4774a0631b69695baec513cb85d605f00110a526e9332df8c43b7517c2bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3847cbea27de947ebbf02d1c4d17e91656389825793160f0c85ee424063f588"
    sha256 cellar: :any_skip_relocation, monterey:       "7ebf60ebedc53148134af2d105b1061b7cd7d0395c8aaf8a83dabf64f49edec9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a17460993c54b250ea5098d833ba1de44f05dcffe12be5b33200566243b499bb"
    sha256 cellar: :any_skip_relocation, catalina:       "f2577fe53b754c0b536107da44d2b7c1d9d3d182e23194d9e2c75cad120abab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9167e71b8cbbc470a3dc91175b62394369b7e0f7ce02110c22f034260ccdfa33"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "cases"
  end

  test do
    cp_r pkgshare/"cases", testpath
    system bin/"rdb", "-c", "memory", "-o", testpath/"mem1.csv", testpath/"cases/memory.rdb"
    assert_equal (testpath/"cases/memory.csv").read, (testpath/"mem1.csv").read
  end
end
