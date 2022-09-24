class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "a0b1dc198f9d38c36f0f6e502644ea060c84d352303cd53055497f0211871f13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c05b93b3ed3da141c2251771f082f92f921a94d28c35a69724d883a5e32ed0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c35743dc862f6f8314b20dcb8790e5e21498945a5d0ca733d2c2b160dabad9d"
    sha256 cellar: :any_skip_relocation, monterey:       "afaa8238d30bc864e7026bfd6cf29b1cddb78f6080e1328d1309acc8b45a85be"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b6ff127235b303ff079df61602c75cdcc19cc4e76ffda5f5083094f78ea9bc9"
    sha256 cellar: :any_skip_relocation, catalina:       "ee294ca26edcfd4960549cf052e99aa1fbb76a93e85736cd1cc6e8ecf6affeef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c723bc4dc1e0fe893ff8df16c4734f9424d22694265d9e3014525acf1f1833a"
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
