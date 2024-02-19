class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "e0e2609fb26b9baceccd0ccc98781d77d0360e6b89d13d5314fdab4771f202ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8e87b6f4ae658d84314fb80a6ba1364adc4a2e0cdab5bc5642d31515ac80a60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629e624289f89ae9ca350491593714bc9ffd12c44993e9d07d9ae876bb402b11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03eee18fbe014ab6be9a2e38ec15f130c51591d9335f1ca40be6b5f0ea185a67"
    sha256 cellar: :any_skip_relocation, sonoma:         "310320dba5a8bb792229415a48a4d21039088709de1518ead3cd17baba13692f"
    sha256 cellar: :any_skip_relocation, ventura:        "08786b45cb8246f588ed44bcc9f0b7f7fff26b3841573c8c6dcae6d337f11fda"
    sha256 cellar: :any_skip_relocation, monterey:       "250e21f5ee28891fcc469a6f2bd90b3a997238dd1c94127df0b15c592f901bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f32cbc2cd1ec79124230f063e6e69f7193d9f9eea1b2443e8969333872980b68"
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
