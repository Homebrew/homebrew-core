class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "349151f900c5cd33a52a1dc68dfa3637a61001810e6a1fb80d8213b2ee554ea1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb55b93b0b5138ef7972b9e9f31571faecbd18e4ae13796a8017eaa21918e1a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb55b93b0b5138ef7972b9e9f31571faecbd18e4ae13796a8017eaa21918e1a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb55b93b0b5138ef7972b9e9f31571faecbd18e4ae13796a8017eaa21918e1a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b474d86496be61f6e3387578ff84f5d317b42605e54f696b25df617baea7730d"
    sha256 cellar: :any_skip_relocation, monterey:       "b474d86496be61f6e3387578ff84f5d317b42605e54f696b25df617baea7730d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b474d86496be61f6e3387578ff84f5d317b42605e54f696b25df617baea7730d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "497e73b1cf7f755775de1c7746626a11f0e0da56271a79cf86e89e560d252895"
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
