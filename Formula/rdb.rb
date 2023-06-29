class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "a9916307b08300bd4e023b36e08f8cada0b8c003358278e0591cf298b4016de0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08eaf505ffcc631127319f3a5825a072df8718103c79e77b10b322d1a03f900d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08eaf505ffcc631127319f3a5825a072df8718103c79e77b10b322d1a03f900d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08eaf505ffcc631127319f3a5825a072df8718103c79e77b10b322d1a03f900d"
    sha256 cellar: :any_skip_relocation, ventura:        "2f48e34e14b8a81cb6c505ec895e1d81917b51be9b2bf32f3617f5e099b49b33"
    sha256 cellar: :any_skip_relocation, monterey:       "2f48e34e14b8a81cb6c505ec895e1d81917b51be9b2bf32f3617f5e099b49b33"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f48e34e14b8a81cb6c505ec895e1d81917b51be9b2bf32f3617f5e099b49b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba5cdbb9b7fc5978712875b89dd263695870c62a30a87b1a5be6d25f36d7c01"
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
