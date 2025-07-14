class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "db27f1f9ff917a062166771f19d5786bf1a509e6b8c298c942f2ae6c136b6294"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e092a6b244af0528dbcfc708ae545aa8b5417ac88a2664a99319c17d6094eec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e092a6b244af0528dbcfc708ae545aa8b5417ac88a2664a99319c17d6094eec9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e092a6b244af0528dbcfc708ae545aa8b5417ac88a2664a99319c17d6094eec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d16a96738a592a2824f7dac0413c77117a6bf830370f2f7c963ce431e5827c35"
    sha256 cellar: :any_skip_relocation, ventura:       "d16a96738a592a2824f7dac0413c77117a6bf830370f2f7c963ce431e5827c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27356076b1c40fc0c40aaa86a5007d3d5ddead10fecd7aa0ea791c22099f9006"
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
