class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8046a0ac9ed10d2adff250ab5b95a95c895cae3b43d2a25bd95979f319146cb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a92d76029be74e6e1054212efab72af76a560a6a8d0288ab9aec8000d1d86bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddd47f185f466a92d5ac6bb26ee7e08ecb2c7595cd5d9350121c8b7f12e78f09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c20ed41dbe90016e92dce1366ddc4c8a9b2a7848c83ac670c533f1bea406dab6"
    sha256 cellar: :any_skip_relocation, ventura:        "6fbf2d6e3537108c68221bb1156fa714de8e8c2f4b3af546e5f4baa8ab01e485"
    sha256 cellar: :any_skip_relocation, monterey:       "6f18185442d50ccf97239ecbddd63f1fe188bc1ff81bfa855bea544df972278d"
    sha256 cellar: :any_skip_relocation, big_sur:        "54e1e64d590f22b6c9e10072da58f36352db0c8c47d35f65fd054c3179951ea9"
    sha256 cellar: :any_skip_relocation, catalina:       "8e6a7f185b201be9b246004b7d827999703c27ebf508295d69b2cdf1ec7c1b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73824757aad2952ed7c34b14e1312ac7132d8c8d038b66c392891297c2a36cdd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
