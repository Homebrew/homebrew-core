class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "3e495081d7ec5ad3cd35c7edcc6d2f0841601ca976eb281628c8a51ef9e1dbbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f5ffd5e87034dc38de93619379833c4485b483d9893deea5c61e89ab7eaa146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f5ffd5e87034dc38de93619379833c4485b483d9893deea5c61e89ab7eaa146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f5ffd5e87034dc38de93619379833c4485b483d9893deea5c61e89ab7eaa146"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e6696e7c2f03d501eeb2238beff5369e8d9b3c671babf3afe1d5ee3a3a427e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00d611e19ee3327a89f231a0763af90ef961c5fe59190cbd85f44e7a6ce9588b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e09d6b470d8ad19e3131d841d5d21f042c6b62c1e52eb34e2c78943073923b6d"
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
