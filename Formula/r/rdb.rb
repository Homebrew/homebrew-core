class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "d5e29babc24a21e9270a651c4fc4382bff8c62b5624ba754cc9f81cb8bb2073e"
  license "Apache-2.0"
  head "https://github.com/HDT3213/rdb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59096f5bd0c5a0ce3c0e0bbea0c07957f7444e93f831d8f32bfe66cb59dbc2d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59096f5bd0c5a0ce3c0e0bbea0c07957f7444e93f831d8f32bfe66cb59dbc2d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59096f5bd0c5a0ce3c0e0bbea0c07957f7444e93f831d8f32bfe66cb59dbc2d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb924b719636d6ca54ce25c2a0014ade0509251ac995ebad2706121e4f8f205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8f755db491c2468b7d6a377b9d9e909bd6f5b6568ac065196ff5e7d226b018f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0137f5abd23ff0fbd7aa7d306b42216b32fa98e9385d48c9ee14612b0132fe"
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
