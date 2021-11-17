class Yj < Formula
  desc "CLI to convert between YAML, TOML, JSON and HCL"
  homepage "https://github.com/sclevine/yj"
  url "https://github.com/sclevine/yj/archive/v5.0.0.tar.gz"
  sha256 "df9a4f5b6d067842ea3da68ff92c374b98560dce1086337d39963a1346120574"
  license "Apache-2.0"
  head "https://github.com/sclevine/yj.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ac2fc3bf4625447840613f6c998565f25ba35f2ad39bf5d6d756807691bb967"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9093ad6c4366b3d6cd6d37b1300f1e80fbd30b051e3d934a498db64c46bed6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "86518dd9cb0b7c51203fa9c684649c293d420b1548c1b6cf340bc3eb7ba39746"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c1c51234dc8c8590af22184be13472c9939426c98db9c9bcd58fade1cbb1840"
    sha256 cellar: :any_skip_relocation, catalina:       "918450aaf162067fe6fa7979518a7fc998853a4ab215c01f2c69e756739fb710"
    sha256 cellar: :any_skip_relocation, mojave:         "918450aaf162067fe6fa7979518a7fc998853a4ab215c01f2c69e756739fb710"
    sha256 cellar: :any_skip_relocation, high_sierra:    "918450aaf162067fe6fa7979518a7fc998853a4ab215c01f2c69e756739fb710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "229cf652c16b0285d26f043c5f3197a8fad33b6099bd2d6377916aadc1855886"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.Version=#{version}", *std_go_args
  end

  test do
    assert_match '{"a":1}', pipe_output("#{bin}/yj -t", "a=1")
  end
end
