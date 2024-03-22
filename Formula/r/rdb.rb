class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.16.tar.gz"
  sha256 "1609ba3852a9b1302e133b7353bed79f3c319ed0a7d6b42fedd489b3bc7cfe51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ca73ef35d024d4c1bc2c4e8a18d855d971d8dc08394d242a6a143b51161c7fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d5e69df44af05c7cf3bc95089503d7bb7e9ec1174e65043554d1add527b5813"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05503ab3ee56ab2c1a34189daec14445f25313be84bc05550bbc3347af5614d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c96d75e2213678d7f5364840f684fe423a38950e2fbbc385d209b0aeb6227ac1"
    sha256 cellar: :any_skip_relocation, ventura:        "55a8e0a50b8a06f66971b79c47b2c260e24885464fe7af03d6f3963cff4a4f39"
    sha256 cellar: :any_skip_relocation, monterey:       "72c5f7d1c796e91b1b21ee13c8b280913464c1c9fe88c4817fbdcb1792a20225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2938e89db70bf767cb86aba85fd503831a5ceeb5b4564dc9c03045fd7143abea"
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
