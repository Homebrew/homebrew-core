class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "40fe9b89f76266939abe6e8565fecdb2dde0dba30f84173c65ed6cb0afbe32a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92ffd958ccff8cb23a292b05020f608a5bc9f92d746f830d2861b902b6585914"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93b8a40b410523d20c0315336297499df1c6de1d6eee460910d20f4f6057a5ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b8a40b410523d20c0315336297499df1c6de1d6eee460910d20f4f6057a5ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93b8a40b410523d20c0315336297499df1c6de1d6eee460910d20f4f6057a5ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "33648612c014fb58c57c303cbaf1068486c5af7d7f2476b54e8c3379032143e3"
    sha256 cellar: :any_skip_relocation, ventura:       "33648612c014fb58c57c303cbaf1068486c5af7d7f2476b54e8c3379032143e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e3e2ef9e581dbd9eea5c5c29e4ecd555e725abb1713f1df0bb7d008ddf80966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5062866080f8ed9b34b681f19bea995f9d629c048d7304a7026e20cc0ba5dcaf"
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
